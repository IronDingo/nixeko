{ pkgs, ... }:

{
  # ── GTK theme ─────────────────────────────────────────────────────────────────
  # Stylix handles colors. This handles icons and cursor.

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

  # Also set for Wayland / Hyprland
  home.pointerCursor = {
    name    = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size    = 24;
    gtk.enable = true;
  };
}
