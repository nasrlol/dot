# Environment
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx QT_SCALE_FACTOR 1.5
fish_add_path -g $HOME/.local/bin

if status is-interactive
    # zsh printed no greeting
    set -g fish_greeting

    # Aliases
    alias vim nvim
    alias ll "ls -hal"
    alias checkpoint "git add . && git commit -m 'checkpoint' && git push"
    alias attach "tmux attach-session -t"
    alias new "tmux new-session -s"
    alias list "tmux list-sessions"
    alias build ./build.sh
    alias bl "./build.sh > log.txt 2>&1"
    abbr -a ... "cd ../.."
    abbr -a .... "cd ../../.."

    # gentoo start
    alias start "dbus-run-session niri"

    # Vi mode (bindkey -v)
    fish_vi_key_bindings
end

# Custom key bindings; fish runs this after loading vi bindings
function fish_user_key_bindings
    bind -M insert ctrl-r history-pager
    bind -M insert ctrl-f accept-autosuggestion
    bind -M insert ctrl-e edit_command_buffer
    bind -M default ctrl-e edit_command_buffer
end

function memory
    while true
        grep -E "VmRSS|VmSize|VmPeak" /proc/15082/status
        sleep 1
    end
end

# PROMPT='%n %~ $ '
function fish_prompt
    echo -n "$USER "(prompt_pwd --dir-length=0)' $ '
end

# zsh showed no vi mode indicator
function fish_mode_prompt
end
