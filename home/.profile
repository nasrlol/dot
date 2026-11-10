# POSIX login environment for sh/bash. fish (the login shell) uses
# ~/.config/fish/conf.d/00-env.fish instead; keep the two in sync.
export EDITOR=nvim VISUAL=nvim
export XDG_CONFIG_HOME="$HOME/.config" XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state" XDG_CACHE_HOME="$HOME/.cache"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export QT_QPA_PLATFORM="wayland;xcb"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH" ;; esac
case ":$PATH:" in *":$XDG_DATA_HOME/cargo/bin:"*) ;; *) PATH="$XDG_DATA_HOME/cargo/bin:$PATH" ;; esac
case ":$PATH:" in *":$XDG_DATA_HOME/go/bin:"*) ;; *) PATH="$XDG_DATA_HOME/go/bin:$PATH" ;; esac
export PATH
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] && [ -S "${XDG_RUNTIME_DIR:-/run/user/1000}/bus" ]; then
	export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR:-/run/user/1000}/bus"
fi
ulimit -c unlimited 2>/dev/null || true
[ -w /proc/self/coredump_filter ] && echo 0x3f > /proc/self/coredump_filter 2>/dev/null || true
