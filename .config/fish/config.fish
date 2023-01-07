if status is-interactive
end

set -g fish_greeting

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias work="cd ~/Workspace"

alias upgrade="yay -Syy && yay -Syyu"
alias update="yay -Syy"
alias install="yay -S"
alias uninstall="yay -Rnscd"
alias cs="yay -Sc"
alias search="yay -Ss"
alias localsearch="yay -Qs"

alias ls='lsd -al --color=always'
alias la='lsd -a --color=always'
alias ll='lsd -l --color=always'

alias cls="clear"
alias cc="rm -rf ~/.xsession-errors.old && rm -rf ~/.xsession-errors && rm -rf ~/.cache && rm -rf ~/.wget-hsts && sudo rm -rf ./tmp/ && rm -rf ~/.npm"
alias e="exit"
alias q="exit"
alias bashtop="btop"
alias shutdown="sudo shutdown -h now"
alias vi="nvim"
alias vim="vi"

set -x GPG_TTY (tty)
set -x PATH $PATH:/usr/local/go/bin
starship init fish | source
