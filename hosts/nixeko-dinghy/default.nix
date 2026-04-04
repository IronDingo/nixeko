{ config, pkgs, ... }:

# nixeko-dinghy — BSPWM host config
# A nimble craft. X11, lean, fast.

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable      = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixeko-dinghy";

  time.timeZone       = "Europe/London"; # CHANGE ME
  i18n.defaultLocale  = "en_US.UTF-8";

  # X11 + BSPWM
  services.xserver = {
    enable       = true;
    windowManager.bspwm.enable = true;
    displayManager.lightdm = {
      enable    = true;
      greeters.gtk.enable = true;
    };
  };

  # User
  users.users.eko = {
    isNormalUser = true;
    description  = "eko";
    extraGroups  = [ "wheel" "docker" "video" "audio" "networkmanager" "libvirtd" ];
    shell        = pkgs.bash;
  };

  nixpkgs.config.allowUnfree = true;

  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable              = true;
    polkitPolicyOwners  = [ "eko" ];
  };

  # Steam
  programs.steam = {
    enable               = true;
    remotePlay.openFirewall = true;
  };

  programs.gamemode.enable = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store    = true;
    gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 30d"; };
  };

  system.stateVersion = "24.11";
}
