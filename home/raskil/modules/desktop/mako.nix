{ ... }:
{
  services.mako.enable = true;
  xdg.configFile."mako/config".source = ../../files/mako/config;
}
