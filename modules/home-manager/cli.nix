{
  flake.modules.homeManager.cli = {pkgs, ...}: {
    home.packages = with pkgs; [
      python3
      platformio-core
      openocd
      avrdude
    ];

    programs.git = {
      enable = true;
      settings.user = {
        name = "RKildegaard";
        email = "rasmuskildegaard20@gmail.com";
      };
    };

    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
