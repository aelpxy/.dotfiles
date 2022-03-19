#
# My Personal ~/.zshrc
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

alias upgrade="yay -Syy && yay -Syyu"
alias update="yay -Syy"

alias install="yay -S"
alias uninstall="yay -Rnscd"

alias cs="yay -Sc"
alias search="yay -Ss"

alias ls='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias l.='exa -a | egrep "^\."'

alias cls="source ~/.zshrc && clear"
alias cc="rm -rf ~/.cache && rm -rf .xsession-errors.old .xsession-errors && rm -rf 'Telegram Desktop'"
alias e="exit"
alias bashtop="bpytop"
alias show="tokei"
alias shutdown="sudo shutdown -h now"

autoload -U colors && colors

# --- STARSHIP PROMPT --- #
eval "$(starship init zsh)"

# --- GO PATH --- #
export PATH=$PATH:/usr/local/go/bin
