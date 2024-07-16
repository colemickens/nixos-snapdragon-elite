{ inputs, lib, config, pkgs, modulesPath, ... }:

{
  imports = [
    (import ./snapdragon.nix { inherit inputs; })
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];

  config = {
    sdImage.compressImage = false;
  };
}
