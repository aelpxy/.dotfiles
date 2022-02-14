#
# ~/.bashrc
#

[[ $- != *i* ]] && return

alias ls='ls --color=auto'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias update="yay -Syy"
alias upgrade="yay -Syyu"
alias install="yay -S"
alias uninstall="yay -Rnscd"
alias cs="yay -Sc"
alias search="yay -Ss"
alias rm="rm -rf"
alias hc="history -c && history -w && echo 'Cleared history!' | lolcat"
alias cls="clear"
alias la="ls -a"
alias reload="source ~/.bashrc && echo 'Reloaded!' | lolcat"
alias bashtop="bpytop"
alias ne="nano"
alias neofetch="neofetch | lolcat"

export PS1="\[$(tput setaf 226)\]\u\[$(tput setaf 220)\]@\[$(tput setaf 214)\]\h \[$(tput setaf 33)\]\w \[$(tput sgr0)\]$ "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

