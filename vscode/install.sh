#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"

set --
while IFS= read -r ext; do
  [ -n "$ext" ] && set -- "$@" --install-extension "$ext"
done < extensions.txt

code "$@"
