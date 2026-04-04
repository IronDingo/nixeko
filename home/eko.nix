{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./hyprland.nix
    ./waybar.nix
    ./neovim.nix
    ./walker.nix
    ./scripts.nix
  ];

  home.username = "eko";
  home.homeDirectory = "/home/eko";
  home.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
