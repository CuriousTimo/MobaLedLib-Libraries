#!/usr/bin/env bash
# Builds the release files from libraries.txt into dist/:
#   dist/<Name>-<version>.zip          one library, for Arduino IDE "Sketch > Include Library > Add .ZIP Library..."
#   dist/MobaLedLib-Libraries-<tag>.zip all libraries in a "libraries" folder, to unpack into the sketchbook
#   dist/SHA256SUMS
# Usage: ./build.sh <tag>      (e.g. ./build.sh 3.5.0-1)
set -euo pipefail

tag=${1:?usage: ./build.sh <tag>}
here=$(cd "$(dirname "$0")" && pwd)
dist="$here/dist"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
rm -rf "$dist"
mkdir -p "$dist" "$work/all/libraries"

while read -r name version kind source sum; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  zip="$dist/$name-$version.zip"
  case "$kind" in
    index)
      curl -sSfL -o "$zip" "$source"
      echo "$sum  $zip" | shasum -a 256 -c --status || { echo "checksum mismatch: $name" >&2; exit 1; }
      ;;
    git)
      git clone -q "$source" "$work/$name.git"
      git -C "$work/$name.git" archive --format=zip --prefix="$name/" -o "$zip" "$sum"
      ;;
    *) echo "unknown kind: $kind" >&2; exit 1 ;;
  esac
  # In the bundle each library sits in a folder named like the library, as the Arduino IDE installs it.
  mkdir "$work/unz"
  unzip -q "$zip" -d "$work/unz"
  top=$(find "$work/unz" -mindepth 1 -maxdepth 1)
  [[ $(echo "$top" | wc -l) -eq 1 ]] || { echo "zip has more than one top folder: $name" >&2; exit 1; }
  mv "$top" "$work/all/libraries/$name"
  rmdir "$work/unz"
  echo "$name $version"
done < "$here/libraries.txt"

cp "$here/README.md" "$work/all/README.md"
(cd "$work/all" && zip -qr -X "$dist/MobaLedLib-Libraries-$tag.zip" README.md libraries)
(cd "$dist" && shasum -a 256 -- *.zip > SHA256SUMS)
echo "done: $dist"
