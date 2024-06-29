#!/usr/bin/env bash

host="colemickens@aarch64.nixos.community"
# host="cole@100.118.5.4"
# host="root@91.107.238.153"

dir="/home/colemickens"
# dir="/tmp/"

rsync -avh --delete ~/code/nixos-snapdragon-elite \
  $host:$dir

rsync -avh --delete ~/code/nixcfg \
  $host:$dir
