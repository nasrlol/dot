# ~/.bashrc

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Color definitions
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
BLUE='\[\e[34m\]'
YELLOW='\[\e[33m\]'
CYAN='\[\e[36m\]'
RESET='\[\e[0m\]'

export PS1="${RED}\u ${CYAN}\w ${GREEN}→ ${RESET}"

export XDG_SESSION_TYPE=wayland
export WLR_BACKENDS="libinput,headless,wayland,x11"

alias push='git push'
alias add='git add .'
alias vim=nvim
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias gs='git status'
alias gc='git commit -m "quick commit"'
alias ..='cd ..'
alias ...='cd ../..'

alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qdtq)'

alias bashrc="vim ~/.bashrc && source ~/.bashrc"

