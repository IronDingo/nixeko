{ pkgs, ... }:

# Packages managed by home-manager.
# Note: alacritty, neovim, waybar, git, starship, fzf, zoxide are
# managed via programs.* in their own modules — not listed here.

{
  home.packages = with pkgs; [

    # Terminal utilities
    bat
    btop
    eza
    fastfetch
    fd
    jq
    ripgrep
    tldr
    tree

    # Editors
    sublime4

    # Development
    gcc
    github-cli
    go
    mise
    nodejs
    python3
    ruff
    rustup
    pyright
    gopls
    rust-analyzer
    lua-language-server
    nodePackages.typescript-language-server

    # Containers
    lazydocker
    docker-compose

    # Networking
    openvpn
    tcpdump
    wget
    whois
    openbsd-netcat
    rsync

    # Media
    ffmpeg
    handbrake
    imagemagick
    imv
    mpv
    obs-studio
    yt-dlp

    # Wayland / Hyprland ecosystem
    grim
    hypridle
    hyprlock
    hyprpicker
    mako
    slurp
    swayosd
    swaybg
    wl-clipboard
    wl-clip-persist

    # GUI apps
    evince
    gnome-calculator
    localsend
    meld
    nautilus
    obsidian
    pinta
    signal-desktop
    spotify
    xournalpp

    # Gaming
    protonup-qt

    # Productivity
    typora

    # Fonts
    noto-fonts
    noto-fonts-emoji

    # System tools
    brightnessctl
    exfatprogs
    inxi
    ntfs3g
    pamixer
    usbutils
    unzip

    # Arduino / embedded
    arduino-cli
    esptool

    # Launcher
    walker

    # AI / editors
    # cursor  # uncomment if available in nixpkgs

    # Remote desktop
    rustdesk

    # Audio
    pwvucontrol

    # Media controls
    playerctl

    # Screenshot
    satty

    # Screen recording (verify on first build — may need overlay)
    gpu-screen-recorder
    # gpu-screen-recorder-gtk  # separate GTK frontend, unconfirmed in nixpkgs

    # WiFi TUI (unconfirmed nixpkgs name — comment out if build fails)
    # impala

    # Wayland extras (confirmed in nixpkgs unstable)
    wayfreeze
    wiremix
  ];
}
