function bl --description "Run project build.sh and log to file"
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$root" -a -f "$root/build.sh"
        pushd "$root" >/dev/null
        ./build.sh $argv > log.txt 2>&1
        set -l st $status
        popd >/dev/null
        return $st
    else if test -f ./build.sh
        ./build.sh $argv > log.txt 2>&1
    else
        echo "bl: no build.sh found in current or git root" >&2
        return 1
    end
end
