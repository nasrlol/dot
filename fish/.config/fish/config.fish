if status is-interactive
    set -g fish_greeting

    alias vim nvim
    alias ll "ls -hal --color=auto"
    alias attach "tmux attach-session -t"
    alias new "tmux new-session -s"
    alias list "tmux list-sessions"
    alias build ./build.sh
    alias bl "./build.sh > log.txt 2>&1"
    alias dots "cd ~/dotfiles"
    abbr -a ... "cd ../.."
    abbr -a .... "cd ../../.."

    abbr -a g git
    abbr -a gs "git status -sb"
    abbr -a gd "git diff"
    abbr -a gds "git diff --staged"
    abbr -a ga "git add -p"
    abbr -a gc "git commit"
    abbr -a gl "git lg"
    abbr -a gp "git push"

    alias start "dbus-run-session niri"
    alias datamgmt "rlwrap sqlplus elmorabita/ora@orcl"

    fish_vi_key_bindings
end

function fish_user_key_bindings
    bind -M insert ctrl-r history-pager
    bind -M insert ctrl-f accept-autosuggestion
    bind -M insert ctrl-e edit_command_buffer
    bind -M default ctrl-e edit_command_buffer
end

function fish_prompt
    echo -n "$USER "(prompt_pwd --dir-length=0)' $ '
end

function fish_mode_prompt
end

test -f $__fish_config_dir/local.fish; and source $__fish_config_dir/local.fish
