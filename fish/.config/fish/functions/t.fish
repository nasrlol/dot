# t        inside tmux: session/project picker; outside: attach-or-create a
#          session named after the current directory
# t NAME   attach-or-create session NAME
function t
    if test (count $argv) -gt 0
        set name $argv[1]
    else if set -q TMUX
        tmux-session-switcher
        return
    else
        set name (basename $PWD | string replace -a -r '[.:]' _)
    end

    if set -q TMUX
        tmux has-session -t "=$name" 2>/dev/null; or tmux new-session -d -s $name
        tmux switch-client -t "=$name"
    else
        tmux new-session -A -s $name
    end
end
