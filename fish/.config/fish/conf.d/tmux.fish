# Report the last command's exit status to tmux as the pane option
# @last_status, so the status line can flag windows whose last command failed.
# Ctrl-C (130) counts as success: interrupting something isn't a failure.
status is-interactive; and set -q TMUX; or return

function __tmux_last_status --on-event fish_postexec
    set -l s $status
    test $s -eq 130; and set s 0
    # Only call tmux when the value changes; most commands succeed.
    test "$s" = "$__tmux_last_status"; and return
    set -g __tmux_last_status $s
    tmux set -p -t $TMUX_PANE @last_status $s 2>/dev/null
end
