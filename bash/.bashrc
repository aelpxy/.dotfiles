#
# ~/.bashrc
#

[[ $- != *i* ]] && return

alias ls='ls --color=auto'

# For better navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Pacman & Yay
alias update="yay -Syy"
alias upgrade="yay -Syyu"
alias install="yay -S"
alias uninstall="yay -Rnscd"
alias cs="yay -Sc"
alias search="yay -Ss"

# Annoying stuff!
alias hc="history -c && echo 'Cleared Bash History'"
alias cls="clear"
alias reload="source ~/.bashrc && echo 'Reloaded!'"

# Nano and nvim
alias ve="nvim"
alias ne="nano"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Go
export GOPATH=$HOME/.go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# For the colours
export PS1="\[$(tput setaf 39)\]\u\[$(tput setaf 81)\]@\[$(tput setaf 77)\]\h \[$(tput setaf 226)\]\w \[$(tput sgr0)\]$ "

# End of ~/.bashrc
