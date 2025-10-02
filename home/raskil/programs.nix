{ config, pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    userName = "RKildegaard";
    userEmail = "rasmuskildegaard20@gmail.com"; 
  };

  programs.foot = {
    	enable = true;
	server.enable = true;
  };
  xdg.configFile."foot/foot.ini".source = ./files/foot/foot.ini;

  programs.wofi = {
    enable = true;
  };

  programs.vscode.enable = true;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "powermenu";
      runtimeInputs = [ pkgs.wofi pkgs.systemd pkgs.coreutils ];
      text = builtins.readFile ./files/bin/powermenu;
    })
    #(pkgs.writeShellApplication {
    #  name = "display-manager";
    #  runtimeInputs = [ pkgs.hyprland pkgs.wlr-randr pkgs.coreutils ]; # adjust
    #  text = builtins.readFile ./files/bin/display-manager;
    #})
  ];
}

