{ config, pkgs, ... }:

{
  # Kernel hardening
  boot.kernel.sysctl = {
    # Network hardening
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.tcp_syncookies" = 1;

    # Kernel hardening
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    "kernel.yama.ptrace_scope" = 1;

    # Disable magic SysRq
    "kernel.sysrq" = 0;
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22000 ]; # syncthing
    allowedUDPPorts = [ 22000 21027 ]; # syncthing
  };

  # AppArmor
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = false;
  };

  # Sudo hardening
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    execWheelOnly = true;
  };

  # Faillock — slow down brute force, no account lockout
  security.pam.services.login.failDelay = { enable = true; delay = 3000000; };

  # Don't lock account after failed attempts (avoids the issue you had)
  security.pam.services.sudo.failDelay = { enable = true; delay = 3000000; };

  # SSH — disable password auth, key only
  services.openssh = {
    enable = false; # disabled by default, enable when needed
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };

}
