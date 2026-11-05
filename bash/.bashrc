PS1=' nasr :: '

mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/bash"
export HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
export HISTFILESIZE=1000
export HISTSIZE=1000
export PATH="$HOME/.local/bin:$PATH"
