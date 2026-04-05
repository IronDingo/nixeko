{ username, ... }:

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

  home.file.".local/bin/docker-menu" = {
    source     = ./scripts/docker-menu.sh;
    executable = true;
  };

  # Nautilus sidebar bookmarks — quick access to key locations
  home.file.".config/gtk-3.0/bookmarks".text = ''
    file:///home/${username}/Projects/nixeko            ⚙ nixeko config
    file:///home/${username}/Projects/nixeko/home        ⚙ home modules
    file:///home/${username}/Projects/nixeko/modules     ⚙ system modules
    file:///home/${username}/Projects/nixeko/docker      ⚙ docker services
    file:///home/${username}/Projects/nixeko/wallpapers  ⚙ wallpapers
    file:///home/${username}/Projects/nixeko/vpn         ⚙ vpn configs
    file:///home/${username}/Documents                   Documents
    file:///home/${username}/Downloads                   Downloads
    file:///home/${username}/Syncthing-Master            Syncthing
  '';
}
