if status is-interactive
    set -g fish_greeting
end

# Aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias work="cd ~/Workspace"
alias upgrade="yay -Syyu"
alias update="yay -Syy"
alias install="yay -S"
alias uninstall="yay -Rnscd"
alias search="yay -Ss"
alias localsearch="yay -Qs"
alias ls='lsd -al --color=always'
alias la='lsd -a --color=always'
alias ll='lsd -l --color=always'
alias cls="clear"
alias e="exit"
alias q="exit"
alias bashtop="btop"
alias htop="btop"
alias shutdown="sudo shutdown -h now"
alias vi="nvim"
alias vim="vi"
alias reload="source ~/.config/fish/config.fish"
alias cc='clean_cache'
alias npm="pnpm"
alias header="curl -I"
alias clock="timedatectl"

# Wireguard
alias wgon='sudo wg-quick up'
alias wgoff='sudo wg-quick down'

# Functions
function weather
    command curl -s https://wttr.in/$argv
end

function investigate
   find ~/ -iname "*$argv*" -type f -print
end

function clean_cache
    rm -rf ~/.xsession-errors.old
    rm -rf ~/.xsession-errors
    rm -rf ~/.wget-hsts
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s
    yay -Scc --noconfirm
    pnpm store prune
    history clear
end

# Environment variables

set -x GPG_TTY (tty)
set -x PATH $PATH:/usr/local/go/bin
set -x PATH $PATH:/$HOME/.cargo/bin

# Shell prompt
starship init fish | source

# For alacritty
set -x TERM "xterm-256color"
set -x EDITOR "micro"

# pnpm
set -gx PNPM_HOME "/home/aelpxy/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
