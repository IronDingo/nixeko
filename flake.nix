{
  description = "nixeko — a self-contained NixOS configuration";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    home-manager     = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    stylix.url       = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, stylix, ... }:
  let
    # Wrap a home config file into the home-manager module format.
    # CHANGE: replace "eko" with your username (also update each hosts/*/default.nix)
    homeFor = file: {
      home-manager.useGlobalPkgs    = true;
      home-manager.useUserPackages  = true;
      home-manager.users.eko        = import file;
    };

    # Core system modules — shared by all profiles
    coreModules = [
      stylix.nixosModules.stylix
      ./modules/system/base.nix
      ./modules/system/theme.nix
      ./modules/system/security.nix
      ./modules/system/networking.nix
      ./modules/system/services.nix
      ./modules/system/printing.nix
      ./modules/system/vpn.nix
      home-manager.nixosModules.home-manager
    ];
  in
  {
    nixosConfigurations = {

      # ── nixeko — full Hyprland ────────────────────────────────────────────���────
      # Install: sudo bash bin/nixeko-install  (wizard handles everything)
      nixeko = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = coreModules ++ [
          (homeFor ./home/eko.nix)
          ./hosts/nixeko
          # NIXOS_HARDWARE: none   ← patched by install wizard
          # NVIDIA_MODULE: none    ← patched by install wizard
        ];
      };

      # ── nixeko-dinghy — BSPWM, lean and fast ─────────────────────────────────
      nixeko-dinghy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = coreModules ++ [
          (homeFor ./home/dinghy.nix)
          ./hosts/nixeko-dinghy
          # NIXOS_HARDWARE: none   ← patched by install wizard
          # NVIDIA_MODULE: none    ← patched by install wizard
        ];
      };

      # ── nixeko-beacon — headless, no display server ───────────────────────────
      nixeko-beacon = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = coreModules ++ [
          (homeFor ./home/beacon.nix)
          ./hosts/nixeko-beacon
          # NIXOS_HARDWARE: none   ← patched by install wizard
        ];
      };

      # ── nixeko-vm — QEMU test target (no hardware specifics) ─────────────────
      # Build: nix build .#nixosConfigurations.nixeko-vm.config.system.build.toplevel
      # Run:   nix build .#nixosConfigurations.nixeko-vm.config.system.build.vm && ./result/bin/run-nixeko-vm-vm
      nixeko-vm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = coreModules ++ [
          (homeFor ./home/eko.nix)
          ./hosts/nixeko-vm
        ];
      };

    };
  };
}
