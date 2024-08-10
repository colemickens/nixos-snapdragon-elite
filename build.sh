#!/usr/bin/env bash

set -x
set -euo pipefail

nix build -L --keep-going \
  .#nixosConfigurations.image.config.system.build.toplevel \
  --out-link ~/result-image-toplevel \
  --print-out-paths \
  ${@} \
  | cachix push colemickens

nix build -L --keep-going \
  --print-out-paths \
  .#nixosConfigurations.image.config.system.build.bootstrap-image \
  --out-link ~/result-image-image \
  ${@}
