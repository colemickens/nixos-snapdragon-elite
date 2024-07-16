{ inputs, lib, config, pkgs, modulesPath, ... }:

{
  imports = [
    ./snapdragon.nix
    (import ./snapdragon-firmware.nix { inherit inputs; })
  ];

  config = {
    boot.kernelPackages = pkgs.linuxKernel.packagesFor (
      pkgs.callPackage ./snapdragon-kernel.nix {
        kernel_src = inputs.linux-qcom-for-next;
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
