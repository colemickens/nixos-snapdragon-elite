{ inputs }:
{ lib, config, pkgs, modulesPath, ... }:

{
  config = {
    boot.kernelPackages = pkgs.linuxKernel.packagesFor (
      pkgs.callPackage ./snapdragon-kernel.nix {
        kernel_src = inputs.linux-qcom-for-next;
      }
    );

    # # TODO: see if upstream is going to add better matching strings,
    # # otherwise this repo/iso/config is hard-wired to the Yoga 7x.
    hardware.deviceTree = {
      # only used for extlinux boot
      enable = true;
      name = "qcom/x1e80100-lenovo-yoga-slim7x.dts";
    };

    # disable zfs for aarch64
    boot.supportedFilesystems = lib.mkForce [ "btrfs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs" ];

    # missing (at least) virtio_pci
    nixpkgs = {
      overlays = [
        (final: super: {
          makeModulesClosure = x:
            super.makeModulesClosure (x // { allowMissing = true; });
        })
      ];
    };

    # TODO: firmware?
  };
}
