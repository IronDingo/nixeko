{
  description = "nixeko — eko's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, stylix, ... }:
  let
    homeManagerModule = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.eko = import ./home/eko.nix;
    };

    sharedModules = [
      stylix.nixosModules.stylix
      ./modules/system/base.nix
      ./modules/system/theme.nix
      ./modules/system/security.nix
      ./modules/system/networking.nix
      ./modules/system/services.nix
      ./modules/system/vpn.nix
      home-manager.nixosModules.home-manager
      homeManagerModule
    ];
  in
  {
    nixosConfigurations = {

      # ── Main machine — Dell G15 5530 (Intel + NVIDIA RTX 4060) ──────────────
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
