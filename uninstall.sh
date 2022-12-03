#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

FILES=$(ls "$PWD/bin")
for file in $FILES; do
  dst="$HOME/bin/$file"
  echo "Unlinking $dst"
  [ -f "$dst" ] && rm "$dst"
done
unset file;
