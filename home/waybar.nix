{ config, pkgs, ... }:

# Waybar — top bar for Hyprland
# Colors are injected automatically by Stylix.
# Layout: [workspaces | window title]  [clock]  [vol | net | cpu | mem | bat | tray]

{
  programs.waybar = {
    enable = true;

    settings = [{
      layer    = "top";
      position = "top";
      height   = 30;
      spacing  = 0;

      modules-left   = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right  = [
        "pulseaudio" "network" "cpu" "memory" "battery" "tray"
      ];

      "hyprland/workspaces" = {
        disable-scroll  = true;
        all-outputs     = true;
        format          = "{icon}";
        format-icons    = {
          "1"  = "①"; "2"  = "②"; "3"  = "③"; "4"  = "④"; "5"  = "⑤";
          "6"  = "⑥"; "7"  = "⑦"; "8"  = "⑧"; "9"  = "⑨"; "10" = "⑩";
          active  = "◉";
          urgent  = "◈";
          default = "○";
        };
        persistent-workspaces = {
          "*" = 5;
        };
      };

      "hyprland/window" = {
        format     = "  {}";
        max-length = 48;
        separate-outputs = true;
      };

      clock = {
        format         = "  {:%H:%M}";
        format-alt     = "  {:%a %d %b  %H:%M}";
        tooltip-format = "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        interval = 5;
        format   = "CPU {usage}%";
        tooltip  = false;
      };

      memory = {
        interval = 10;
        format   = "MEM {percentage}%";
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
      };

      battery = {
        interval = 30;
        states   = { good = 90; warning = 30; critical = 15; };
        format   = "{icon} {capacity}%";
        format-charging  = "↑ {capacity}%";
        format-plugged   = "· {capacity}%";
        format-icons     = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
      };

      network = {
        format-wifi       = "  {essid}";
        format-ethernet   = "  eth";
        format-disconnected = "  off";
        tooltip-format    = "{ifname} {ipaddr}  {signalStrength}%";
        on-click          = "alacritty -e nmtui";
      };

      pulseaudio = {
        format        = "{icon} {volume}%";
        format-muted  = "✕ muted";
        format-icons  = { default = [ "▮" "▮▮" "▮▮▮" ]; };
        on-click      = "pwvucontrol";
        on-scroll-up  = "pamixer -i 2";
        on-scroll-down = "pamixer -d 2";
      };

      tray = {
        icon-size = 16;
        spacing   = 8;
      };
    }];

    # Style — layout only; Stylix injects all @base** color variables
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font Mono", monospace;
        font-size: 12px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: @base00;
        border-bottom: 2px solid @base02;
        color: @base05;
      }

      /* Workspaces */
      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        padding: 0 7px;
        color: @base03;
        background: transparent;
        transition: all 0.1s;
      }

      #workspaces button:hover {
        color: @base05;
        background: @base01;
      }

      #workspaces button.active {
        color: @base0A;
        font-weight: bold;
      }

      #workspaces button.urgent {
        color: @base08;
        font-weight: bold;
      }

      /* Window title */
      #window {
        color: @base04;
        padding: 0 8px;
        font-style: italic;
      }

      /* Right modules */
      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        color: @base05;
      }

      /* Separator between right modules */
      #cpu, #memory, #network, #pulseaudio {
        border-left: 1px solid @base02;
      }

      /* Clock — highlighted */
      #clock {
        color: @base0B;
        font-weight: bold;
      }

      /* Battery states */
      #battery.charging { color: @base0B; }
      #battery.warning  { color: @base09; }
      #battery.critical { color: @base08; font-weight: bold; }
    '';
  };
}
