{ config, pkgs, ... }:

# Intel + NVIDIA hybrid (Optimus / PRIME offload)
# Intel iGPU drives the display. NVIDIA handles heavy workloads on demand.
# Bus IDs come from nixeko.intelBusId / nixeko.nvidiaBusId in hosts/<profile>/params.nix
# Run GPU-intensive apps with: nvidia-offload <app>

{
  hardware.graphics = {
    enable    = true;
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
    modesetting.enable           = true;
    powerManagement.enable       = true;
    powerManagement.finegrained  = true; # fine-grained for laptop battery
    open                         = true; # RTX 4060 supports open kernel module
    nvidiaSettings               = true;
    package                      = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable          = true;
        enableOffloadCmd = true; # gives you `nvidia-offload` command
      };
      intelBusId  = config.nixeko.intelBusId;
      nvidiaBusId = config.nixeko.nvidiaBusId;
    };
  };
}
