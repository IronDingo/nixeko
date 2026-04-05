{ config, lib, pkgs, nixos-hardware, ... }:

let u = config.nixeko.username; in

{
  imports = [
    ./hardware-configuration.nix
  ] ++ lib.optional (config.nixeko.hardwareModule != "")
        nixos-hardware.nixosModules.${config.nixeko.hardwareModule}
    ++ lib.optional config.nixeko.hasNvidia
        ../../modules/system/nvidia.nix;

  # Bootloader
  boot.loader = {
    systemd-boot.enable     = true;
    efi.canTouchEfiVariables = true;
  };

  # Kernel — latest for best hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = config.nixeko.hostname;

  # Locale & timezone — change to your region
  time.timeZone      = "Europe/London"; # CHANGE ME — timedatectl list-timezones
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${u} = {
    isNormalUser = true;
    description  = u;
    extraGroups  = [ "wheel" "docker" "video" "audio" "networkmanager" "libvirtd" ];
    shell        = pkgs.bash;
  };

  nixpkgs.config.allowUnfree = true;

  # Hyprland
  programs.hyprland = {
    enable          = true;
    xwayland.enable = true;
  };

  # Hyprland XDG portal (supplements the GTK portal set in base.nix)
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # 1Password — needs special system integration
  programs._1password.enable = true;
  programs._1password-gui = {
    enable             = true;
    polkitPolicyOwners = [ u ];
  };

  # Steam
  programs.steam = {
    enable                  = true;
    remotePlay.openFirewall  = true;
    gamescopeSession.enable  = true;
  };

  programs.gamemode.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store   = true;
    };
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };
  };

  system.stateVersion = "24.11";
}
