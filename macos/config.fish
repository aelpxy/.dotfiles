if status is-interactive
    set -g fish_greeting
end

# Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias work="cd ~/Workspace"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
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

set -x GPG_TTY (tty)
fish_add_path "/opt/homebrew/bin/"

function clean_cache
    rm -rf ~/.xsession-errors.old
    rm -rf ~/.xsession-errors
    rm -rf ~/.wget-hsts
    brew autoremove
    brew cleanup --prune=all
    history clear
end

starship init fish | source