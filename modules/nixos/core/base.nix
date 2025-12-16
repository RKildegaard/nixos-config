{ config, pkgs, lib, ... }:

{
  # Core boot/system defaults
  boot.tmp.cleanOnBoot = true;
  powerManagement.enable = true;

  # CPU/microcode
  hardware.cpu = {
    intel.updateMicrocode = lib.mkDefault true;
    amd.updateMicrocode = lib.mkDefault true;
  };

  # GPU defaults (host modules can extend)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Network + discovery
  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.printing.enable = lib.mkDefault false;
  hardware.sane.enable = lib.mkDefault false;

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      font-awesome
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # Desktop plumbing
  xdg.portal.enable = true;
  security.polkit.enable = true;
  services.fwupd.enable = true;

  # Minimal base packages (apps handled via Home Manager)
  environment.systemPackages = with pkgs; [
    vim
    git
    usbutils
    pciutils
    lm_sensors
    bluez
  ];
}
