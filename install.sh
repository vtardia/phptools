#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [ ! -d "$HOME/bin" ]; then
  mkdir "$HOME/bin"
fi

FILES=$(ls "$PWD/bin")
for file in $FILES; do
  src="$PWD/bin/$file"
  dst="$HOME/bin/$file"
  echo "Linking $src => $dst"
  [ -f "$src" ] && ln -s "$src" "$dst"
done
unset file;
