#!/usr/bin/env bash

isodrv=".#packages.aarch64-linux.iso"

nix run github:Mic92/nix-fast-build -- --no-nom --flake $isodrv \
  | cachix push sdx 

# TODO: god damnit nix-fast-build
result=$(nix eval --raw $isodrv)
sed -i "s|export SDX_RESULT=.*|export SDX_RESULT=$result|g" README.md
