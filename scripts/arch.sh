#!/usr/bin/env bash

if [ "$(uname -s)" != "Linux" ]; then
  echo "this script only runs on linux" >&2
  exit 1
fi

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

PACKAGES=(
  base-devel git github-cli openssh gnupg lsof
  fish starship zoxide lsd fzf ripgrep fd bat
  go rustup pnpm
  btop fastfetch jq wget zip unzip
  ttf-jetbrains-mono-nerd
)

GUI_PACKAGES=(ghostty alacritty zed discord spotify-launcher flameshot mpv)

GUI_AUR_PACKAGES=(helium-browser-bin visual-studio-code-bin 1password)

AUR_PACKAGES=(bun-bin)

FILES=(
  .gitconfig
  .ssh/config
  .gnupg/gpg-agent.conf
  .config/fish/config.fish
  .config/starship.toml
  .config/ghostty/config
  .config/zed/settings.json
  .claude/CLAUDE.md
  .claude/settings.json
  .codex/AGENTS.md
)

is_wsl() {
  grep -qi microsoft /proc/version
}

has_gui() {
  ! is_wsl && [ "$(systemctl get-default)" = graphical.target ]
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

echo "==> packages"
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
paru -S --needed --noconfirm "${AUR_PACKAGES[@]}"

if has_gui; then
  echo "==> gui apps"
  sudo pacman -S --needed --noconfirm "${GUI_PACKAGES[@]}"
  paru -S --needed --noconfirm "${GUI_AUR_PACKAGES[@]}"

  read -rp "install google chrome? [y/N] " answer
  if [ "$answer" = "y" ]; then
    paru -S --needed --noconfirm google-chrome
  fi

  read -rp "install ungoogled chromium? [y/N] " answer
  if [ "$answer" = "y" ]; then
    paru -S --needed --noconfirm ungoogled-chromium-bin
  fi
fi

echo "==> rust"
rustup default stable

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
