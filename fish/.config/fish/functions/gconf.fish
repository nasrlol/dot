function gconf --description 'Pick a Ghostty config snippet (font, leading, ...) with fzf'
    set -l dir ~/.config/ghostty
    # e.g. "font/iosevka": rewrite "config-file = font/..." in config, then
    # tell the running Ghostty to reload (SIGUSR2).
    set -l pick (fd --type f --exclude config --exclude colors --exclude colors.tmpl \
            --exclude 'hosts' --exclude 'shader' --exclude host.conf --base-directory $dir \
        | fzf --preview "cat $dir/{}" --delimiter=/)
    or return
    set -l group (string split -m1 / $pick)[1]
    set -l name (string split -m1 / $pick)[2]
    sed -i "s:^\(config-file = $group\)/.*:\1/$name:" $dir/config
    pkill -USR2 -x ghostty
end
