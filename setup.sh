print "Checking for updates..."
sudo pacman -Syy && sudo pacman -Syyu
print "Installing Yay AUR Helper"
sudo pacman -S yay
print "Installing required packages..."
yay -S git neofetch neovim zsh starship lsd wget curl chromium seahorse
print "Finished installing packages!"
