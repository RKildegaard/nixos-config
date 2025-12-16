{ pkgs, ... }:
let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --remember --remember-user-session --time --cmd Hyprland";
        # user = "raskil";
      };
    };
  };

  security.pam.services.greetd = { };
}
