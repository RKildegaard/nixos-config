{ pkgs, ... }:
{
  # Pure package list for user scope.
  home.packages = with pkgs; [
    # CLIs
    curl wget jq ripgrep fd bat eza unzip zip
    btop htop tree

    # Wayland helpers
    wl-clipboard
    cliphist
    grim slurp
    swappy          # (optional) annotate screenshots
    wtype           # (optional) fake keyboard input for scripts

    # Desktop apps (add/remove to taste)
    signal-desktop
    firefox
    # vscode   # enable here *or* in programs.nix via programs.vscode.enable

    # Theming/fonts at user scope (optional; many prefer system-wide)
    # (nerdfonts could be huge; install system-wide in modules if you can)
  ];
}

