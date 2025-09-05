#!/usr/bin/env bash
set -euo pipefail
shopt -s globstar

ASSET=""
PLATFORM=""
VERSION=$(cat VERSION)

usage() {
  echo "Usage: $0 -a <asset-path> -p <platform-tag> -t <version>"
  exit 1
}

while getopts "a:p:t:" opt; do
  case "$opt" in
    a) ASSET="$OPTARG" ;;
    p) PLATFORM="$OPTARG" ;;
    *) usage ;;
  esac
done

if [[ -z "$ASSET" || -z "$PLATFORM" ]]; then
  usage
fi

if [[ ! -f "$ASSET" ]]; then
  echo "ERROR: Asset file '$ASSET' not found!"
  exit 1
fi

if [[ -z "$VERSION" ]]; then
  echo "ERROR: Version not specified!"
  exit 1
fi

platform_dir="vendor/act/$PLATFORM"
mkdir -p "$platform_dir" wheels

# Unpack asset
if [[ "$ASSET" == *.zip ]]; then
  unzip -q "$ASSET" -d "$platform_dir"
else
  tar -xzf "$ASSET" -C "$platform_dir"
fi

# Find and copy binary
act_bin="$(find "$platform_dir" -type f -name 'act*' -print -quit)"
if [[ -z "$act_bin" ]]; then
  echo "WARNING: Could not locate act binary inside $ASSET" >&2
else
  cp "$act_bin" "act/act"
  chmod +x "act/act"
fi

# Clean previous dist
rm -rf dist
uv build --wheel
mv "dist/*.whl" "wheels/act-${VERSION}-py3-none-any-${PLATFORM}.whl"
