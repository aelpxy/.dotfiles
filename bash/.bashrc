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
# ~/.bashrc
#

figlet Hello, Aelpxy! | lolcat

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Silver Command Prompt
export SILVER_ICONS=nerd
source <(silver init)
source ~/.bash_aliases

# My  Aliases
alias ls='figlet "Files & Folders" | lolcat && echo "==================================================================" | lolcat && ls --color=auto'
alias me='figlet "Hello there, your Cool!!!" | lolcat && echo "==================================================================" | lolcat'
alias neofetch='neofetch | lolcat'
alias aelpxy='figlet Hello, Aelpxy | lolcat'
alias duck="figlet q u a c c | lolcat"
alias c="rm -rf ./.bash_history"
alias e='printf "Bye $user " | lolcat && sleep 0 && exit'
alias r="clear && source ~/.bashrc"

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# For Node Version Manager...
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
