# nixos-snapdragon-elite

## notes

* kernel source: [edk2-porting/linux-next@work/sakuramist-x1e80100](https://github.com/edk2-porting/linux-next/tree/work/sakuramist-x1e80100)

## problems

1. likely missing qcom firmware
2. likely won't boot since there are multiple DTS that match the board
3. The kernel source I'm using has same identifiers for (surface|yoga|vivobook), **so I'm
   hardcoding the device tree to the Yoga 7x (`x1e80100-yoga.dtb`)**.

## testing

You can use `nix` to download and extract a cached ISO. See **problems** section first.

```bash
export SDX_RESULT=/nix/store/2l9zq69q2a5ybbgjn4x7fj81iqxyhmp8-nixos-24.11.20240627.04becfd-aarch64-linux.iso

narpath="$(nix --store 'https://sdx.cachix.org' path-info $SDX_RESULT --json | jq -r '.[0].url')"
narurl="https://sdx.cachix.org/$narpath"

curl -o './sdx.iso.nar.zst' "$narurl"

rm -rf ./sdx-iso
zstdcat ./sdx.iso.nar.zst | nix-store --restore ./sdx-iso
```

and finally:
```bash
❯ ls ./sdx-iso/iso
nixos-24.11.20240624.2893f56-aarch64-linux.iso
# note, the exact filename may differ
```

(note, this downloads the ISO and all the dependent store paths, this stinks, but I'm lazy
and this is a nice easy way to get the ISO cached)

## usage

Use the module in `imports`:
* `inputs.nixos-snapdragon-elite.nixosModules.sdx`

Or build, burn, and boot the installer:
* `nix build .#packages.aarch64-linux.iso`

## cache

See: [sdx.cachix.org](https://sdx.cachix.org)

## examples

* Custom Installer
  * [colemickens/nixcfg - images - sdx-installer]()
  * uses the `nixosModules.sdx`, and already includes the iso module
  * based on my existing custom install iso:
    * includes my SSH key
    * starts SSH by default
    * includes a script that attempts to start tailscale qr login
    * includes IWD and tools so you can connect to wifi

* Custom NixOS System Config
  * built for (and not yet tested with) the Yoga Slim 7x
  * [colemickens/nixcfg - images - sevex]()
  * uses `nixosModules.sdx`
  * uses the rest of my default nixcfg modules, apps, configs, etc

## TODO

move this to `nixos-hardware`
