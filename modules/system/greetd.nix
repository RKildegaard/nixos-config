{ pkgs, lib, ... }:

let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
in
{
  services.greetd = {
    enable = true;
    vt = 1;
    settings = {
      default_session = {
        command = "${tuigreet} --remember --remember-user-session --time --cmd Hyprland";
        # user = "raskil";
      };
    };
  };

  security.pam.services.greetd = { };
}

