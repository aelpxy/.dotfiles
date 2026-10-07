#!/usr/bin/env bash

if [ "$(uname -s)" != "Linux" ] || [ ! -f /etc/fedora-release ]; then
  echo "this script only runs on fedora" >&2
  exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
  echo "run this as your user, not root" >&2
  exit 1
fi

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

PACKAGES=(
  gcc make git gh openssh-clients gnupg2 lsof
  fish zoxide lsd fzf ripgrep fd-find bat
  golang pnpm
  btop fastfetch jq wget2-wget zip unzip
)

GUI_PACKAGES=(ghostty helium-bin alacritty flameshot mpv code 1password)

FLATPAKS=(com.discordapp.Discord com.spotify.Client)

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
# keep sudo alive so long installs don't stop for the password again
while kill -0 "$$" 2>/dev/null; do sudo -n true; sleep 60; done 2>/dev/null &

echo "==> packages"
sudo dnf upgrade -y --refresh
# even node majors are lts, so the highest even one is the newest lts
node_lts="$(dnf repoquery -q --qf '%{name}\n' 'nodejs[0-9][0-9]' | grep -E '^nodejs[0-9]*[02468]$' | sort -V | tail -n1)"
sudo dnf install -y "$node_lts" "$node_lts-bin" "${PACKAGES[@]}"

echo "==> starship"
if ! command -v starship >/dev/null; then
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
fi

if [ "$want_bun" = "y" ] && ! command -v bun >/dev/null; then
  echo "==> bun"
  # a non fish/zsh/bash shell stops the installer from editing shell configs
  curl -fsSL https://bun.sh/install | SHELL=/bin/sh bash
fi

if has_gui; then
  echo "==> gui apps"
  sudo dnf install -y dnf5-plugins flatpak
  sudo dnf copr enable -y scottames/ghostty
  sudo dnf copr enable -y imput/helium

  sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

  sudo tee /etc/yum.repos.d/1password.repo >/dev/null <<'EOF'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF

  if [ "$want_chrome" = "y" ]; then
    sudo tee /etc/yum.repos.d/google-chrome.repo >/dev/null <<'EOF'
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF
    GUI_PACKAGES+=(google-chrome-stable)
  fi

  sudo dnf install -y "${GUI_PACKAGES[@]}"

  if ! command -v zed >/dev/null; then
    curl -fsSL https://zed.dev/install.sh | sh
  fi

  if [ ! -d ~/.local/share/fonts/JetBrainsMonoNerd ]; then
    mkdir -p ~/.local/share/fonts/JetBrainsMonoNerd
    curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | tar -xJ -C ~/.local/share/fonts/JetBrainsMonoNerd
    fc-cache -f
  fi

  if [ "$want_chromium" = "y" ]; then
    FLATPAKS+=(io.github.ungoogled_software.ungoogled_chromium)
  fi
  if [ "$want_steam" = "y" ]; then
    FLATPAKS+=(com.valvesoftware.Steam)
  fi
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install -y --noninteractive flathub "${FLATPAKS[@]}"
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
