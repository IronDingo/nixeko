{ config, pkgs, ... }:

{
  # Cronie (cron jobs)
  services.cron.enable = true;

  # Locate (plocate)
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    localuser = null;
  };

  # CUPS printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # noip dynamic DNS — run as a service
  # systemd.services.noip = {
  #   description = "No-IP Dynamic DNS Updater";
  #   after = [ "network.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.noip}/bin/noip2 -c /etc/noip2.conf";
  #     Restart = "always";
  #   };
  # };
}
