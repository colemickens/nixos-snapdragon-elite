{ inputs }:

{ modulesPath, pkgs, ... }:

let
  fwpkg = (pkgs.stdenv.mkDerivation {
    name = "linux-firmware-yoga7x";
    src = inputs.firmware;

    installPhase = ''
      runHook preInstall

      # install -Dm644 ./* -t $out/
      mkdir -p $out/lib/firmware
      cp -r . $out/lib/firmware/

      ls -R $out/lib/firmware/

      runHook postInstall
    '';
  });
in
{
  config = {
    hardware.firmware = [
      fwpkg
      pkgs.linux-firmware
    ];
  };
}
