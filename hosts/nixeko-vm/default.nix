{ config, pkgs, ... }:

# nixeko-vm — test build target (no NVIDIA, no Dell hardware)
# Use this to verify the config builds before touching the laptop.
#
# Build: nixos-rebuild build --flake .#nixeko-vm
# Run:   nixos-rebuild build-vm --flake .#nixeko-vm && ./result/bin/run-nixeko-vm-vm

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "nixeko-vm";

  time.timeZone = "Europe/Berlin"; # VM only — doesn't matter for testing
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.eko = {
    isNormalUser = true;
    description = "eko";
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    shell = pkgs.bash;
    # For VM testing — remove on real install
    initialPassword = "nixeko";
  };

  nixpkgs.config.allowUnfree = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  # VM display driver
  services.xserver.videoDrivers = [ "virtio" ];

  system.stateVersion = "24.11";
}
