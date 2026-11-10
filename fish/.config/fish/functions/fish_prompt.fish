set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_char_dirtystate '*'
set -g __fish_git_prompt_char_stagedstate '+'
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_char_upstream_ahead '↑'
set -g __fish_git_prompt_char_upstream_behind '↓'
set -g __fish_git_prompt_char_upstream_prefix ' '
set -g __fish_git_prompt_color_branch 8b7355
set -g __fish_git_prompt_color_dirtystate b86030
set -g __fish_git_prompt_color_stagedstate d4a030
set -g __fish_git_prompt_color_untrackedfiles 6b5a45
set -g __fish_git_prompt_color_upstream 9b7040

function fish_prompt
    set -l last $status
    set -l took $CMD_DURATION

    # user@host only over ssh
    set -q SSH_TTY; and echo -n (set_color 6b5a45)$USER@(prompt_hostname)' '

    echo -n (set_color d48b30)(prompt_pwd --dir-length=1 --full-length-dirs=1)
    fish_git_prompt ' %s'

    # last command took > 3s
    test $took -gt 3000; and echo -n (set_color 5a4a38)' '(math -s1 $took / 1000)s

    # prompt char: red on failure, swaps in vi normal mode
    set -l char '❯'
    test "$fish_bind_mode" != insert; and set char '❮'
    if test $last -ne 0
        echo -n ' '(set_color dc4a20)$last
        set_color dc4a20
    else
        set_color c84820
    end
    echo -n " $char "(set_color normal)
end

# repaint when switching vi modes so the prompt char updates
function __prompt_repaint_on_mode --on-variable fish_bind_mode
    commandline -f repaint
end
