{
  flake.modules.homeManager.vscode = {
    lib,
    pkgs,
    ...
  }: let
    platformioPython = pkgs.python3.withPackages (ps: [
      (ps.toPythonModule pkgs.platformio-core)
    ]);
  in {
    programs.vscode = {
      enable = true;
      # cpptools chmods its own binaries on activation, so it must stay mutable.
      mutableExtensionsDir = true;
      package = pkgs.vscode;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          platformio.platformio-vscode-ide
          esbenp.prettier-vscode
	];
        userSettings = {
          "editor.formatOnSave" = true;
          "files.watcherExclude" = {
            "**/.bloop" = true;
            "**/.metals" = true;
          };
 	  "workbench.colorTheme" = "Default Dark Modern";
	  "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "git.confirmSync" = false;
          "github.copilot.enable" = {
            "*" = true;
            plaintext = false;
            markdown = false;
            scminput = false;
            python = false;
          };
          "github.copilot.nextEditSuggestions.enabled" = true;
          "gitlens.ai.model" = "vscode";
          "gitlens.ai.vscode.model" = "copilot:gpt-4.1";
          "platformio-ide.customPATH" = lib.makeBinPath [
            platformioPython
            pkgs.platformio-core
            pkgs.openocd
            pkgs.avrdude
          ];
          "platformio-ide.useBuiltinPython" = false;
          "redhat.telemetry.enabled" = true;
          "terminal.integrated.stickyScroll.enabled" = false;

          "[nix]" = {
            "editor.insertSpaces" = true;
            "editor.tabSize" = 2;
          };
          "[typescriptreact]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };

	 "[svelte]" = {
		"editor.defaultFormatter" = "svelte.svelte-vscode";
	 };

	 "[typescript]" = {
		"editor.defaultFormatter" = "esbenp.prettier-vscode";
	 };

          "platformio-ide.useBuiltinPIOCore" = false;
        };
      };
    };
  };
}
