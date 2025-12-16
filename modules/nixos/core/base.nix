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

  # Audio via PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire-pulse."context.modules" = [
      {
        name = "libpipewire-module-filter-chain";
        args = {
          node.description = "Speaker Lift EQ";
          media.class = "Audio/Sink";
          filter.graph = {
            nodes = [
              {
                type = "ladspa";
                name = "eq";
                plugin = "${pkgs.ladspaPlugins.swh}/lib/ladspa/mbeq_1197.so";
                label = "mbeq";
                control = {
                  "31 Hz" = 4.0;
                  "63 Hz" = 3.5;
                  "125 Hz" = 2.5;
                  "250 Hz" = 1.0;
                  "500 Hz" = -1.5;
                  "1 kHz" = -2.0;
                  "2 kHz" = -0.5;
                  "4 kHz" = 1.0;
                  "8 kHz" = 2.5;
                  "16 kHz" = 3.0;
                };
              }
            ];
            links = [
              { output = "input:out"; input = "eq:In"; }
              { output = "eq:Out"; input = "output:in"; }
            ];
          };
          capture.props = {
            node.name = "ladspa_input.eq";
          };
          playback.props = {
            node.name = "ladspa_output.eq";
            "node.nick" = "Speaker Lift EQ";
            "audio.position" = [ "FL" "FR" ];
          };
        };
      }
    ];
    extraConfig.pipewire-pulse."stream.rules" = [
      {
        matches = [ { } ];
        actions.update-props."node.target" = "ladspa_output.eq";
      }
    ];
  };

  # Optional peripherals
  services.printing.enable = lib.mkDefault false;
  hardware.sane.enable = lib.mkDefault false;

  # Fonts
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
