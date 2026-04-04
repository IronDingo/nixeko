{ ... }:

{
  home.file.".local/bin/vpn-menu" = {
    source     = ./scripts/vpn-menu.sh;
    executable = true;
  };

  home.file.".local/bin/pihole-menu" = {
    source     = ./scripts/pihole-menu.sh;
    executable = true;
  };

  home.file.".local/bin/power-menu" = {
    source     = ./scripts/power-menu.sh;
    executable = true;
  };

  # Nautilus sidebar bookmarks — quick access to key locations
  home.file.".config/gtk-3.0/bookmarks".text = ''
    file:///home/eko/Projects/nixeko            ⚙ nixeko config
    file:///home/eko/Projects/nixeko/home        ⚙ home modules
    file:///home/eko/Projects/nixeko/modules     ⚙ system modules
    file:///home/eko/Projects/nixeko/docker      ⚙ docker services
    file:///home/eko/Projects/nixeko/wallpapers  ⚙ wallpapers
    file:///home/eko/Projects/nixeko/vpn         ⚙ vpn configs
    file:///home/eko/Documents                   Documents
    file:///home/eko/Downloads                   Downloads
    file:///home/eko/Syncthing-Master            Syncthing
  '';
}
