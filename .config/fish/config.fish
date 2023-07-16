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
alias upgrade="yay -Syy && yay -Syyu"
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
alias shutdown="sudo shutdown -h now"
alias vi="nvim"
alias vim="vi"
alias reload="source ~/.config/fish/config.fish"
alias cc='clean_cache'
alias npm="pnpm"

# Git aliases
alias ga='git add'
alias gs='git status'
alias gc='git commit'
alias gco='git checkout'
alias gp='git pull'
alias gph='git push'

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
    rm -rf ~/.cache/*
    rm -rf ~/.wget-hsts
    sudo rm -rf /tmp/*
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s
    yay -Scc --noconfirm
    history clear
end

# Environment variables
set -x GPG_TTY (tty)
set -x PATH $PATH:/usr/local/go/bin

# Shell prompt
starship init fish | source

# pnpm
set -gx PNPM_HOME "/home/$USER/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
