if status is-interactive
    set -g fish_greeting
end

eval "$(/opt/homebrew/bin/brew shellenv)"

# aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias work="cd ~/Workspace"
alias ls='lsd -al --color=always'
alias la='lsd -a --color=always'
alias ll='lsd -l --color=always'
alias tree='ls --tree --color=always'
alias cls="clear"
alias install="brew install"
alias uninstall="brew uninstall"
alias search="brew search"
alias e="exit"
alias q="exit"
alias bashtop="btop"
alias htop="btop"
alias shutdown="sudo shutdown -h now"
alias reload="source ~/.config/fish/config.fish"
alias cc='clean_cache'
alias npm="pnpm"
alias header="curl -I"

function cheat
    if test (count $argv) -eq 0
        echo "Usage: cheat <topic>"
        return 1
    end
    curl -s "https://cheat.sh/$argv[1]" || echo "could not fetch cheatsheet for '$argv[1]'."
end

function weather
    if test (count $argv) -eq 0
        echo "Usage: weather <city>"
        return 1
    end
    curl -s "wttr.in/$argv[1]?format=3"
end

function clean_cache
    rm -rf ~/.xsession-errors.old
    rm -rf ~/.xsession-errors
    rm -rf ~/.wget-hsts
    brew autoremove
    brew cleanup --prune=all
    history clear
end

set -x GPG_TTY (tty)
set -x TERM xterm-256color
set -x EDITOR pico
set -gx PATH $PATH /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

starship init fish | source