function checkpoint-all --description "checkpoint every dirty repo in ~/dotfiles, ~/dev and /opt/4coder"
    set -l repos ~/dotfiles /opt/4coder
    for d in ~/dev/*/
        test -e $d/.git; and set -a repos (string trim -r -c / -- $d)
    end

    set -l failed
    for repo in $repos
        test -n "$(git -C $repo status --porcelain 2>/dev/null)"; or continue
        echo $repo
        fish -c 'cd $argv[1]; and checkpoint $argv[2..]' $repo $argv
        or set -a failed $repo
    end
    if set -q failed[1]
        echo "checkpoint-all: failed in $failed" >&2
        return 1
    end
end
