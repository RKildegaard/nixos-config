{ pkgs, ... }:
let
  cliTools = with pkgs; [
    curl
    wget
    jq
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
  ];

  waylandTools = with pkgs; [
    wl-clipboard
    cliphist
    grim
    slurp
    swappy
    wtype
    brightnessctl
    playerctl
    pulseaudio
  ];

  desktopApps = with pkgs; [
    signal-desktop
    firefox
    google-chrome
    onedrive
    spotify
    gnome-control-center
    gnome-bluetooth
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
