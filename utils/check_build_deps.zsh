#!/usr/bin/env zsh

# Check for libx11-dev.
declare -a pkglib11 
pkglib11=$(dpkg --get-selections libx11-dev)
if [[ -z $pkglib11 ]]; then
  echo >&2 "Please install 'libx11-dev' build dependency."
  exit 1
fi
