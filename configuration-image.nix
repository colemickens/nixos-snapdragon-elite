{ inputs, lib, config, pkgs, modulesPath, ... }:

{
  imports = [
    (import ./snapdragon.nix { inherit inputs; })
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
  ];

  config = {
    isoImage.squashfsCompression = null;
  };
}
