{ inputs, lib, config, pkgs, modulesPath, ... }:

{
  imports = [
    ./snapdragon.nix
  ];

  config = {
    boot.kernelPackages = pkgs.linuxKernel.packagesFor (
      pkgs.callPackage ./snapdragon-kernel.nix {
        edk2_kernel_src = inputs.edk2-porting-linux-next-x1e;
      }
    );

    # TODO: firmware?

    boot.loader = {
      # grub
      generic-extlinux-compatible.enable = false;
      systemd-boot.enable = false;
      grub.enable = true;

      # # systemd-boot
      # generic-extlinux-compatible.enable = false;
      # systemd-boot.enable = true;
      # grub.enable = false;

      # # extlinux
      # generic-extlinux-compatible.enable = true;
      # systemd-boot.enable = false;
      # grub.enable = false;
    };
  };
}
