#!/bin/bash

# Install dependencies
sudo pacman -S --needed git base-devel

# Install yay from AUR
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

# Install packages using yay
yay -S neofetch neovim fish lsd wget curl chromium seahorse noto-fonts-emoji nodejs btop go fzf alacritty visual-studio-code-bin spotify discord zip unzip flameshot tree jq tokei whois starship

# Setup starship prompt
mkdir -p ~/.config && touch ~/.config/starship.toml
curl -sS https://raw.githubusercontent.com/aelpxy/.dotfiles/main/.config/starship.toml > ~/.config/starship.toml

# Install JetBrains font
mkdir -p ~/.fonts/JetBrainsMono
cd ~/.fonts/JetBrainsMono && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip && unzip JetBrainsMono.zip
fc-cache -v

# Create directories for configuration files
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"/alacritty "$CONFIG_DIR"/neofetch "$CONFIG_DIR"/btop "$CONFIG_DIR"/fish

# Download configuration files
curl -sS https://raw.githubusercontent.com/aelpxy/.dotfiles/main/.config/neofetch/config.conf > "$CONFIG_DIR"/neofetch/config.conf
curl -sS https://raw.githubusercontent.com/aelpxy/.dotfiles/main/.config/fish/config.fish > "$CONFIG_DIR"/fish/config.fish
curl -sS https://raw.githubusercontent.com/aelpxy/.dotfiles/main/.config/btop/btop.conf > "$CONFIG_DIR"/btop/btop.conf
curl -sS https://raw.githubusercontent.com/aelpxy/.dotfiles/main/.config/alacritty/alacritty.toml > "$CONFIG_DIR"/alacritty/alacritty.toml

# Copy Git config file
curl -sS https://raw.githubusercontent.com/aelpxy/.dotfiles/main/.gitconfig > "$HOME"/.gitconfig

# Install pnpm
curl -fsSL https://get.pnpm.io/install.sh | sh -

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Change default shell to Fish
FISH_PATH=$(which fish)
sudo chsh -s "$FISH_PATH" "$USER"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -fsSL https://bun.sh/install | bash

# Reboot the system
sudo reboot