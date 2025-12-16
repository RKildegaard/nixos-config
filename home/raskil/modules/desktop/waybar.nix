{ ... }:
{
  programs.waybar.enable = true;

  xdg.configFile."waybar/config".source = ../../files/waybar/config;
  xdg.configFile."waybar/style.css".source = ../../files/waybar/style.css;
  xdg.configFile."waybar/styles/base.css".source = ../../files/waybar/styles/base.css;
  xdg.configFile."waybar/styles/modules.css".source = ../../files/waybar/styles/modules.css;
  xdg.configFile."waybar/styles/workspaces.css".source = ../../files/waybar/styles/workspaces.css;
  xdg.configFile."waybar/styles/network.css".source = ../../files/waybar/styles/network.css;
  xdg.configFile."waybar/styles/extras.css".source = ../../files/waybar/styles/extras.css;
}
