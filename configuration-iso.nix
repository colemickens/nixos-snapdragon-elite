{ inputs, lib, config, pkgs, modulesPath, ... }:

{
  imports = [
    ./snapdragon.nix
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  config = {

  };
}
