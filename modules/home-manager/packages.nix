{inputs, ...}: {
  flake.modules.homeManager.packages = {pkgs, ...}: let
    kicadWithTkinter = pkgs.kicad.overrideAttrs (old: {
      installPhase = builtins.replaceStrings
        [ ''--set PYTHONPATH "$program_PYTHONPATH"'' ]
        [ ''--set PYTHONPATH "$program_PYTHONPATH:${pkgs.python314Packages.tkinter}/${pkgs.python314.sitePackages}"'' ]
        old.installPhase;
    });

    cliTools = with pkgs; [
      curl
      wget
      jq
      gum
      ripgrep
      fd
      bat
      eza
      unzip
      zip
      btop
      htop
      tree
      kubectl
      kubeseal
      teleport
      glab
      glow
      comma
      pdfgrep
      yt-dlp
      codex 
   ];

    waylandTools = with pkgs; [
      wl-clipboard
      wtype
      playerctl
    ];

    quickCaptureTools = with pkgs; [
      gpu-screen-recorder
      wf-recorder
      ffmpeg
      imagemagick
      img2pdf
      tesseract
      zbar
      procps
    ];

    desktopApps = with pkgs; [
      signal-desktop
      firefox
      google-chrome
      onedrive
      spotify
      discord
      keepassxc
      drawio
      surfer
      kicadWithTkinter
      gthumb
      fritzing
      mixxx
      ltspice
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.artcraft-launcher
    ];

   requirements = with pkgs; [
      openssl
   ];

    audioPlugins = with pkgs; [
      lsp-plugins
      calf
    ];
  in {
    home.packages = cliTools ++ waylandTools ++ quickCaptureTools ++ desktopApps ++ requirements ++ audioPlugins;
  };
}
