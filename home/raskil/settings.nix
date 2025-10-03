{ config, pkgs, lib, ... }:

let
  settings = builtins.fromJSON (builtins.readFile ../../settings/settings.json);
  toMonitorLine = m: "${m.name},preferred,auto,${toString m.scale}";
in
{
  # Cursor from JSON
  home.pointerCursor = {
    name = settings.appearance.cursor.name;
    package = pkgs.bibata-cursors;
    size = settings.appearance.cursor.size;
    gtk.enable = true;
  };

  # Foot styling (only a teaser – you already have a full foot.ini, keep whichever you prefer)
  xdg.configFile."foot/foot.ini".text = ''
    [main]
    font=${settings.appearance.font.monospace}:size=${toString settings.appearance.font.terminalSize}
    pad=10x8
    dpi-aware=yes
  '';

  # Hyprland bits from JSON
  wayland.windowManager.hyprland.settings = {
    input.kb_layout = settings.keyboard.layout;
    monitor = map toMonitorLine settings.display.monitors;
    env = [
      "XCURSOR_SIZE,${toString settings.appearance.cursor.size}"
      "HYPRCURSOR_SIZE,${toString settings.appearance.cursor.size}"
    ];
  };
}

