{ config, pkgs, lib, ... }:

{
  # --- Base OS switches -------------------------------------------------------
  boot.tmp.cleanOnBoot = true;

  # Microcode (safe defaults)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode   = lib.mkDefault true;

  # OpenGL / video accel (generic; nvidia users can extend in host config)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  

  # --- Networking -------------------------------------------------------------
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # --- Audio (PipeWire) -------------------------------------------------------
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # --- Printing & Scanning (optional, comment out if not needed) -------------
  services.printing.enable = lib.mkDefault false;
  hardware.sane.enable = lib.mkDefault false;

  # --- Power management -------------------------------------------------------
  powerManagement.enable = true;

  # --- Fonts ------------------------------------------------------------------
  fonts = {
  packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    font-awesome

    # Nerd Fonts (new style)
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  enableDefaultPackages = true;

  fontconfig.defaultFonts = {
    serif      = [ "Noto Serif" ];
    sansSerif  = [ "Noto Sans" ];
    monospace  = [ "JetBrainsMono Nerd Font" "Noto Sans Mono" ];
    emoji      = [ "Noto Color Emoji" ];
  };
};


  # --- XDG portals (default chooser set in wayland-hyprland.nix) -------------
  xdg.portal.enable = true;

  # --- Polkit (system) --------------------------------------------------------
  security.polkit.enable = true;

  # --- Misc services you likely want on both hosts ----------------------------
  services.fwupd.enable = true;

  # Keep system packages lean; user apps go in Home Manager
  environment.systemPackages = with pkgs; [
    vim
    git
    usbutils
    pciutils
    lm_sensors
  ];
}

