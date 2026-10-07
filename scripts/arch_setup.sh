#!/usr/bin/env bash

if [ "$(uname -s)" != "Linux" ]; then
  echo "this script only runs on linux" >&2
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  echo "run this as your user, not root" >&2
  exit 1
fi

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

PACKAGES=(
  base-devel git github-cli openssh gnupg lsof
  fish starship zoxide lsd fzf ripgrep fd bat
  go pnpm
  btop fastfetch jq wget zip unzip pciutils
)

GUI_PACKAGES=(ghostty alacritty zed discord spotify-launcher flameshot mpv ttf-jetbrains-mono-nerd)

GUI_AUR_PACKAGES=(helium-browser-bin visual-studio-code-bin 1password)

FILES=()
while IFS= read -r file; do
  FILES+=("$file")
done < "$DOTFILES/scripts/files.txt"

is_wsl() {
  grep -qi microsoft /proc/version
}

has_gui() {
  ! is_wsl && [ "$(systemctl get-default)" = graphical.target ]
}

steam_drivers() {
  local gpus
  gpus="$(lspci | grep -Ei 'vga|3d|display')"

  if grep -q NVIDIA <<<"$gpus"; then
    if pacman -Q nvidia-utils >/dev/null 2>&1; then
      echo lib32-nvidia-utils
    else
      echo lib32-vulkan-nouveau
    fi
  fi
  if grep -qE 'AMD|ATI' <<<"$gpus"; then
    echo lib32-vulkan-radeon
  fi
  if grep -q Intel <<<"$gpus"; then
    echo lib32-vulkan-intel
  fi
}

copy() {
  local src="$DOTFILES/$1"
  local dest="$HOME/${2:-$1}"

  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ] && ! cmp -s "$src" "$dest"; then
    mv "$dest" "$dest.bak"
  fi
  cp "$src" "$dest"
  echo "copied ~/${2:-$1}"
}

read -rp "install bun? [y/N] " want_bun
if has_gui; then
  read -rp "install google chrome? [y/N] " want_chrome
  read -rp "install ungoogled chromium? [y/N] " want_chromium
  read -rp "install steam? [y/N] " want_steam
fi

sudo -v
# keep sudo alive so long builds don't stop for the password again
while kill -0 "$$" 2>/dev/null; do sudo -n true; sleep 60; done 2>/dev/null &

echo "==> packages"
if [ "${want_steam:-}" = "y" ] && ! grep -q '^\[multilib\]' /etc/pacman.conf; then
  printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' | sudo tee -a /etc/pacman.conf >/dev/null
fi
sudo pacman -Syu --noconfirm
# lts codenames are alphabetical, so the last one is the newest
node_lts="$(pacman -Ssq '^nodejs-lts-' | sort | tail -n1)"
sudo pacman -S --needed --noconfirm "$node_lts" "${PACKAGES[@]}"

echo "==> paru"
if ! command -v paru >/dev/null; then
  tmp="$(mktemp -d)"
  git clone https://aur.archlinux.org/paru-bin.git "$tmp"
  (cd "$tmp" && makepkg -si --noconfirm)
  rm -rf "$tmp"
fi
if [ "$want_bun" = "y" ]; then
  paru -S --needed --noconfirm bun-bin
fi

if has_gui; then
  echo "==> gui apps"
  sudo pacman -S --needed --noconfirm "${GUI_PACKAGES[@]}"
  paru -S --needed --noconfirm "${GUI_AUR_PACKAGES[@]}"

  if [ "$want_steam" = "y" ]; then
    # pick the 32-bit vulkan driver for this gpu instead of letting pacman guess
    sudo pacman -S --needed --noconfirm $(steam_drivers) steam
  fi
  if [ "$want_chrome" = "y" ]; then
    paru -S --needed --noconfirm google-chrome
  fi
  if [ "$want_chromium" = "y" ]; then
    paru -S --needed --noconfirm ungoogled-chromium-bin
  fi
fi

echo "==> pnpm"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME/bin:$PATH"
pnpm self-update --yes

echo "==> ai tools"
export PATH="$HOME/.local/bin:$PATH"
if ! command -v claude >/dev/null; then
  curl -fsSL https://claude.ai/install.sh | bash
fi
if ! command -v codex >/dev/null; then
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

echo "==> dotfiles"
mkdir -p ~/.ssh ~/.gnupg
chmod 700 ~/.ssh ~/.gnupg
for file in "${FILES[@]}"; do
  copy "$file"
done

echo "==> vscode"
if has_gui; then
  copy vscode/settings.json .config/Code/User/settings.json
fi
if command -v code >/dev/null; then
  "$DOTFILES/vscode/install.sh"
fi

echo "==> ssh agent"
systemctl --user enable --now ssh-agent.socket

echo "==> shell"
if [ "$SHELL" != "$(command -v fish)" ]; then
  chsh -s "$(command -v fish)"
fi

echo "done, log out and back in to start using fish"
