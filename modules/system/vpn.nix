{ config, pkgs, lib, ... }:

# OpenVPN — works with ProtonVPN, Mullvad, or any provider.
#
# Setup: see vpn/README.md
#   1. Drop .ovpn files into vpn/configs/
#   2. Create vpn/credentials (see vpn/credentials.example)
#   3. nixeko rebuild
#
# Each .ovpn becomes a systemd service: openvpn-<filename>
# Control via Super+Shift+Ctrl+V (vpn-menu) or systemctl start/stop openvpn-<name>

let
  configDir = ../../vpn/configs;
  credFile  = ../../vpn/credentials;

  hasCredentials = builtins.pathExists credFile;

  # Derive a clean systemd-safe service name from filename
  # e.g. ch-951.protonvpn.tcp.ovpn → ch-951-protonvpn-tcp
  nameFromFile = file:
    builtins.replaceStrings ["."] ["-"]
      (lib.removeSuffix ".ovpn" file);

  # Append NixOS-managed DNS + credentials to every config
  fixConfig = content: content + ''

    # DNS leak prevention
    dhcp-option DNS 10.2.0.1
    dhcp-option DNS 1.1.1.1

    # Credentials
    auth-user-pass /etc/openvpn/vpn-credentials
  '';

  ovpnFiles = builtins.attrNames (
    lib.filterAttrs (n: t: lib.hasSuffix ".ovpn" n && t == "regular")
      (builtins.readDir configDir)
  );

  makeServer = file: {
    name = nameFromFile file;
    value = {
      config    = fixConfig (builtins.readFile (configDir + "/${file}"));
      updateResolvConf = true;
      autoStart = false;
    };
  };

in
{
  # Deploy credentials to /etc — root-readable only — only if the file exists
  environment.etc = lib.optionalAttrs hasCredentials {
    "openvpn/vpn-credentials" = {
      source = credFile;
      mode   = "0400";
    };
  };

  # Auto-register every .ovpn file as a systemd openvpn service
  services.openvpn.servers = builtins.listToAttrs (map makeServer ovpnFiles);

  # Allow the main user to control VPN services without a password
  security.sudo.extraRules = [
    {
      users = [ "eko" ];
      commands = [
        { command = "/run/current-system/sw/bin/systemctl start openvpn-*";   options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl stop openvpn-*";    options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl restart openvpn-*"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl status openvpn-*";  options = [ "NOPASSWD" ]; }
      ];
    }
  ];
}
