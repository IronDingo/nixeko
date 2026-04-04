{ config, pkgs, ... }:

# nixeko-beacon — headless host config
# Hull and engines only. No display server.
# SSH in. Get to work.

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable      = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixeko-beacon";

  time.timeZone       = "Europe/London"; # CHANGE ME
  i18n.defaultLocale  = "en_US.UTF-8";

  # User
  users.users.eko = {
    isNormalUser  = true;
    description   = "eko";
    extraGroups   = [ "wheel" "docker" "networkmanager" ];
    shell         = pkgs.bash;
    # Add your SSH public key here for passwordless login:
    # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
  };

  # SSH
  services.openssh = {
    enable                = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin        = "no";
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store    = true;
    gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 30d"; };
  };

  system.stateVersion = "24.11";
}
