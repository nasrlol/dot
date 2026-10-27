function 4ed --description "Launch 4coder detached; `4ed <dir>` opens in that directory"
    # no args: current dir; one dir arg: that dir (session/project load from there); otherwise files
    set -l dir $PWD
    set -l files $argv
    if test (count $argv) -eq 1; and test -d $argv[1]
        set dir (path resolve $argv[1])
        set files
    end
    setsid -f env -C $dir /opt/4coder/build/4ed $files >/dev/null 2>&1 </dev/null
end
