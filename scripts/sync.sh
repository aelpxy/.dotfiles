#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

FILES=(
  .gitconfig
  .gnupg/gpg-agent.conf
  .config/fish/config.fish
  .config/starship.toml
  .config/ghostty/config
  .config/zed/settings.json
  .claude/CLAUDE.md
  .claude/settings.json
  .codex/AGENTS.md
  vscode/settings.json
)

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
