#
# ~/.zshrc
#

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias work="cd ~/go/src/github.com/aelpxy/"
alias home="cd"
alias update="yay -Syy"
alias upgrade="yay -Syyu"
alias install="yay -S"
alias uninstall="yay -Rnscd"
alias cs="yay -Sc"
alias search="yay -Ss"
alias ls='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias l.='exa -a | egrep "^\."'
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
alias arrow="echo '❯'"
autoload -U colors && colors

# STARSHIP PROMPT #
eval "$(starship init zsh)"

# GO PATH #
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
