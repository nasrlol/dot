# Environment for every fish (login shells start niri, so GUI apps inherit this).

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER "nvim +Man!"
set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx LANG en_US.UTF-8

# XDG base dirs, and pushing stragglers out of $HOME
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME;   or set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME;  or set -gx XDG_STATE_HOME $HOME/.local/state
set -q XDG_CACHE_HOME;  or set -gx XDG_CACHE_HOME $HOME/.cache

set -gx LESSHISTFILE $XDG_STATE_HOME/less/history
set -gx GOPATH $XDG_DATA_HOME/go
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx NUGET_PACKAGES $XDG_CACHE_HOME/NuGetPackages
set -gx DOTNET_CLI_HOME $XDG_DATA_HOME/dotnet
set -gx _JAVA_OPTIONS -Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java
set -gx PYTHON_HISTORY $XDG_STATE_HOME/python/history
set -gx NODE_REPL_HISTORY $XDG_STATE_HOME/node_repl_history
set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
set -gx GNUPGHOME $XDG_DATA_HOME/gnupg
set -gx XCURSOR_PATH $XDG_DATA_HOME/icons:/usr/share/icons

fish_add_path -g $HOME/.local/bin $CARGO_HOME/bin $GOPATH/bin

# Share the OpenRC user D-Bus session across all login, SSH, and background shells.
if not set -q DBUS_SESSION_BUS_ADDRESS; and set -q XDG_RUNTIME_DIR; and test -S "$XDG_RUNTIME_DIR/bus"
    set -gx DBUS_SESSION_BUS_ADDRESS "unix:path=$XDG_RUNTIME_DIR/bus"
end

# One ssh-agent per login, at a fixed socket so every shell and GUI app finds it.
# Keys are added on first use (AddKeysToAgent in ~/.ssh/config).
if status is-login; and not set -q SSH_AUTH_SOCK
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
    if not test -S $SSH_AUTH_SOCK
        ssh-agent -a $SSH_AUTH_SOCK >/dev/null
    end
end

# Enable full core dumps and memory filtering for debug sessions
ulimit -c unlimited
if test -w /proc/self/coredump_filter
    echo 0x3f > /proc/self/coredump_filter 2>/dev/null
end
