{
  flake.modules.nixos.virtualization = {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
      };
    };

    boot.kernel.sysctl."fs.inotify.max_user_watches" = 1048576;
  };
}
