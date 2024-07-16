{ config
, pkgs
, lib
, inputs
, ...
}:

let
  hn = "sdxbootstrap";
  image = import "${inputs.nixpkgs}/nixos/lib/make-disk-image.nix" {
    inherit (pkgs) lib;
    pkgs = pkgs;
    config = config;
    name = "sdxbootstrap-image";
    diskSize = "auto";
    format = "raw";
    partitionTableType = "efi";
    copyChannel = false;
  };
  image_img = "${image}/nixos.img";
in
{
  imports = [
    # inputs.nixos-snapdragon-elite.nixosModules.default
    inputs.self.nixosModules.default
    # inputs.nyx.nixosModules.default
  ];

  config = {
    nixpkgs.hostPlatform = "aarch64-linux";
    # nixpkgs.buildPlatform = "x86_64-linux";

    system.stateVersion = "24.05";

    system.build.bootstrap-image = image;

    # chaotic.mesa-git.enable = true;

    hardware.graphics.enable = false;

    networking.hostName = hn;

    nix = {
      settings = {
        max-jobs = lib.mkForce 6;
      };
    };

    security.sudo.wheelNeedsPassword = false;

    users.users."root".hashedPassword = "$6$Dv9rdA32JCLsdoXE$i0NxzgmzuyU2HYj7JpvSX9h8KEAJT2bMD0Vu3P5oEiyI9SFWT1yUtqErWisWlgPk5PgbxQ16fTbqnRXiMBlCY/";
    users.users."nixos" = {
      isNormalUser = true;
      home = "/home/nixos";
      hashedPassword = "$6$Dv9rdA32JCLsdoXE$i0NxzgmzuyU2HYj7JpvSX9h8KEAJT2bMD0Vu3P5oEiyI9SFWT1yUtqErWisWlgPk5PgbxQ16fTbqnRXiMBlCY/";
      extraGroups = [
        "wheel"
      ];
    };


    services.openssh.enable = true;

    time.timeZone = lib.mkForce null; # we're on the move

    boot.supportedFilesystems = lib.mkForce [ "btrfs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs" ];
    boot.initrd.systemd.enable = true;
    boot.initrd.systemd.emergencyAccess = true;

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
      "ath12k"
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
    ];

    boot.loader.grub.enable = false;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.graceful = true;
    boot.loader.systemd-boot.installDeviceTree = true;

    ## TODO: experimental
    services.dbus.implementation = "broker";

    # programs.sway.enable = true;
    # environment.systemPackages = with pkgs; [
    #   alacritty
    # ];
    ## END experimental

    fileSystems = {
      "/boot" = {
        fsType = "vfat";
        device = "/dev/disk/by-label/ESP";
      };
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
        autoResize = true;
      };
    };
  };
}
