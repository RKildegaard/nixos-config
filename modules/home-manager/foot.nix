{
  flake.modules.homeManager.foot = {
    programs.foot = {
      enable = true;
      server.enable = true;
    };

    xdg.configFile."foot/foot.ini".source = ../../rsc/foot.ini;
  };
}
