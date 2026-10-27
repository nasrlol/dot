function build --description "Run project build.sh from any subdirectory"
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$root" -a -f "$root/build.sh"
        pushd "$root" >/dev/null
        ./build.sh $argv
        set -l st $status
        popd >/dev/null
        return $st
    else if test -f ./build.sh
        ./build.sh $argv
    else
        echo "build: no build.sh found in current or git root" >&2
        return 1
    end
end
