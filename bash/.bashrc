# ~/.bashrc
#  __  __         ____                                 _ 
# |  \/  |_   _  |  _ \ ___ _ __ ___  ___  _ __   __ _| |
# | |\/| | | | | | |_) / _ \ '__/ __|/ _ \| '_ \ / _` | |
# | |  | | |_| | |  __/  __/ |  \__ \ (_) | | | | (_| | |
# |_|  |_|\__, | |_|   \___|_|  |___/\___/|_| |_|\__,_|_|
#         |___/                                          
#  ____            _              
# | __ )  __ _ ___| |__  _ __ ___ 
# |  _ \ / _` / __| '_ \| '__/ __|
# | |_) | (_| \__ \ | | | | | (__ 
# |____/ \__,_|___/_| |_|_|  \___|
#
case $- in
    *i*) ;;
      *) return;;
esac

history -c
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias c="rm -rf ./.bash_history"
alias i="sudo apt install"
alias u="sudo apt purge"
alias u="sudo apt update"
alias upgrade="sudo apt upgrade -y"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
