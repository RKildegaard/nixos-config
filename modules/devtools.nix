{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc gnumake pkg-config
    git-crypt
    docker docker-compose
  ];
  virtualisation.docker.enable = true;
}

