{
  flake.modules.homeManager.matlab = {pkgs, ...}: let
    matlabRoot = "/home/raskil/MATLAB/R2026a";

    matlab = pkgs.matlab-fhs.override {
      inherit matlabRoot;
      matlabUIScale = "1.5";
      matlabDesktopZoom = 150;
    };

    matlabForVSCode = pkgs.writeShellApplication {
      name = "matlab";
      text = ''
        exec ${matlab}/bin/matlab "$@"
      '';
    };

    matlabVSCodeExtension = pkgs.vscode-utils.extensionFromVscodeMarketplace {
      publisher = "MathWorks";
      name = "language-matlab";
      version = "1.3.11";
      sha256 = "1qirzmn9fvf02938jwxvwwlphhav76dwzjngkqdhxlpgj4qx2gf6";
    };
  in {
    home.packages = [
      matlab
    ];

    programs.vscode.profiles.default = {
      extensions = [
        matlabVSCodeExtension
      ];

      userSettings = {
        "MATLAB.installPath" = "${matlabForVSCode}";
        "MATLAB.matlabConnectionTiming" = "onDemand";
        "MATLAB.telemetry" = false;
      };
    };
  };
}
