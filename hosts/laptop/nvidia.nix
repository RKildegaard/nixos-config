{ config, pkgs, lib, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;                  
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
    nvidiaSettings = true;

    powerManagement.enable = true;       
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;           
      };
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}

