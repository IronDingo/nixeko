{ pkgs, ... }:

# nixeko theming via Stylix
# Change base16Scheme to switch your entire system theme in one line.
#
# Switch with:  nixeko theme <name>
#
# ── Retro / NES-inspired ────────────────────────────────────────────
#   "nes"                  → NES hardware color palette  ← DEFAULT
#   "gameboy"              → classic green Game Boy
#   "gruvbox-dark-hard"    → warm retro amber/green
#   "vice"                 → Commodore 64 blue
#
# ── Dark modern ─────────────────────────────────────────────────────
#   "catppuccin-mocha"     → purple/blue pastels
#   "tokyo-night-dark"     → tokyo night
#   "nord"                 → arctic blue-grey
#   "rose-pine"            → warm rose/pine
#   "kanagawa"             → japanese ink
#   "everforest-dark-hard" → forest green
#   "oxocarbon-dark"       → deep IBM carbon
#
# Browse all: https://github.com/tinted-theming/schemes

{
  stylix = {
    enable = true;

    # Default wallpaper — your 16-bit retro art.
    # All wallpapers live in wallpapers/ in the nixeko repo.
    # Change with: nixeko wallpaper <filename>
    image = ../../wallpapers/emerald-07.png;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/nes.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sizes = {
        terminal = 13;
        applications = 12;
      };
    };

    # Stylix auto-themes: alacritty, waybar, hyprland, gtk, qt, mako, bat, etc.
    targets = {
      gtk.enable = true;
      qt.enable = true;
    };
  };
}
