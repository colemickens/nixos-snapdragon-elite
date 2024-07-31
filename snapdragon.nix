{ inputs }:
{ lib, config, pkgs, modulesPath, ... }:

{
  imports = [
    # disable firmware to see if omitting adsp firmware allows USB to continue working
    # (import ./snapdragon-firmware.nix { inherit inputs; })
  ];
  config = {
    boot.kernelPackages = pkgs.linuxKernel.packagesFor (
      pkgs.callPackage ./snapdragon-kernel-johan.nix {
        kernel_src = inputs.linux;
      }
    );

    boot.kernelParams = [
      "clk_ignore_unused"
      "pd_ignore_unused"
      "efi=novamap"

      # maybe useful for boot debug, not sure if otherwise harmful
      "regulator_ignore_unused"
      
      # supposedly not needed, remove:
      # "arm64.nopauth"
    ];

    # # TODO: see if upstream is going to add better matching strings,
    # # otherwise this repo/iso/config is hard-wired to the Yoga 7x.
    hardware.deviceTree = {
      # only used for extlinux boot
      enable = true;
      name = "qcom/x1e80100-lenovo-yoga-slim7x.dtb";
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
  };
}
