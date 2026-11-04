{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  dbus,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
  zenity,
}:
stdenv.mkDerivation rec {
  pname = "artcraft-launcher";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/storytold/craft-launcher/releases/download/v${version}/artcraft-launcher-${version}-linux-x86_64.tar.gz";
    sha256 = "612df2a99aa00f6a0598f007fd67509ea08afb25aec9565176ae817100023d2f";
  };

  sourceRoot = "artcraft-launcher-${version}-linux-x86_64";
  dontBuild = true;

  nativeBuildInputs = [autoPatchelfHook makeWrapper];
  buildInputs = [stdenv.cc.cc.lib];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    cp -r bin share "$out/"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/artcraft-launcher" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        dbus
        libGL
        libX11
        libXcursor
        libXi
        libXrandr
        libxcb
        libxkbcommon
        vulkan-loader
        wayland
      ]}:/run/opengl-driver/lib" \
      --prefix PATH : "${lib.makeBinPath [zenity]}"
  '';

  meta = with lib; {
    description = "Launcher for the ArtCraft app suite";
    homepage = "https://github.com/storytold/craft-launcher";
    license = with licenses; [mit asl20];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    platforms = ["x86_64-linux"];
    mainProgram = "artcraft-launcher";
  };
}
