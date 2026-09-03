{inputs, ...}: {
  flake.overlays.default = final: _prev: {
    matlab-fhs = inputs.self.packages.${final.stdenv.hostPlatform.system}.matlab;
  };
}
