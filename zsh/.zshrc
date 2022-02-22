#
##
### ~/.zshrc
##
#

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
# alias hc="history -c && history -w && echo 'Cleared history!' | lolcat"
alias cls="clear"
alias reload="source ~/.zshrc && echo 'Reloaded!' | lolcat"
alias bashtop="bpytop"
alias ne="nano"

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
