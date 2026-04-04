{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Kernel — latest for best hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Hostname — set by the install wizard, or change manually
  networking.hostName = "nixeko";

  # Locale & timezone — change to your region
  time.timeZone = "Europe/London"; # CHANGE ME — timedatectl list-timezones
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.eko = {
    isNormalUser = true;
    description = "eko";
    extraGroups = [ "wheel" "docker" "video" "audio" "networkmanager" "libvirtd" ];
    shell = pkgs.bash;
  };

  # Allow unfree packages (spotify, obsidian, nvidia, etc.)
  nixpkgs.config.allowUnfree = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # 1Password — needs special system integration
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "eko" ];
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Gamemode
  programs.gamemode.enable = true;

  # Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  system.stateVersion = "24.11";
}
