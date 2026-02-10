{ pkgs }:

let
  wine = pkgs.wineWowPackages.stable;

  solidworksInstaller = pkgs.requireFile {
    name = "SolidWorksSetup.exe";
    message = ''
      SolidWorks installer not found.

      Put the installer at:
        ~/installers/SolidWorksSetup.exe

      Then run:
        nix hash file ~/installers/SolidWorksSetup.exe

      Put that hash into pkgs/solidworks/default.nix.
    '';
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
in
pkgs.buildFHSUserEnv {
  name = "solidworks";

  targetPkgs = pkgs: (with pkgs; [
    wine
    winetricks
    cabextract
    p7zip
    coreutils
    bash
    xorg.xrandr
    vulkan-loader
  ]);

  runScript = pkgs.writeShellScript "solidworks" ''
    set -euo pipefail

    export WINEARCH=win64
    export WINEPREFIX="''${XDG_DATA_HOME:-$HOME/.local/share}/solidworks-wine"
    mkdir -p "$WINEPREFIX"

    export WINEDLLOVERRIDES="mscoree,mshtml="

    if [ ! -d "$WINEPREFIX/drive_c/Program Files" ] && [ ! -d "$WINEPREFIX/drive_c/Program Files (x86)" ]; then
      ${wine}/bin/wineboot -u
      ${pkgs.winetricks}/bin/winetricks -q corefonts vcrun2019 || true
      exec ${wine}/bin/wine "${solidworksInstaller}"
    fi

    CANDIDATES=(
      "$WINEPREFIX/drive_c/Program Files/SOLIDWORKS Corp/SOLIDWORKS/SLDWORKS.exe"
      "$WINEPREFIX/drive_c/Program Files (x86)/SOLIDWORKS Corp/SOLIDWORKS/SLDWORKS.exe"
    )

    for exe in "''${CANDIDATES[@]}"; do
      if [ -f "$exe" ]; then
        exec ${wine}/bin/wine "$exe" "''${@:-}"
      fi
    done

    echo "SolidWorks EXE not found in prefix."
    echo "Search under: $WINEPREFIX/drive_c/Program Files*"
    exit 1
  '';
}

