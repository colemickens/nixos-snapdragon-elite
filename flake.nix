{
  description = "A very basic flake";

  inputs = {
    # HACK:
    # this nixpkgs has some hacks:
    # - this PR, which actually is good, not a hack: [insert link for device-tree pr]
    # - an abomination that rips 80-drivers.rules out of systemd to avoid some module
    nixpkgs.url = "github:colemickens/nixpkgs?ref=cmpkgs-sdx";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    linux = {
      url = "github:jhovold/linux?ref=wip/x1e80100-6.11-rc1";
      flake = false;
    };
    firmware = {
      url = "github:Seraphin-/linux-firmware-x1e80100-lenovo-yoga-slim7x";
      flake = false;
    };
  };

  outputs = inputs: rec {
    nixosConfigurations = {
      image = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          (import ./configuration-image.nix { inherit inputs; })
        ];
        specialArgs = { inherit inputs; };
      };
    };

    nixosModules = {
      default = import ./snapdragon.nix { inherit inputs; };
    };

    packages.aarch64-linux = rec {
      default = image;
      image = nixosConfigurations.image.config.system.build.bootstrap-image;
    };
  };
}
