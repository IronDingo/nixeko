{ pkgs, ... }:

# GTK — icons and cursor. Stylix handles all colors.
# Cursor alternatives if bibata-cursors causes issues:
#   pkgs.vanilla-dmz       (minimal, always works)
#   pkgs.adwaita-icon-theme (GNOME default)
#   pkgs.phinger-cursors   (retro pixel style — very on-brand)

{
  gtk = {
    enable = true;
    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name    = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size    = 24;
    };
  };

  home.pointerCursor = {
    name       = "Bibata-Modern-Classic";
    package    = pkgs.bibata-cursors;
    size       = 24;
    gtk.enable = true;
  };
}
