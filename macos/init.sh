##!/bin/zsh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install neofetch fish lsd wget curl jq nodejs tree tokei starship btop

# Setup starship prompt
mkdir -p ~/.config && touch ~/.config/starship.toml
curl -sS https://raw.githubusercontent.com/aelpxy/.dotfiles/main/.config/starship.toml > ~/.config/starship.toml

CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"/btop "$CONFIG_DIR"/fish"

curl -sS https://raw.githubusercontent.com/aelpxy/.dotfiles/main/.config/btop/btop.conf > "$CONFIG_DIR"/btop/btop.conf
curl -sS https://raw.githubusercontent.com/aelpxy/.dotfiles/main/.gitconfig > "$HOME"/.gitconfig