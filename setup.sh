CONFIG_DIR="/home/aelpxy/.config"

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

sudo yay -S git neofetch neovim fish lsd wget curl chromium seahorse noto-fonts-emoji base-devel nodejs npm btop go fzf alacritty insomnia-bin visual-studio-code-bin spotify discord zip unzip

curl -sS https://starship.rs/install.sh | sh

mkdir ~/.fonts

cd ~/.fonts && mkdir FiraCode && cd FiraCode && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip && unzip FiraCode.zip

fc-cache -v

# Instant setup
mkdir ~/Workspace
mkdir ~/.ssh && chmod 700 ~/.ssh
rm -rf ~/.bash_*
cd $CONFIG_DIR && mkdir alacritty neofetch btop fish

# I don't know if there's a better way than this :/
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/starship.toml >> $CONFIG_DIR/starship.toml
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/neofetch/config.conf >> $CONFIG_DIR/neofetch/config.conf
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/fish/config.fish >> $CONFIG_DIR/fish/config.fish
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/btop/btop.conf >> $CONFIG_DIR/btop/btop.conf
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.config/alacritty/alacritty.yml >> $CONFIG_DIR/alacritty/alacritty.yml

# TODO: Do not hardcode username
curl -L https://raw.githubusercontent.com/Aelpxy/.dotfiles/main/.gitconfig >> /home/aelpxy/.gitconfig

sudo reboot
