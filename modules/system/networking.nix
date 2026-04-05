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
  # DNS via systemd-resolved — Cloudflare + Quad9 with DoT.
  # To add Pi-hole after install: set DNS=127.0.0.1 in extraConfig
  # and run: sudo docker compose -f ~/Projects/nixeko/docker/pihole/... up -d
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
    extraConfig = ''
      DNS=1.1.1.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net
      DNSOverTLS=opportunistic
    '';
  };
}
