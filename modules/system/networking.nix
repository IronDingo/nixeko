{ config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
  };

  hardware.wirelessRegulatoryDatabase = true;

  # DNS via systemd-resolved
  # Pi-hole (127.0.0.1) is primary when running — falls back to Cloudflare/Quad9
  # Pi-hole lives on docker/pihole — start with: nixeko pihole start
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade"; # Pi-hole handles DNSSEC internally
    domains = [ "~." ];
    extraConfig = ''
      DNS=127.0.0.1
      FallbackDNS=1.1.1.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net
      DNSOverTLS=opportunistic
    '';
  };
}
