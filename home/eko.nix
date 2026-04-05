{ config, pkgs, username, ... }:

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./hyprland.nix
    ./waybar.nix
    ./neovim.nix
    ./walker.nix
    ./scripts.nix
    ./firefox.nix
    ./gtk.nix
    ./mime.nix
  ];

  home.username      = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion  = "24.11";
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
