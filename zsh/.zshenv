export XDG_RUNTIME_DIR=/run/user/$(id -u)
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CURRENT_DESKTOP=niri

mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_STATE_HOME/less" "$XDG_CACHE_HOME/zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export HISTSIZE=1000
export SAVEHIST=10000
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
unset DBUS_SESSION_BUS_ADDRESS
