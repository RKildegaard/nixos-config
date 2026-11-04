{
  flake.modules.nixos.virtualization = {
    virtualisation = {
      libvirtd.enable = true;
      docker = {
        enable = true;
        enableOnBoot = true;
      };
    };

    boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
  };
}
