{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:colemickens/nixpkgs?ref=cmpkgs";
    linux-qcom-for-next = {
      # url = "github:edk2-porting/linux-next?ref=work/sakuramist-x1e80100";
      # url = "git+https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git?ref=for-next&shallow=1";
      url = "git+https://git.codelinaro.org/abel.vesa/linux.git?ref=x1e80100-next&shallow=1";
      flake = false;
    };
  };

  outputs = inputs: rec {
    nixosConfigurations = {
      installer-sdx = inputs.nixpkgs.lib.nixosSystem {
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

    apps = {
      test-vm =
        let
          installer = nixosConfigurations.installer-sdx.config.system.build;
          installerIso = "${installer.isoImage}/iso/${installer.isoImage.isoName}";
          pkgs_ = import inputs.nixpkgs { system = "aarch64-linux"; };
        in
        {
          type = "app";
          program =
            (pkgs_.writeShellScript "test-vm" ''
              ${pkgs_.qemu}/bin/qemu-img create -f qcow2 /tmp/installer-vm-vdisk1 10G
              ${pkgs_.qemu}/bin/qemu-system-aarch64 -enable-kvm -nographic -m 2048 -boot d \
                -machine virt,gic-version=max \
                -cpu max \
                -smp 4 \
                -bios "${pkgs_.OVMF.fd}/FV/QEMU_EFI.fd" \
                -cdrom "${installerIso}" -hda /tmp/installer-vm-vdisk1 \
                -net user,hostfwd=tcp::10022-:22 -net nic
            '').outPath;
        };
    };

    packages.aarch64-linux = {
      iso = nixosConfigurations.sdx-installer.config.system.build.isoImage;
    };
  };
}
