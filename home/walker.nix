{ config, pkgs, ... }:

# Walker — application launcher
# Config: ~/.config/walker/
# Styled to match the NES retro aesthetic.

{
  # Walker config
  home.file.".config/walker/config.toml".text = ''
    [search]
    delay       = 0
    placeholder = "➤  search"
    max_entries = 12

    [[builtins]]
    name   = "applications"
    prefix = ""

    [[builtins]]
    name   = "runner"
    prefix = "!"

    [[builtins]]
    name   = "websearch"
    prefix = "?"
    # Uses SearXNG if running, else falls back to DuckDuckGo
    src    = "http://localhost:8888/search?q=%s"

    [[builtins]]
    name   = "clipboard"
    prefix = "c:"

    [[builtins]]
    name   = "ssh"
    prefix = "ssh:"

    [[builtins]]
    name   = "hyprland_windows"
    prefix = "w:"
  '';

  # Walker CSS — 16-bit pixel aesthetic
  # Stylix may also inject base16 colors; this adds layout & retro feel
  home.file.".config/walker/style.css".text = ''
    @define-color bg       #0f0f0f;
    @define-color bg2      #1a1a1a;
    @define-color border   #3a3a3a;
    @define-color fg       #c8c8c8;
    @define-color accent   #a8c800;
    @define-color muted    #5a5a5a;
    @define-color selected #1e2e00;

    * {
      font-family: "JetBrainsMono Nerd Font Mono", monospace;
      font-size: 14px;
    }

    #window {
      background-color: @bg;
      border: 2px solid @border;
      border-radius: 0;
    }

    #search {
      background-color: @bg2;
      color: @fg;
      border: none;
      border-bottom: 2px solid @border;
      border-radius: 0;
      padding: 12px 16px;
      caret-color: @accent;
    }

    #search:focus {
      border-bottom-color: @accent;
    }

    #list {
      background-color: @bg;
      padding: 4px 0;
    }

    row {
      padding: 6px 16px;
      border-radius: 0;
      color: @fg;
    }

    row:hover,
    row:selected {
      background-color: @selected;
      color: @accent;
    }

    .sub {
      color: @muted;
      font-size: 11px;
    }
  '';
}
