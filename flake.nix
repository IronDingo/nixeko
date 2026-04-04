{
  description = "nixeko — a self-contained NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    stylix.url = "github:danth/stylix";

    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, stylix, nur, ... }:
  let
    homeManagerModule = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.eko = import ./home/eko.nix;  # CHANGE: replace "eko" with your username (also update hosts/nixeko/default.nix)
    };

    sharedModules = [
      stylix.nixosModules.stylix
      nur.nixosModules.nur
      ./modules/system/base.nix
      ./modules/system/theme.nix
      ./modules/system/security.nix
      ./modules/system/networking.nix
      ./modules/system/services.nix
      ./modules/system/printing.nix
      ./modules/system/vpn.nix
      home-manager.nixosModules.home-manager
      homeManagerModule
    ];
  in
  {
    nixosConfigurations = {

      # ── Main machine — Intel + NVIDIA (bus IDs auto-patched by install wizard) ─
      nixeko = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [
          nixos-hardware.nixosModules.dell-g15-5530
          ./modules/system/nvidia.nix
          ./hosts/nixeko
        ];
      };

      # ── VM target — test builds without real hardware ────────────────────────
      # Build:   nixos-rebuild build --flake .#nixeko-vm
      # Run VM:  nixos-rebuild build-vm --flake .#nixeko-vm && ./result/bin/run-nixeko-vm-vm
      nixeko-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = sharedModules ++ [
          ./hosts/nixeko-vm
        ];
      };

    };
  };
}
