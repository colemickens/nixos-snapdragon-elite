{ inputs }:

{ modulesPath, ... }:

stdenv.mkDerivation {
  name = "linux-firmwarer-yoga7x";
  src = inputs.firmware;
}
