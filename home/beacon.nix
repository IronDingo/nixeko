{ config, pkgs, ... }:

# nixeko-beacon — headless profile
# Hull and engines only. No bridge, no crew quarters.
# Runs dark. SSH in, get to work.

{
  imports = [
    ./shell.nix
    ./neovim.nix
  ];

  home.username      = "eko";
  home.homeDirectory = "/home/eko";
  home.stateVersion  = "24.11";
  programs.home-manager.enable = true;
}
