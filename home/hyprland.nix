{ config, pkgs, ... }:

{
  # ── Hyprland ──────────────────────────────────────────────────────────────────

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "mako"
        "hypridle"
        "tailscale up"
        "gnome-keyring-daemon --start --components=secrets"
        "swaybg -i ~/Projects/nixeko/wallpapers/emerald-07.png -m fill"
      ];

      input = {
        kb_options        = "compose:caps";
        repeat_rate       = 40;
        repeat_delay      = 600;
        numlock_by_default = true;
        touchpad.scroll_factor = 0.4;
      };

      general = {
        gaps_in     = 5;
        gaps_out    = 10;
        border_size = 2;
        layout      = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size    = 6;
          passes  = 2;
        };
      };

      animations.enabled = true;

      dwindle = {
        pseudotile     = true;
        preserve_split = true;
      };

      "$mod"      = "SUPER";
      "$terminal" = "alacritty";
      "$browser"  = "firefox";

      bind = [
        # Core
        "$mod, RETURN,        exec, $terminal"
        "$mod ALT, SPACE,     exec, walker"
        "$mod SHIFT, B,       exec, firefox --new-window"
        "$mod SHIFT, N,       exec, alacritty -e nvim"
        "$mod SHIFT, O,       exec, obsidian"
        "$mod SHIFT, G,       exec, signal-desktop"
        "$mod SHIFT, slash,   exec, 1password"
        "$mod SHIFT, M,       exec, spotify"
        "$mod SHIFT, T,       exec, $terminal -e btop"
        "$mod SHIFT, D,       exec, bash ~/.local/bin/docker-menu"
        "$mod SHIFT CTRL, L,  exec, $terminal -e lazydocker"

        # AI
        "$mod SHIFT, A,         exec, firefox --new-window https://chat.deepseek.com"
        "$mod SHIFT ALT, A,     exec, firefox --new-window https://claude.ai"
        "$mod SHIFT CTRL, A,    exec, alacritty -e docker exec -it ollama ollama run deepseek-r1:14b"

        # Proton
        "$mod SHIFT, E,       exec, firefox --new-window https://mail.proton.me"
        "$mod SHIFT, C,       exec, firefox --new-window https://calendar.proton.me"

        # Media / streaming
        "$mod SHIFT, Y,         exec, firefox --new-window https://youtube.com"
        "$mod SHIFT CTRL, D,    exec, firefox --new-window https://nebula.tv"
        "$mod SHIFT CTRL, F,    exec, firefox --new-window https://primevideo.com"
        "$mod SHIFT, F,         exec, firefox --new-window http://localhost:8096"

        # Local services
        "$mod SHIFT, S,         exec, firefox --new-window http://localhost:8888"
        "$mod SHIFT, H,         exec, firefox --new-window http://192.168.1.107"

        # Screenshot
        "$mod SHIFT ALT, S,     exec, grim -g \"$(slurp)\" | satty -f -"

        # Menus
        "$mod SHIFT CTRL, V,    exec, bash ~/.local/bin/vpn-menu"
        "$mod SHIFT CTRL, P,    exec, bash ~/.local/bin/pihole-menu"
        "$mod SHIFT CTRL, Q,    exec, bash ~/.local/bin/power-menu"

        # Window management
        "$mod, Q,   killactive,"
        "$mod, F,   fullscreen,"
        "$mod, V,   togglefloating,"
        "$mod, P,   pseudo,"
        "$mod, J,   togglesplit,"

        # Focus
        "$mod, left,  movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up,    movefocus, u"
        "$mod, down,  movefocus, d"

        # Workspaces
        "$mod, 1, workspace, 1"   "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod, 2, workspace, 2"   "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod, 3, workspace, 3"   "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod, 4, workspace, 4"   "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod, 5, workspace, 5"   "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod, 6, workspace, 6"   "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod, 7, workspace, 7"   "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod, 8, workspace, 8"   "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod, 9, workspace, 9"   "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod, 0, workspace, 10"  "$mod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # ── Hypridle ──────────────────────────────────────────────────────────────────
  # Dims and locks screen on inactivity

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd         = "hyprlock";
        before_sleep_cmd = "hyprlock";
        after_sleep_cmd  = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout    = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout    = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume  = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  # ── Hyprlock ──────────────────────────────────────────────────────────────────
  # Lock screen — Stylix themes the colors

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor         = true;
      };
      background = [
        {
          path         = "~/Projects/nixeko/wallpapers/emerald-07.png";
          blur_passes  = 2;
          blur_size    = 6;
          brightness   = 0.6;
        }
      ];
      input-field = [
        {
          size             = "280, 48";
          position         = "0, -120";
          monitor          = "";
          dots_center      = true;
          fade_on_empty    = false;
          placeholder_text = "<i>passphrase</i>";
          hide_input       = false;
          rounding         = 0;
        }
      ];
      label = [
        {
          monitor  = "";
          text     = "$TIME";
          font_size = 64;
          position = "0, 80";
          valign   = "center";
          halign   = "center";
        }
      ];
    };
  };
}
