#!/usr/bin/env bash

nix run github:Mic92/nix-fast-build -- \
  --flake '.#packages.aarch64-linux.iso' \
  --remote 'colemickens@aarch64.nixos.community'
