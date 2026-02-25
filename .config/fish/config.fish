if status is-interactive
    set -g fish_greeting
end

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias work="cd ~/Work"

alias ls='lsd -al --color=always'
alias la='lsd -a --color=always'
alias ll='lsd -l --color=always'
alias tree='lsd --tree --color=always'

alias reload="source ~/.config/fish/config.fish"
alias cc="clc"

function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

function proj
    cd ~/Work/$argv[1]
end

function take
    git clone $argv[1] && cd (basename $argv[1] .git)
end

starship init fish | source

function ports
    if test (count $argv) -eq 0
        sudo lsof -i -P -n | grep LISTEN
    else
        sudo lsof -i :$argv[1]
    end
end

function killport
    kill -9 (lsof -t -i:$argv[1])
end

function backup
    cp $argv[1] $argv[1].bak.(date +%Y%m%d_%H%M%S)
end

function weather
    curl -s "wttr.in/$argv[1]?format=3"
end

function clc
    rm -rf ~/.xsession-errors.old
    rm -rf ~/.xsession-errors
    rm -rf ~/.wget-hsts
    pnpm store prune
    history clear
end

set -x GPG_TTY (tty)
set -x GOPATH $HOME/.go
set -x TERM xterm-256color
set -x EDITOR nano

# pnpm
set -gx PNPM_HOME "/home/aelpxy/.local/share/pnpm"

if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

starship init fish | source
