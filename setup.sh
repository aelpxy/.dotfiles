CONFIG_DIR="/home/aelpxy/.config/"

sudo pacman -Syy
sudo pacman -Syyu
sudo pacman -S yay
sudo pacman -S git neofetch neovim fish lsd wget curl chromium seahorse noto-fonts-emoji base-devel nodejs-lts-hydrogen firefox npm go navi-bin fzf alacritty insomnia-bin visual-studio-code-bin

curl -sS https://starship.rs/install.sh | sh

# Instant setup
mkdir ~/Workspace
mkdir ~/.ssh && chmod 700 ~/.ssh
rm -rf ~/.bash_*
cd $CONFIG_DIR && mkdir alacritty neofetch btop fish

# I don't know if there's a better way than this :/
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/starship.toml >> $CONFIG_DIR/starship.toml
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/neofetch/config.conf >> $CONFIG_DIR/neofetch/config.conf
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/fish/config.fish >> $CONFIG_DIR/fish/config.fish
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/btop/btop.conf $CONFIG_DIR/btop/btop.conf
