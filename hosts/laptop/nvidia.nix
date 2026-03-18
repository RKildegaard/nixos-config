{ config, lib, ... }:
let
  nvidiaIds = [ "10de:25ba" ];
  vfioIds = lib.concatStringsSep "," nvidiaIds;
in
{
  boot = {
    kernelModules = [ "kvm-intel" "kvmfr" "vfio" "vfio_pci" "vfio_iommu_type1" ];
    initrd.kernelModules = [ "vfio" "vfio_pci" "vfio_iommu_type1" ];
    extraModulePackages = [ config.boot.kernelPackages.kvmfr ];

    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
      # Keep this in sync with the Looking Glass ivshmem object size in the VM XML.
      "kvmfr.static_size_mb=64"
      "vfio-pci.ids=${vfioIds}"
    ];

    blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
    ];

    extraModprobeConfig = ''
      options vfio-pci ids=${vfioIds}

      softdep nouveau pre: vfio-pci
      softdep nvidia pre: vfio-pci
      softdep nvidia_drm pre: vfio-pci
      softdep nvidia_modeset pre: vfio-pci
      softdep nvidia_uvm pre: vfio-pci
    '';
  };

  # Keep host rendering on the Intel iGPU; dedicate NVIDIA to the VM.
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  virtualisation.libvirtd.qemu.swtpm.enable = true;
}
