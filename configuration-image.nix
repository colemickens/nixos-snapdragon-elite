{ inputs }:

{ config
, pkgs
, lib
, ...
}:

let
  image = import "${inputs.nixpkgs-unstable}/nixos/lib/make-disk-image.nix" {
    inherit (inputs.nixpkgs-unstable) lib;
    pkgs = (import inputs.nixpkgs-unstable { system = pkgs.system; });
    config = config;
    name = "sdxbootstrap-image";
    diskSize = "auto";
    format = "raw";
    partitionTableType = "efi";
    copyChannel = false;
  };
in
{
  imports = [
    inputs.self.nixosModules.default
    # inputs.nyx.nixosModules.default
  ];

  config = {
    documentation.enable = false;
    documentation.doc.enable = false;
    documentation.man.enable = false;
    documentation.info.enable = false;
    documentation.nixos.enable = false;

    nix.registry = lib.mkForce {};

    nixpkgs.hostPlatform = "aarch64-linux";

    networking.hostName = "yogie";
    system.stateVersion = "24.05";

    system.build.bootstrap-image = image;

    # default root/nixos and nixos/nixos
    users.users."root".hashedPassword = "$6$Dv9rdA32JCLsdoXE$i0NxzgmzuyU2HYj7JpvSX9h8KEAJT2bMD0Vu3P5oEiyI9SFWT1yUtqErWisWlgPk5PgbxQ16fTbqnRXiMBlCY/";
    users.users."nixos" = {
      isNormalUser = true;
      home = "/home/nixos";
      # password is nixos
      hashedPassword = "$6$Dv9rdA32JCLsdoXE$i0NxzgmzuyU2HYj7JpvSX9h8KEAJT2bMD0Vu3P5oEiyI9SFWT1yUtqErWisWlgPk5PgbxQ16fTbqnRXiMBlCY/";
      extraGroups = [
        "wheel"
      ];
    };
    security.sudo.wheelNeedsPassword = false;

    # TODO: remove, maybe was to minimize build?
    hardware.graphics.enable = false;
    # chaotic.mesa-git.enable = true;

    # enable ssh by default, but require user to place their ssh key somehow:
    services.openssh.enable = true;
    services.openssh.settings.PasswordAuthentication = false;

    time.timeZone = lib.mkForce null; # we're on the move

    boot.loader.grub.enable = false;
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.graceful = true;
    boot.loader.systemd-boot.installDeviceTree = true;

    ## NOTE: experimental-ish, but what I'm used to
    services.dbus.implementation = "broker";
    boot.initrd.systemd.enable = true;
    boot.initrd.systemd.emergencyAccess = true;

    # DEBUG: uncomment or add more things if you need them in intird
    # boot.initrd.systemd.extraBin = {
    #   grep = "${pkgs.gnugrep}/bin/grep";
    # };

    hardware.enableRedistributableFirmware = true;

    # programs.sway.enable = true;
    # environment.systemPackages = with pkgs; [
    #   alacritty
    # ];

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
