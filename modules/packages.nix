{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI comfort
    htop neofetch ripgrep fd bat fzf
    tree
  ];
}

