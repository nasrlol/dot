function setremote --description 'Point origin at git@git.nsrddyn.com:<name>'
    if test (count $argv) -ne 1
        echo "usage: setremote <name>"
        return 1
    end
    set -l url git@git.nsrddyn.com:$argv[1]
    git remote set-url origin $url 2>/dev/null; or git remote add origin $url
    and echo "origin -> $url"
end
