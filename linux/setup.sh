#!/bin/bash

CONFIG_DIR="$HOME/.config"
RAW_GITHUB_URL="raw.githubusercontent.com/aelpxy/.dotfiles/main"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"

if [ "$USER" != "aelpxy" ]; then
    echo "WARNING: DO NOT RUN THE SCRIPT IF YOU DON'T TRUST ME."
fi

read -p "Are you sure you want to proceed? (yes/no) " agree

if [ "$agree" != "yes" ]; then
    echo "Exiting as $USER did not confirm"
    exit 1
fi

sudo pacman -S --needed git base-devel

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

cd .. && rm -rf yay-bin

wget https://$RAW_GITHUB_URL/linux/packages.txt -O packages.txt
yay -S $(cat packages.txt)
rm packages.txt

mkdir -p ~/.config && touch ~/.config/starship.toml
curl -sS https://$RAW_GITHUB_URL/.config/starship.toml > ~/.config/starship.toml

mkdir -p ~/.fonts/JetBrainsMono
cd ~/.fonts/JetBrainsMono && wget $FONT_URL -O font.zip && unzip font.zip
rm -rf font.zip
fc-cache -v

mkdir -p "$CONFIG_DIR"/alacritty "$CONFIG_DIR"/neofetch "$CONFIG_DIR"/btop "$CONFIG_DIR"/fish

curl -sS https://$RAW_GITHUB_URL/.config/neofetch/config.conf > "$CONFIG_DIR"/neofetch/config.conf
curl -sS https://$RAW_GITHUB_URL/.config/fish/config.fish > "$CONFIG_DIR"/fish/config.fish
curl -sS https://$RAW_GITHUB_URL/.config/btop/btop.conf > "$CONFIG_DIR"/btop/btop.conf
curl -sS https://$RAW_GITHUB_URL/.config/alacritty/alacritty.toml > "$CONFIG_DIR"/alacritty/alacritty.toml

FISH_PATH=$(which fish)
sudo chsh -s "$FISH_PATH" "$USER"

if [ "$USER" = "aelpxy" ]; then
    curl -sS https://$RAW_GITHUB_URL/.gitconfig > "$HOME"/.gitconfig
else
    echo "Skipping .gitconfig download as the $USER is not aelpxy."
fi

curl -fsSL https://get.pnpm.io/install.sh | sh -

read -p "Do you want to install Rust and Bun? (yes/no) " yn

case $yn in
    yes)
        echo "Installing Rust and Bun..."

        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        curl -fsSL https://bun.sh/install | bash

	echo "Sleeping for five seconds then rebooting..."
	sleep 5
        sudo reboot
        ;;
    no)
	echo "Sleeping for five seconds then rebooting..."
	sleep 5
        sudo reboot
        ;;
    *)
        echo "Unknown param"
        exit 1
        ;;
esac
