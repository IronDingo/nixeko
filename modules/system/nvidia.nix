{ config, pkgs, ... }:

# Intel + NVIDIA hybrid (Optimus / PRIME offload)
# Intel iGPU drives the display. NVIDIA handles heavy workloads on demand.
# Bus IDs are patched automatically by the install wizard (lspci detection).
# Run GPU-intensive apps with: nvidia-offload <app>

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
