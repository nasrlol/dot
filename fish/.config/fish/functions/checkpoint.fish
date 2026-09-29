function checkpoint --description "Review, stage and commit with a real message: checkpoint <message>"
    if test (count $argv) -eq 0
        echo "usage: checkpoint <commit message>" >&2
        return 1
    end
    git add -p; or return
    git diff --cached --quiet; and begin
        echo "checkpoint: nothing staged" >&2
        return 1
    end
    git commit -m "$argv"
end
