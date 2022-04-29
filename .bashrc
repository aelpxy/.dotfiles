#
# My Personal ~/.bashrc
#

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."


alias space="cd ~/workspace"
alias work="cd ~/workspace"
alias home="cd ~/"

alias upgrade="yay -Syy && yay -Syyu"
alias update="yay -Syy"

alias install="yay -S"
alias uninstall="yay -Rnscd"

alias cs="yay -Sc"
alias search="yay -Ss"

alias ls='lsd -al --color=always'
alias la='lsd -a --color=always'
alias ll='lsd -l --color=always'

alias cls="source ~/.bashrc && clear"
alias cc="rm -rf ~/.xsession-errors.old && rm -rf ~/.xsession-errors && rm -rf ~/.wget-hsts && sudo rm -rf ./tmp/ && echo 'Garbage purged! \n'"
alias e="exit"
alias q="exit"
alias bashtop="~/.local/bin/btop"
alias btop="bashtop"
alias show="tokei"
alias shutdown="sudo shutdown -h now"
alias vi="nvim"
alias vim="vi"

wttr(){
  curl wttr.in/$1
}

cheat(){
  curl cht.sh/$1/$2
}

# autoload -U colors && colors

# ENV Vars
export EDITOR=nvim
eval "$(starship init bash)"
export GPG_TTY=$(tty)