{ pkgs, ... }:

# OpenVPN — package installed, services configured post-install.
#
# Setup after install: see vpn/README.md
#   1. Drop .ovpn files into vpn/configs/
#   2. Create vpn/credentials (see vpn/credentials.example)
#   3. nixeko rebuild

{
  environment.systemPackages = [ pkgs.openvpn ];
}
