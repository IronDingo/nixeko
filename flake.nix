{
  description = "nixeko — a self-contained NixOS configuration";

  inputs = {
    nixpkgs.url        = "github:nixos/nixpkgs/nixos-unstable";
    home-manager       = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-hardware.url = "github:nixos/nixos-hardware";
    stylix.url         = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, stylix, ... }:
  let
    # homeFor wires a home-manager config file into the NixOS module system.
    # It is a *module function* so it can read config.nixeko.username at eval time —
    # no more hardcoded "eko" and no renaming files at install time.
    homeFor = file: { config, ... }: {
      home-manager.useGlobalPkgs    = true;
      home-manager.useUserPackages  = true;
      home-manager.extraSpecialArgs = { inherit (config.nixeko) username; };
      home-manager.users.${config.nixeko.username} = import file;
    };

    # Core modules shared by every profile.
    # nixeko-params.nix defines the nixeko.* options; each host's params.nix sets them.
    coreModules = [
      stylix.nixosModules.stylix
      ./modules/nixeko-params.nix
      ./modules/system/base.nix
      ./modules/system/theme.nix
      ./modules/system/security.nix
      ./modules/system/networking.nix
      ./modules/system/services.nix
      ./modules/system/printing.nix
      ./modules/system/vpn.nix
      home-manager.nixosModules.home-manager
    ];

    # nixos-hardware is passed to all host modules via specialArgs so they can
    # conditionally import hardware modules via lib.optional.
    mkSystem = modules: nixpkgs.lib.nixosSystem {
      system      = "x86_64-linux";
      specialArgs = { inherit nixos-hardware; };
      modules     = coreModules ++ modules;
    };
  in
  {
    nixosConfigurations = {

      # ── nixeko — full Hyprland desktop ───────────────────────────────────────
      # Install: sudo bash bin/nixeko-install  (wizard handles everything)
      nixeko = mkSystem [
        (homeFor ./home/eko.nix)
        ./hosts/nixeko/params.nix
        ./hosts/nixeko
      ];

      # ── nixeko-dinghy — BSPWM, lean and fast ─────────────────────────────────
      nixeko-dinghy = mkSystem [
        (homeFor ./home/dinghy.nix)
        ./hosts/nixeko-dinghy/params.nix
        ./hosts/nixeko-dinghy
      ];

      # ── nixeko-beacon — headless, no display server ───────────────────────────
      nixeko-beacon = mkSystem [
        (homeFor ./home/beacon.nix)
        ./hosts/nixeko-beacon/params.nix
        ./hosts/nixeko-beacon
      ];

      # ── nixeko-vm — QEMU test target (no hardware specifics) ─────────────────
      # Build: nix build .#nixosConfigurations.nixeko-vm.config.system.build.toplevel
      # Run:   nixos-rebuild build-vm --flake .#nixeko-vm && ./result/bin/run-nixeko-vm-vm
      nixeko-vm = mkSystem [
        (homeFor ./home/eko.nix)
        ./hosts/nixeko-vm/params.nix
        ./hosts/nixeko-vm
      ];

    };
  };
}
