{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:colemickens/nixpkgs?ref=cmpkgs-sdx";
    # linux-qcom-for-next = {
    #   # url = "github:edk2-porting/linux-next?ref=work/sakuramist-x1e80100";
    #   # url = "git+https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git?ref=for-next&shallow=1";
    #   url = "git+https://git.codelinaro.org/abel.vesa/linux.git?ref=x1e80100-next&shallow=1";
    #   flake = false;
    # };
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
          ./configuration-image.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };

    nixosModules = {
      default = import ./snapdragon.nix { inherit inputs; };
    };

    # apps =
    #   let
    #     pkgs_ = import inputs.nixpkgs { system = "x86_64-linux"; };
    #     image = nixosConfigurations.image.config.system.build.bootstrap-image;
    #     image_img = "${image}/nixos.img";
    #   in
    #   {
    #     test-image = {
    #       type = "app";
    #       program =
    #         (pkgs_.writeShellScript "test-image" ''
    #           ${pkgs_.qemu}/bin/qemu-img create -f qcow2 /tmp/installer-vm-vdisk1-image 10G
    #           ${pkgs_.qemu}/bin/qemu-system-aarch64 -enable-kvm -nographic -m 2048 -boot d \
    #             -machine virt,gic-version=max \
    #             -cpu max \
    #             -smp 4 \
    #             -bios "${pkgs_.OVMF.fd}/FV/QEMU_EFI.fd" \
    #             -drive file=${image_img},format=raw,readonly \
    #             -net user,hostfwd=tcp::10022-:22 -net nic
    #         '').outPath;
    #     };
    #   };

    packages.aarch64-linux = rec {
      default = image;
      image = nixosConfigurations.image.config.system.build.bootstrap-image;
    };
  };
}
