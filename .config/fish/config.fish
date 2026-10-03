# ~/.config/fish/config.fish

# ---------- Environment (all shells) ----------
set -gx GPG_TTY (tty)
set -gx EDITOR "zed --wait"
set -gx VISUAL "zed --wait"

set -gx GOPATH $HOME/.go
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
set -gx BUN_INSTALL "$HOME/.bun"

fish_add_path $HOME/.local/bin
fish_add_path $GOPATH/bin
fish_add_path $PNPM_HOME/bin
fish_add_path $BUN_INSTALL/bin

# ---------- Interactive only ----------
if status is-interactive
    set -g fish_greeting

    # Navigation
    alias ...="cd ../.."
    alias ....="cd ../../.."
    alias .....="cd ../../../.."
    alias work="cd ~/Workspace"

    # Listing
    alias ls='lsd -al --color=auto'
    alias la='lsd -a --color=auto'
    alias ll='lsd -l --color=auto'
    alias tree='lsd --tree --depth 2 --color=auto'

    # Misc
    alias reload="exec fish"

    starship init fish | source
    zoxide init fish --cmd cd | source
end

# ---------- Functions ----------
function ports --description "List listening ports, or what's on a given port"
    if test (count $argv) -eq 0
        sudo lsof -i -P -n | grep LISTEN
    else
        sudo lsof -i :$argv[1] -P -n
    end
end

function killport --description "Kill whatever is bound to a port"
    if test (count $argv) -eq 0
        echo "usage: killport <port>"
        return 1
    end

    set -l pids (lsof -t -i:$argv[1])
    if test -z "$pids"
        echo "nothing listening on port $argv[1]"
        return 1
    end

    kill $pids
    sleep 1
    for p in $pids
        if kill -0 $p 2>/dev/null
            kill -9 $p
            echo "force killed $p"
        end
    end
end

function backup --description "Timestamped copy of a file"
    if test (count $argv) -eq 0
        echo "usage: backup <file>"
        return 1
    end
    cp -r $argv[1] $argv[1].bak.(date +%Y%m%d_%H%M%S)
end

function cleanup --description "Clear caches and stray dotfiles"
    rm -f ~/.xsession-errors ~/.xsession-errors.old ~/.wget-hsts
    command -q pnpm; and pnpm store prune
    if command -q paru
        paru -Sc --noconfirm
    else if command -q pacman
        sudo pacman -Sc --noconfirm
    end
    command -q brew; and brew cleanup
    echo "done"
end

if test -S "$XDG_RUNTIME_DIR/ssh-agent.socket"
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
end
