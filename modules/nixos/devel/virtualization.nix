{ pkgs, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    qemu.verbatimConfig = ''
      namespaces = []
      cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
        "/dev/kvmfr0"
      ]
    '';
  };

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
  ];
}
