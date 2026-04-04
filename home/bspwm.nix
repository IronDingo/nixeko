{ config, pkgs, ... }:

# ── nixeko-dinghy — BSPWM window manager ─────────────────────────────────────
# A nimble craft. Same waters, lighter hull.
# Stylix themes everything automatically.

{
  # ── BSPWM ─────────────────────────────────────────────────────────────────────

  xsession.windowManager.bspwm = {
    enable = true;

    settings = {
      border_width         = 2;
      window_gap           = 10;
      split_ratio          = 0.52;
      borderless_monocle   = true;
      gapless_monocle      = false;
      focus_follows_pointer = true;
    };

    rules = {
      "firefox"           = { desktop = "^2"; state = "tiled"; };
      "obsidian"          = { desktop = "^3"; };
      "Spotify"           = { desktop = "^9"; state = "tiled"; };
      "1Password"         = { state = "floating"; sticky = true; };
    };

    startupPrograms = [
      "sxhkd"
      "polybar main"
      "picom --daemon"
      "mako"
      "nm-applet"
      "swaybg -i ~/Projects/nixeko/wallpapers/emerald-07.png -m fill"
    ];
  };

  # ── sxhkd — keybindings ───────────────────────────────────────────────────────

  services.sxhkd = {
    enable = true;
    keybindings = {
      # Core
      "super + Return"          = "alacritty";
      "super + alt + space"     = "rofi -show drun";
      "super + shift + b"       = "firefox";
      "super + shift + n"       = "alacritty -e nvim";
      "super + shift + o"       = "obsidian";
      "super + shift + g"       = "signal-desktop";
      "super + shift + m"       = "spotify";
      "super + shift + t"       = "alacritty -e btop";
      "super + shift + d"       = "bash ~/.local/bin/docker-menu";
      "super + shift + ctrl + l" = "alacritty -e lazydocker";
      "super + shift + slash"   = "1password";

      # AI
      "super + shift + a"           = "firefox --new-window https://chat.deepseek.com";
      "super + shift + alt + a"     = "firefox --new-window https://claude.ai";

      # Local services
      "super + shift + s"       = "firefox --new-window http://localhost:8888";
      "super + shift + h"       = "firefox --new-window http://192.168.1.107";
      "super + shift + f"       = "firefox --new-window http://localhost:8096";

      # Menus
      "super + shift + ctrl + v" = "bash ~/.local/bin/vpn-menu";
      "super + shift + ctrl + p" = "bash ~/.local/bin/pihole-menu";
      "super + shift + ctrl + q" = "bash ~/.local/bin/power-menu";

      # Screenshot
      "super + shift + alt + s"  = "grim -g \"$(slurp)\" | satty -f -";

      # Window management
      "super + q"               = "bspc node -c";
      "super + f"               = "bspc node -t fullscreen";
      "super + v"               = "bspc node -t floating";

      # Focus
      "super + {Left,Down,Up,Right}" = "bspc node -f {west,south,north,east}";
      "super + shift + {Left,Down,Up,Right}" = "bspc node -s {west,south,north,east}";

      # Workspaces
      "super + {1-9,0}"         = "bspc desktop -f '^{1-9,10}'";
      "super + shift + {1-9,0}" = "bspc node -d '^{1-9,10}'";
    };
  };

  # ── Picom — compositor ────────────────────────────────────────────────────────

  services.picom = {
    enable = true;
    fade   = true;
    fadeSteps = [ 0.03 0.03 ];
    shadow = false;
    settings = {
      corner-radius = 8;
      blur          = { method = "dual_kawase"; strength = 5; };
      blur-background-exclude = [ "window_type = 'dock'" "window_type = 'desktop'" ];
    };
  };

  # ── Rofi — launcher ───────────────────────────────────────────────────────────
  # Stylix themes this automatically.

  programs.rofi = {
    enable = true;
    font   = "JetBrainsMono Nerd Font 13";
    extraConfig = {
      show-icons    = true;
      icon-theme    = "Papirus-Dark";
      display-drun  = "▸ ";
    };
  };

  # ── Polybar — status bar ──────────────────────────────────────────────────────
  # Stylix themes colors. Structure defined here.

  services.polybar = {
    enable = true;
    script = "polybar main &";

    config = {
      "bar/main" = {
        width        = "100%";
        height       = "28pt";
        radius       = 0;
        font-0       = "JetBrainsMono Nerd Font:size=10;2";
        font-1       = "JetBrainsMono Nerd Font:size=14;3";
        modules-left  = "bspwm";
        modules-center = "date";
        modules-right  = "battery cpu memory network pulseaudio";
        separator     = "  ";
        padding       = 2;
        module-margin = 1;
        tray-position = "right";
        tray-padding  = 4;
        cursor-click  = "pointer";
      };

      "module/bspwm" = {
        type             = "internal/bspwm";
        label-focused    = "◉ %name%";
        label-occupied   = "○ %name%";
        label-empty      = "";
        label-urgent     = "◈ %name%";
        label-focused-padding  = 1;
        label-occupied-padding = 1;
      };

      "module/date" = {
        type     = "internal/date";
        interval = 1;
        date     = "%a %d %b";
        time     = "%H:%M";
        label    = "%date%  %time%";
      };

      "module/battery" = {
        type              = "internal/battery";
        full-at           = 99;
        label-charging    = "⚡ %percentage%%";
        label-discharging = "🔋 %percentage%%";
        label-full        = "🔋 Full";
        label-low         = "⚠ %percentage%%";
        low-at            = 20;
      };

      "module/cpu" = {
        type     = "internal/cpu";
        interval = 2;
        label    = "CPU %percentage%%";
      };

      "module/memory" = {
        type     = "internal/memory";
        interval = 2;
        label    = "RAM %percentage_used%%";
      };

      "module/network" = {
        type                 = "internal/network";
        interface-type       = "wireless";
        label-connected      = "󰖩 %essid%";
        label-disconnected   = "󰖪";
      };

      "module/pulseaudio" = {
        type         = "internal/pulseaudio";
        label-volume = "󰕾 %percentage%%";
        label-muted  = "󰝟";
      };
    };
  };
}
