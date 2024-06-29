{ inputs }:
{ lib, config, pkgs, modulesPath, ... }:

{
  config = {
    boot.kernelPackages = pkgs.linuxKernel.packagesFor (
      pkgs.callPackage ./snapdragon-kernel.nix {
        edk2_kernel_src = inputs.edk2-porting-linux-next-x1e;
      }
    );

    # # TODO: see if upstream is going to add better matching strings,
    # # otherwise this repo/iso/config is hard-wired to the Yoga 7x.
    hardware.deviceTree = {
      # only used for extlinux boot
      enable = true;
      name = "qcom/x1e80100-yoga.dtb";
    };

    # TODO: no idea if this will work, this is also WRONG, it applies latest generation DTB to all generations, but whatever for now
    boot.loader.grub.extraPerEntryConfig = "devicetree ${config.boot.kernelPackages.kernel}/dtbs/qcom/x1e80100-yoga.dtb";

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
