{ config, pkgs, ... }:

# nixeko-dinghy — BSPWM profile
# A nimble craft. Same waters, lighter hull.

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./bspwm.nix
    ./neovim.nix
    ./scripts.nix
    ./gtk.nix
    ./mime.nix
  ];

  home.username      = "eko";
  home.homeDirectory = "/home/eko";
  home.stateVersion  = "24.11";
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
