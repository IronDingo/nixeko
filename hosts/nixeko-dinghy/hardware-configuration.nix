# This file will be auto-generated when you run:
#   nixos-generate-config --root /mnt
# during installation. Replace this file with that output.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules          = [ ];
  boot.kernelModules                 = [ "kvm-intel" ];
  boot.extraModulePackages           = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-BOOT-UUID";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform                       = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode         = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
