{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:colemickens/nixpkgs?ref=cmpkgs";
    edk2-porting-linux-next-x1e = {
      url = "github:edk2-porting/linux-next?ref=work/sakuramist-x1e80100";
      flake = false;
    };
  };

  outputs = inputs: rec {
    nixosConfigurations = {
      sdx-installer = inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./configuration-iso.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };

    nixosModules = {
      default = import ./snapdragon.nix { inherit inputs; };
    };

    packages.aarch64-linux = {
      iso = nixosConfigurations.sdx-installer.config.system.build.isoImage;
    };
  };
}
