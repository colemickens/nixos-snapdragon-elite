#!/usr/bin/env bash

rsync -avh \
  --compress-choice=zstd --compress-level=3 --checksum-choice=xxh3 \
  --progress \
  --partial \
  "colemickens@aarch64.nixos.community:~/result-image-image/nixos.img" \
    "/tmp/"
