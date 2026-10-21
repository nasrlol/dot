function checkpoint --description "Stage everything and commit: checkpoint [message]"
    set -l msg checkpoint
    test (count $argv) -gt 0; and set msg "$argv"
    git add -A; or return
    git diff --cached --quiet; and begin
        echo "checkpoint: nothing to commit" >&2
        return 1
    end
    git commit -q -m "$msg"
end
