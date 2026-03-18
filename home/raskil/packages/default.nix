{ pkgs, ... }:
let
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
];

  waylandTools = with pkgs; [
    wl-clipboard
    grim
    slurp
    swappy
    wtype
    brightnessctl
    playerctl
    pulseaudio
    hypridle
  ];

  desktopApps = with pkgs; [
    signal-desktop
    firefox
    google-chrome
    nautilus
    onedrive
    spotify
    discord
    drawio
    surfer
    kicad
  ];

  audioTools = with pkgs; [
    easyeffects
    lsp-plugins
    calf
  ];
  
in
{
  home.packages = cliTools ++ waylandTools ++ desktopApps ++ audioTools;
}
