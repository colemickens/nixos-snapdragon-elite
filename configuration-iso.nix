{ inputs, lib, config, pkgs, modulesPath, ... }:

{
  imports = [
    (import ./snapdragon.nix { inherit inputs; })
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  config = {
    isoImage.squashfsCompression = null;
  };
}
