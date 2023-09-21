#!/bin/bash

# Install dependencies
sudo pacman -S --needed git base-devel

# Install yay from AUR
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

# Install packages using yay
sudo yay -S git neofetch neovim fish lsd wget curl chromium seahorse noto-fonts-emoji base-devel nodejs btop go fzf alacritty insomnia-bin visual-studio-code-bin spotify discord zip unzip flameshot tree jq tokei wireguard-tools openresolv

# Install and configure Starship prompt
curl -sS https://starship.rs/install.sh | sh
mkdir -p ~/.config && touch ~/.config/starship.toml
curl -sS https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/starship.toml > ~/.config/starship.toml

# Install FiraCode font
mkdir -p ~/.fonts/FiraCode
cd ~/.fonts/FiraCode && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip && unzip FiraCode.zip
fc-cache -v

# Create directories for configuration files
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"/alacritty "$CONFIG_DIR"/neofetch "$CONFIG_DIR"/btop "$CONFIG_DIR"/fish

# Download configuration files
curl -sS https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/neofetch/config.conf > "$CONFIG_DIR"/neofetch/config.conf
curl -sS https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/fish/config.fish > "$CONFIG_DIR"/fish/config.fish
curl -sS https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/btop/btop.conf > "$CONFIG_DIR"/btop/btop.conf
curl -sS https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/alacritty/alacritty.yml > "$CONFIG_DIR"/alacritty/alacritty.yml

# Copy Git config file
curl -sS https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.gitconfig > "$HOME"/.gitconfig

# Install pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Install Bun
curl -fsSL https://bun.sh/install | bash

# Change default shell to Fish
FISH_PATH=$(which fish)
sudo chsh -s "$FISH_PATH" "$USER"

# Reboot the system
sudo reboot
