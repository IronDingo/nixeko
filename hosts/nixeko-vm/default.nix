{ config, lib, pkgs, nixos-hardware, ... }:

# nixeko-vm — test build target (no NVIDIA, no Dell hardware)
# Use this to verify the config builds before touching the laptop.
#
# Build: nixos-rebuild build --flake .#nixeko-vm
# Run:   nixos-rebuild build-vm --flake .#nixeko-vm && ./result/bin/run-nixeko-vm-vm

let u = config.nixeko.username; in

{
  imports = [
    ./hardware-configuration.nix
  ] ++ lib.optional (config.nixeko.hardwareModule != "")
        nixos-hardware.nixosModules.${config.nixeko.hardwareModule};

  boot.loader = {
    systemd-boot.enable     = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = config.nixeko.hostname;

  time.timeZone      = "Europe/Berlin"; # VM only — doesn't matter for testing
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${u} = {
    isNormalUser    = true;
    description     = u;
    extraGroups     = [ "wheel" "docker" "networkmanager" ];
    shell           = pkgs.bash;
    # For VM testing — remove on real install
    initialPassword = "nixeko";
  };

  nixpkgs.config.allowUnfree = true;

  programs.hyprland = {
    enable          = true;
    xwayland.enable = true;
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # VM display driver
  services.xserver.videoDrivers = [ "virtio" ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store   = true;
    };
  };

  system.stateVersion = "24.11";
}
