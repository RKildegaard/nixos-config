{
  flake.modules.nixos.desktopHost = {lib, ...}: {
    boot.initrd.availableKernelModules = [
      "ata_piix"
      "mptspi"
      "uhci_hcd"
      "ehci_pci"
      "ahci"
      "sd_mod"
      "sr_mod"
    ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/1dfef781-7e50-45eb-a9f2-76083d97ff36";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/1363-A095";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/e5e8c3cc-b380-4887-8c5d-6544bd89a654"; }
    ];
    networking.useDHCP = lib.mkDefault true;
  };
}
