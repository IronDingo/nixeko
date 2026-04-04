{ config, pkgs, ... }:

# Dell G15 5530 — Intel iGPU + NVIDIA RTX 4060 (Optimus hybrid)
# PRIME offload: Intel runs the display, NVIDIA handles heavy workloads on demand.
# Run GPU-intensive apps with: nvidia-offload <app>
# Or set PRIME render offload per-app in your bindings.

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true; # fine-grained for laptop battery
    open = true; # RTX 4060 supports open kernel module
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # gives you `nvidia-offload` command
      };
      # !! Run `lspci | grep -E "VGA|3D"` and fill in your actual bus IDs !!
      # Format: PCI:bus:device:function
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
