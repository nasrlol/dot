function memory --description "Watch a process's memory: memory <pid|name>"
    set -l pid $argv[1]
    if test -z "$pid"
        echo "usage: memory <pid|process-name>" >&2
        return 1
    end
    if not string match -qr '^\d+$' -- $pid
        set pid (pgrep -n -- $pid)
        or begin
            echo "memory: no process named $argv[1]" >&2
            return 1
        end
    end
    while test -d /proc/$pid
        grep -E 'VmRSS|VmSize|VmPeak' /proc/$pid/status
        sleep 1
    end
end
