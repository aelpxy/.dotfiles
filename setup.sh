sudo pacman -Syy
sudo pacman -Syyu
sudo pacman -S yay
sudo pacman -S git neofetch neovim fish lsd wget curl chromium seahorse noto-fonts-emoji base-devel nodejs-lts-hydrogen firefox npm go navi-bin fzf alacritty insomnia-bin visual-studio-code-bin

curl -sS https://starship.rs/install.sh | sh

mkdir ~/Workspace
mkdir ~/.ssh
rm -rf ~/.bash_*
cd ~/ && git@github.com:Aelpxy/.dotfiles.git
