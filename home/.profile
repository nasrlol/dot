# POSIX login environment for sh/bash. fish (the login shell) uses
# ~/.config/fish/conf.d/00-env.fish instead; keep the two in sync.
export EDITOR=nvim VISUAL=nvim
export XDG_CONFIG_HOME="$HOME/.config" XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state" XDG_CACHE_HOME="$HOME/.cache"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH" ;; esac
export PATH
