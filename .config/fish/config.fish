if status is-interactive
    set -g fish_greeting
end

# set brew eval
eval "$(/opt/homebrew/bin/brew shellenv)"

# aliases
alias ..="z .."
alias ...="z ../.."
alias ....="z ../../.."
alias .....="z ../../../.."

# workspace
alias work="z ~/Workspace"

# grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# upgrades
alias upgrade="brew upgrade"
alias update="brew upgrade"
alias install="brew install"
alias uninstall="brew uninstall"
alias search="brew search"

# ls but with colors
alias ls='lsd -al --color=always'
alias la='lsd -a --color=always'
alias ll='lsd -l --color=always'
alias tree='lsd --tree --color=always'

# helpers
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

function investigate
   find ~/ -iname "*$argv*" -type f -print
end

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
    pnpm store prune
    history clear
end

set -x GPG_TTY (tty)
set -x TERM xterm-256color
set -x EDITOR nvim
set -x FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

set -gx PATH $PATH /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
set -gx PNPM_HOME "$HOME/.local/share/pnpm"

fish_add_path /opt/homebrew/opt/node@22/bin

zoxide init fish | source
starship init fish | source