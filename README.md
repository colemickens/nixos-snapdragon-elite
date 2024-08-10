# nixos-snapdragon-elite

```shell
$ nix build .#image
ls result/nixos.img
```

## notes

flake provides:

* wip nixos module for configuring a system for Yoga 7x
* a USB-bootable image for the Yoga 7x
  * image includes sway but doesn't configure it
  * you can probably switch to TTY, and run `WAYLAND_DISPLAY=1 alacritty`

uses:
* linux kernel source: https://github.com/jhovold/linux/blob/e92057c615fec749fefcca4ab28ee5c425e3691b/arch/arm64/configs/johan_defconfig#L340

since there is no proper solution for choosing a DTB, your system/image must be model specific.

you can edit this, or probably set `hardware.device-tree.name` to your DTB

* add link to where to fnd dtb names

## status

* boots, gets to stage 2
* and then crashes, current suspicion in #aarch64-laptops is that it's a udev rule loading, some driver doing something?

## code stuffs

* mesa - vendored, hacked up copy of K900's mesa-24.2 PR, no idea if it works, but should include gallium driver for these laptops
* linux - uses [jhovald]()'s tree and `johan_defconfig`
