{ inputs }:
{ lib, config, pkgs, modulesPath, ... }:

let _mesa = inputs.nixpkgs-mesa.outputs.legacyPackages.${pkgs.system}.mesa; in
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

    

    # disable nixos's default zfs for too-new kernel
    boot.supportedFilesystems = lib.mkForce [ "btrfs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs" ];

    # NOTE: don't need to set this, apparently if we block the "_pas" module we will survive things...
    # boot.initrd.firmware = pkgs.buildEnv {
    #   name = "firmware-initrd";
    #   paths = map pkgs.compressFirmwareZstd (with pkgs; [
    #     # include some, but intentionally leave out the extra qcom fw
    #     # TODO: HACK: more here?
    #     pkgs.linux-firmware
    #   ]);
    #   pathsToLink = [ "/lib/firmware" ];
    #   ignoreCollisions = true;
    # };

    # HACK: presumably these are going away?
    boot.kernelParams = [
      "clk_ignore_unused"
      "pd_ignore_unused"

      # robclark confirmed not needed:
      # "efi=novamap"

      # likely not needed: but test in next iteration
      "regulator_ignore_unused"
      
      # supposedly not needed, remove:
      # "arm64.nopauth"
    ];

    # TODO: this is _surely_ a super set of the modules required for boot:
    boot.initrd.availableKernelModules = [
      # Make sure the initramfs includes any modules required to boot, for
      # example:
      # 	nvme phy_qcom_qmp_pcie pcie_qcom
      "nvme" "phy_qcom_qmp_pcie" "pcie_qcom"

      # for the X13s and x1e80100-crd, and
      # phy_qcom_qmp_ufs ufs_qcom
      "phy_qcom_qmp_ufs" "ufs_qcom"

      # for the sc8280xp-crd with rootfs on UFS.

      # For keyboard input and (more than 30 seconds of) display in initramfs,
      # make sure to also include:

      # 	i2c_hid_of i2c_qcom_geni
      "i2c_hid_of" "i2c_qcom_geni"

      # for keyboard, and

      # 	leds_qcom_lpg pwm_bl
      # 	qrtr pmic_glink_altmode gpio_sbu_mux phy_qcom_qmp_combo
      # 	gpucc_sc8280xp dispcc_sc8280xp
      # 	phy_qcom_edp panel_edp msm

      "leds_qcom_lpg" "pwm_bl"
      "qrtr" "pmic_glink_altmode" "gpio_sbu_mux" "phy_qcom_qmp_combo"
      "gpucc_sc8280xp" "dispcc_sc8280xp"
      "dispcc-x1e80100"
      "gpucc-x1e80100"
      "tcsrcc-x1e80100"
      "phy_qcom_edp" "panel_edp" "msm"

      "phy-qcom-qmp-usb"
      "phy-qcom-qmp-usbc"
      "phy-qcom-usb-hs"
      "phy-qcom-usb-hsic"
      "phy-qcom-usb-ss"
      "qcom_pmic_tcpm"
      "qcom_usb_vbus-regulator"

      # for the display.

      # doh, duh
      "uas"

      # random tries:
      # "ath12k" # disabling to prevent mhi from getting copied/loaded potentially
      "r8152"
      "qcom_battmgr"
      "lzo_rle"
      "msm"
      "qcom_q6v5_pas"
      "qcom_q6v5_sysmon"
      "qcom_q6v5_adsp"
      "qcom_pd_mapper"

      # ??
      "dwc3-qcom"

      # "another one"
      "evdev"

      # trigger rebuild
      "usb_storage"
      "trigger-rebuild2"

      # from: https://oftc.irclog.whitequark.org/aarch64-laptops/2024-06-28
      "phy-qcom-snps-eusb2"
      "phy-qcom-eusb2-repeater"
      "phy-qcom-snps-femto-v2"

      # try to prevent maybe-pas related crash?
      "q6routing"
      "q6prm"
      "q6prm-clocks"
      "q6com-pm8008"
      "q6com-pm8008-regulator"
    ];

    # TODO: investigate a supposed "DtbLoader.efi"? Maybe the future for auto-selection?
    hardware.deviceTree = {
      enable = true;
      name = lib.mkDefault "qcom/x1e80100-lenovo-yoga-slim7x.dtb";
    };

    # missing (at least) virtio_pci
    nixpkgs = {
      overlays = [
        (final: super: {
          makeModulesClosure = x:
            super.makeModulesClosure (x // { allowMissing = true; });

          mesa = _mesa;
        })
      ];
    };
  };
}
