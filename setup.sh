print "Checking for updates..."
sudo pacman -Syy && sudo pacman -Syyu
print "Installing Yay AUR Helper"
sudo pacman -S yay
print "Installing required packages..."
yay -S git neofetch neovim zsh starship lsb wget curl chromium visual-studio-code-bin seahorse
print "Finished installing packages!"
