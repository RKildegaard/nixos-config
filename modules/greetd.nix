{ config, pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  users.users.greeter = {
    isSystemUser = true;
    description = "Greeter";
    home = "/var/lib/greetd";
    shell = pkgs.bashInteractive;
  };
}

