{
  flake.modules.nixos.laptop = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/30f5c9ca-f568-4823-89c8-eec3a0a78b82";
      fsType = "ext4";
    };

    fileSystems."/boot/efi" = {
      device = "/dev/disk/by-uuid/B7DC-2BC6";
      fsType = "vfat";
      neededForBoot = true;
      options = ["umask=0077"];
    };

    swapDevices = [];
  };
}
