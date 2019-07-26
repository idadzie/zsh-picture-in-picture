#!/usr/bin/env zsh

# Check for requiered packages.
declare -a dependencies not_installed
dependencies=(
  xdotool
  mediainfo
  vlc
  xdpyinfo
)

for dependency in ${dependencies[@]}; do
  if (( ! ${+commands[$dependency]} )); then
    not_installed+=$dependency
  fi
done

if (( ${#not_installed[@]} > 0 )); then
  formatted_=$(printf '* %s\n' "${not_installed[@]}")
  >&2 printf '%s\n%s\n' 'Please install the following dependencies:' "$formatted_"
  exit 1
fi
