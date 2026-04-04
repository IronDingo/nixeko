{ config, pkgs, ... }:

{
  # Pipewire audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true; # needed for pipewire realtime priority

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.cascadia-code
    nerd-fonts.victor-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  # XDG portals for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Polkit for GUI auth prompts
  security.polkit.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;

  # Firmware updates
  services.fwupd.enable = true;

  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [ cups-filters ];
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # GNOME keyring for secret storage
  services.gnome.gnome-keyring.enable = true;

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # start on demand
  };

  # libvirt / QEMU / virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "eko";
    dataDir = "/home/eko/Syncthing-Master";
    configDir = "/home/eko/.config/syncthing";
    openDefaultPorts = true;
  };

  # Tailscale
  services.tailscale.enable = true;

  # Flatpak (for LibreWolf and other flatpaks)
  services.flatpak.enable = true;

  # Timezone auto-update
  services.automatic-timezoned.enable = true;

  # zram swap
  zramSwap.enable = true;
}
