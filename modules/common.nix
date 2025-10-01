{ config, pkgs, lib, ... }:
{
  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Networking
  networking.networkmanager.enable = true;

  # Opengl
  hardware.graphics.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Fonts (incl. Nerd Font for icons)
  fonts.packages = with pkgs; [
    noto-fonts noto-fonts-cjk-sans noto-fonts-emoji dejavu_fonts
    fira-code fira-code-symbols
    nerd-fonts.jetbrains-mono
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" "DejaVu Sans Mono" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  # Electron apps prefer Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Portals (screen share, pickers)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gtk
  ];

  # Polkit
  security.polkit.enable = true;

  # Useful base packages (added displays/tools/settings)
  environment.systemPackages = with pkgs; [
    	git 
	vim 
	wget 
	curl 
	unzip 
	tree
    	pavucontrol 
	udiskie 
	xfce.thunar 
	blueman
    	grim 
	slurp 
	wl-clipboard 
	brightnessctl
    	xdg-desktop-portal-hyprland 
	xdg-desktop-portal-gtk
	gnome-themes-extra
  	papirus-icon-theme
  	bibata-cursors
	gnome-power-manager
	polkit_gnome

    # Displays/Wayland tools
    	wlr-randr

    # General settings GUIs (lightweight)
    	gnome-disk-utility
  ];

  system.stateVersion = "25.05";
}

