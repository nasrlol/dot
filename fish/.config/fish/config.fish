# One shared ssh-agent per login, on a fixed socket (niri/lazygit inherit it)
set -q XDG_RUNTIME_DIR; or set XDG_RUNTIME_DIR /tmp
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
ssh-add -l >/dev/null 2>&1
if test $status -eq 2
    rm -f $SSH_AUTH_SOCK
    ssh-agent -a $SSH_AUTH_SOCK >/dev/null
end

# GUI passphrase prompt when there's no TTY (e.g. lazygit commit signing)
if test -x /usr/bin/lxqt-openssh-askpass
    set -gx SSH_ASKPASS /usr/bin/lxqt-openssh-askpass
end

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

    alias start "dbus-run-session niri --session"
    alias datamgmt "rlwrap sqlplus elmorabita/ora@orcl"

    fish_vi_key_bindings
    set -g fish_cursor_default block
    set -g fish_cursor_insert block
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual block
end

function fish_user_key_bindings
    bind -M insert ctrl-r history-pager
    bind -M insert ctrl-f accept-autosuggestion
    bind -M insert ctrl-e edit_command_buffer
    bind -M default ctrl-e edit_command_buffer
end

function fish_mode_prompt
end

test -f $__fish_config_dir/local.fish; and source $__fish_config_dir/local.fish
