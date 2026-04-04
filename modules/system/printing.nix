{ ... }:

{
  # ── Printing ──────────────────────────────────────────────────────────────────
  # CUPS — auto-discovers network printers via Avahi

  services.printing = {
    enable = true;
    drivers = [];  # add printer-specific drivers here if needed
                   # e.g. [ pkgs.hplip ] for HP printers
  };
}
