{ lib, ... }:

# Central parameter definitions for a nixeko system.
# Values are set in hosts/<profile>/params.nix — the installer writes that file.
# All modules reference these options instead of hardcoding strings.

{
  options.nixeko = {

    username = lib.mkOption {
      type        = lib.types.str;
      default     = "eko";
      description = "Primary user account name";
    };

    hostname = lib.mkOption {
      type        = lib.types.str;
      default     = "nixeko";
      description = "System hostname";
    };

    hasNvidia = lib.mkOption {
      type        = lib.types.bool;
      default     = false;
      description = "Enable NVIDIA driver and Intel/NVIDIA PRIME offload";
    };

    intelBusId = lib.mkOption {
      type        = lib.types.str;
      default     = "PCI:0:2:0";
      description = "Intel iGPU PCI bus ID for PRIME offload (lspci output, converted)";
    };

    nvidiaBusId = lib.mkOption {
      type        = lib.types.str;
      default     = "PCI:1:0:0";
      description = "NVIDIA dGPU PCI bus ID for PRIME offload";
    };

    hardwareModule = lib.mkOption {
      type        = lib.types.str;
      default     = "";
      description = "nixos-hardware module name, or empty string for none";
    };

  };
}
