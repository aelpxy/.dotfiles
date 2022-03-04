# ~/.zshrc

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
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
alias cls="clear"
alias reload="source ~/.zshrc && echo 'Reloaded!'"
alias bashtop="bpytop"
alias ne="nano"

autoload -U colors && colors
eval "$(starship init zsh)"
# Go Variables #

export PATH=$PATH:/usr/local/go/bin
