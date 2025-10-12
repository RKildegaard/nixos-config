{ config, pkgs, lib, self, ... }:

{
  ## ---- Programs you already use ----
  programs.git = {
    enable = true;
    userName = "RKildegaard";
    userEmail = "rasmuskildegaard20@gmail.com";
  };

  programs.gh = {
	enable = true;
	gitCredentialHelper = {
		enable = true;
	};
  };

  programs.direnv = {
	enable = true;
	nix-direnv = {
		enable = true;
	};
  };

  programs.foot = {
    enable = true;
    server.enable = true;
  };
  xdg.configFile."foot/foot.ini".source = ./files/foot/foot.ini;

  programs.wofi.enable = true;
  programs.vscode.enable = true;

  ## ---- Desktop entry for the Rust Settings app ----
  xdg.desktopEntries."raskil-settings" = {
    name = "System Settings";
    comment = "Configure system & desktop";
    exec = "raskil-settings";
    icon = "preferences-system";
    categories = [ "Settings" "System" ];
    terminal = false;
  };

  ## ---- Packages installed for the user ----
  home.packages = [
    # Your Rust GUI app built by this flake
    self.packages.${pkgs.system}.raskil-settings

    # Your scripts (packaged immutably)
    (pkgs.writeShellApplication {
      name = "powermenu";
      runtimeInputs = [ pkgs.wofi pkgs.systemd pkgs.coreutils ];
      text = builtins.readFile ./files/bin/powermenu;
    })

    # Add more user packages here if you like…
  ];
}

