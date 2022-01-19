# ~/.bashrc

rm -rf ./.bash_history
alias cls="source ~/.bashrc"
alias python="python3"
alias e="exit"
alias add="sudo apt install"
alias remove="sudo apt purge"
alias update="sudo apt update -y"
alias upgrade="sudo apt upgrade -y"
alias distro="sudo apt dist-upgrade -y"
alias clean="sudo apt autoclean -y"
alias autoremove="sudo apt autoremove -y"
alias search="apt search"

# Quicker navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

## node version manager
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

## go
export GOPATH=$HOME/.go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

## synth-shell-prompt.sh
if [ -f /home/aelpxy/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
	source /home/aelpxy/.config/synth-shell/synth-shell-prompt.sh
fi

# End of ~/.bashrc
