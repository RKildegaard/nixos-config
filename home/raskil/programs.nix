{ config, pkgs, lib, ... }:
{
  # GUI apps that have HM modules or simple program toggles
  programs.git = {
    enable = true;
    userName = "raskil";
    userEmail = "you@example.com"; # change me
  };

  programs.foot = {
    enable = true;
    # settings = { ... }  # keep in repo later if you want
  };

  programs.wofi = {
    enable = true;
    # If you later want to manage a full config:
    # settings = { ... };
    # Or link files under xdg.configFile as done for CSS in default.nix
  };

  # VS Code (if you prefer here vs packages list)
  # programs.vscode.enable = true;

  # Install custom scripts in PATH from files/bin using writeShellApplication
  # Keeps scripts immutable, versioned, and ensures shebang/env
  home.packages = [
    (pkgs.writeShellApplication {
      name = "powermenu";
      runtimeInputs = [ pkgs.wofi pkgs.systemd pkgs.coreutils ]; # adjust if needed
      text = builtins.readFile ./files/bin/powermenu;
    })
    (pkgs.writeShellApplication {
      name = "display-manager";
      runtimeInputs = [ pkgs.hyprland pkgs.wlr-randr pkgs.coreutils ]; # adjust
      text = builtins.readFile ./files/bin/display-manager;
    })
  ];
}

