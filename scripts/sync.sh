#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

FILES=()
while IFS= read -r file; do
  FILES+=("$file")
done < "$DOTFILES/scripts/files.txt"
FILES+=(vscode/settings.json)

is_wsl() {
  grep -qi microsoft /proc/version 2>/dev/null
}

windows_appdata() {
  local user
  user="$(cmd.exe /c "echo %USERNAME%" </dev/null 2>/dev/null | tr -d '\r')"
  echo "/mnt/c/Users/$user/AppData/Roaming"
}

local_path() {
  case "$1" in
    vscode/settings.json)
      if is_wsl; then
        echo "$(windows_appdata)/Code/User/settings.json"
      elif [ "$(uname -s)" = "Darwin" ]; then
        echo "$HOME/Library/Application Support/Code/User/settings.json"
      else
        echo "$HOME/.config/Code/User/settings.json"
      fi
      ;;
    .config/zed/settings.json)
      if is_wsl; then
        echo "$(windows_appdata)/Zed/settings.json"
      else
        echo "$HOME/$1"
      fi
      ;;
    *)
      echo "$HOME/$1"
      ;;
  esac
}

copy() {
  mkdir -p "$(dirname "$2")"
  rm -f "$2"
  cp "$1" "$2"
}

for file in "${FILES[@]}"; do
  repo="$DOTFILES/$file"
  device="$(local_path "$file")"

  if [ ! -e "$device" ]; then
    read -rp "$file is missing on this device, copy it from the repo? [y/N] " answer
    if [ "$answer" = "y" ]; then
      copy "$repo" "$device"
      echo "copied $file to device"
    fi
    continue
  fi

  if cmp -s "$repo" "$device"; then
    echo "in sync $file"
    continue
  fi

  echo
  echo "conflict in $file"
  diff -u --label "repo/$file" --label "device/$file" "$repo" "$device" || true

  while true; do
    read -rp "keep [r]epo, [d]evice or [s]kip? " answer
    case "$answer" in
      r) copy "$repo" "$device"; echo "device updated from repo"; break ;;
      d) copy "$device" "$repo"; echo "repo updated from device"; break ;;
      s) echo "skipped"; break ;;
    esac
  done
done

if command -v code >/dev/null; then
  list="$DOTFILES/vscode/extensions.txt"
  installed="$(code --list-extensions </dev/null 2>/dev/null | tr -d '\r' | grep -E '^[A-Za-z0-9-]+\.[A-Za-z0-9.-]+$')"
  # the wsl code cli doesn't list remote-wsl even though it's installed
  if is_wsl; then
    installed="$installed"$'\n'"ms-vscode-remote.remote-wsl"
  fi
  installed="$(sort -u <<<"$installed")"

  if [ "$installed" = "$(cat "$list")" ]; then
    echo "in sync vscode/extensions.txt"
  else
    echo
    echo "vscode extensions changed"
    diff -u --label "repo/vscode/extensions.txt" --label "device/extensions" "$list" - <<<"$installed" || true
    read -rp "update extensions.txt from device? [y/N] " answer
    if [ "$answer" = "y" ]; then
      echo "$installed" > "$list"
      echo "repo updated from device"
    fi
  fi
fi
