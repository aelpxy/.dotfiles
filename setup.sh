print "Checking for updates..."

sudo pacman -Syy && sudo pacman -Syyu

print "Installing Yay AUR Helper"

sudo pacman -S yay

print "Installing required packages..."

yay -S git neofetch neovim zsh lsd wget curl chromium seahorse noto-fonts-emoji ttf-nerd-fonts-symbols

curl -sS https://starship.rs/install.sh | sh

print "Finished installing packages!"

cd ~/ && git@github.com:Aelpxy/.dotfiles.git
