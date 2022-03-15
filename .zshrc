#
# ~/.zshrc
#

#                Grep Aliases               #
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#                CD   Aliases               #
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias work="cd ~/go/src/github.com/aelpxy/"
alias home="cd ~/"

#                Yay  Aliases               #
alias update="yay -Syy"
alias upgrade="yay -Syyu"
alias install="yay -S"
alias uninstall="yay -Rnscd"
alias cs="yay -Sc"
alias search="yay -Ss"

#		       LS               	#
alias ls="ls -la"

#               Useful Aliases               #
alias cls="clear"
alias reload="source ~/.zshrc"
alias cc="rm -rf ~/.cache && rm -rf .xsession-errors.old .xsession-errors && rm -rf 'Telegram Desktop'"
alias e="exit"
alias vim="nvim"
alias edit="nvim"
alias sysuse="bpytop"
alias bashtop="bpytop"
alias show="tokei"
alias shutdown="sudo shutdown -h now"
autoload -U colors && colors

# StarShip Prompt
eval "$(starship init zsh)"

# Go PATH #
export PATH=$PATH:/usr/local/go/bin
