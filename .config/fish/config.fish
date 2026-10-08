# ~/.config/fish/config.fish

# ---------- Environment (all shells) ----------
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

set -gx EDITOR nano
set -gx VISUAL nano

set -gx GOPATH $HOME/.go
if test (uname) = Darwin
    set -gx PNPM_HOME "$HOME/Library/pnpm"
else
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end
set -gx BUN_INSTALL "$HOME/.bun"

fish_add_path $HOME/.local/bin
fish_add_path $GOPATH/bin
fish_add_path $PNPM_HOME/bin
fish_add_path $BUN_INSTALL/bin
fish_add_path /opt/homebrew/opt/node@24/bin

# ---------- Interactive only ----------
if status is-interactive
    set -g fish_greeting
    set -gx GPG_TTY (tty)

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

    function starship_transient_prompt_func
        starship module character
    end
    starship init fish | source
    enable_transience
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

function unlock --description "Cache GPG signing key and SSH key passphrases"
    set -l key (git config --global --includes user.signingkey)
    if test -n "$key"
        echo unlock | gpg --clearsign -u $key >/dev/null; and echo "gpg unlocked"
    end
    set -l keys
    for pub in ~/.ssh/*.pub
        set -l priv (string replace -r '\.pub$' '' -- $pub)
        test -f $priv; and set -a keys $priv
    end
    test -n "$keys"; and ssh-add $keys
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
