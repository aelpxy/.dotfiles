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
alias hc="history -c && echo 'Cleared Bash History'"
alias cls="clear"
alias la="ls -a"
alias reload="source ~/.bashrc && echo 'Reloaded!'"
alias bashtop="bpytop"
alias ve="nvim"
alias ne="nano"

export PS1="\[$(tput setaf 39)\]\u\[$(tput setaf 81)\]@\[$(tput setaf 77)\]\h \[$(tput setaf 226)\]\w \[$(tput sgr0)\]$ "

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
