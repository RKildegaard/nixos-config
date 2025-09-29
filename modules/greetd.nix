{ config, pkgs, lib, ... }:
{
  # seat daemon needed for Wayland on the TTY
  services.seatd.enable = true;

  # Greeter user with access to GPU/input devices
  users.users.greeter = {
    isSystemUser = true;
    description = "Greeter user for greetd";
    home = "/var/lib/greetd";
    shell = pkgs.bashInteractive;
    extraGroups = [ "video" "render" "input" ];
  };

  # Packages used by the greeter
  environment.systemPackages = with pkgs; [
    greetd.regreet
    cage
    gnome-themes-extra
    papirus-icon-theme
    bibata-cursors
  ];

  # Fonts (new nerdfonts namespace)
  fonts.packages = with pkgs; [
    inter
    nerd-fonts.jetbrains-mono
  ];

  # Regreet UI config (kept minimal and clean)
  environment.etc."greetd/regreet.toml".text = ''
    [appearance]
    font = "Inter 12"

    [clock]
    enabled = true
    format = "%a %d %b   %H:%M"

    # To use a wallpaper later, add a file at /etc/greetd/background.jpg and uncomment:
    # [background]
    # path = "/etc/greetd/background.jpg"
    # fit = "Cover"
  '';

  # GTK theming for greeter (GTK looks in $XDG_CONFIG_HOME/gtk-3.0)
  environment.etc."greetd/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=Adwaita-dark
    gtk-icon-theme-name=Papirus-Dark
    gtk-cursor-theme-name=Bibata-Modern-Classic
    gtk-cursor-theme-size=20
    gtk-enable-animations=true
    gtk-font-name=Inter 11
  '';
  environment.etc."greetd/gtk-3.0/gtk.css".text = ''
    window, entry, button { border-radius: 0px; }
  '';

  # Writable runtime/cache/log dirs for greeter
  systemd.tmpfiles.rules = [
    "d /run/greetd 0700 greeter greeter - -"
    "d /var/lib/greetd 0755 greeter greeter - -"
    "d /var/lib/greetd/.cache 0700 greeter greeter - -"
    "d /var/log/regreet 0755 greeter greeter - -"
  ];

  # Run regreet *inside cage* (Wayland compositor) with VM-friendly wlroots flags
  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      command = ''
        env \
          XDG_RUNTIME_DIR=/run/greetd \
          XDG_CONFIG_HOME=/etc/greetd \
          XDG_CACHE_HOME=/var/lib/greetd/.cache \
          GTK_THEME=Adwaita:dark \
          XCURSOR_THEME=Bibata-Modern-Classic \
          XCURSOR_SIZE=20 \
          HYPRCURSOR_THEME=Bibata-Modern-Classic \
          HYPRCURSOR_SIZE=20 \
          REGREET_LOG=/var/log/regreet/regreet.log \
          WLR_BACKENDS=drm \
          WLR_RENDERER=pixman \
          WLR_DRM_NO_MODIFIERS=1 \
          WLR_RENDERER_ALLOW_SOFTWARE=1 \
          WLR_NO_HARDWARE_CURSORS=1 \
        ${pkgs.dbus}/bin/dbus-run-session \
        ${pkgs.cage}/bin/cage -s -- \
          ${pkgs.greetd.regreet}/bin/regreet --config /etc/greetd/regreet.toml
      '';
    };
  };

  programs.dconf.enable = true;
}

