#!/usr/bin/env bash

rsync -avh --delete ~/code/nixos-snapdragon-elite \
  colemickens@aarch64.nixos.community:/home/colemickens/
  
rsync -avh --delete ~/code/nixcfg \
  colemickens@aarch64.nixos.community:/home/colemickens/
