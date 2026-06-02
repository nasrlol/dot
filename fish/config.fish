# Editors
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER cat
set -gx MANPAGER "nvim +Man!"

# Locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Build consolidated PATH
set -gx PATH $HOME/.local/bin $HOME/odin $HOME/.cargo/bin $PATH
set -gx PATH "$HOME/.local/share/JetBrains/Toolbox/scripts" $PATH

# Go
# set -gx GOROOT /usr/local/go
# set -gx GOPATH $HOME/go
# set -gx PATH $GOROOT/bin $GOPATH/bin /usr/local/bin $PATH

set -gx PATH $HOME/third_party/go-versions/go1.26.1/bin $PATH

# Java
set -gx JAVA_HOME "$HOME/.jdks/openjdk-25.0.1"
set -gx PATH $JAVA_HOME/bin $PATH
set -gx CLASSPATH "/usr/share/java/easymock.jar:$CLASSPATH"
set -gx PATH "$PATH:/opt/clion/bin"

# .NET
set -gx DOTNET_ROOT $HOME/.dotnet
set -gx PATH "$DOTNET_ROOT:$PATH"

# FZF
set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Colors
set -gx ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE 'fg=8'
set -gx ls_colors "di=37:fi=0:ln=37;2:ex=37;1:*.png=37;2:*.jpg=37;2:*.sh=37;2"

# History settings (fish handles history differently)
set -gx HISTFILE ~/.fish_history
set -gx HISTSIZE 10000
set -gx SAVEHIST 10000

# Vi key bindings
fish_vi_key_bindings

# Custom key bindings
bind -M insert \cf forward-bigword
bind -M insert \ce edit_command_buffer

# Enable command line editing with external editor
function edit_command_buffer
    set -l temp_file (mktemp)
    echo $BUFFER > $temp_file
    $EDITOR $temp_file
    set -l BUFFER (cat $temp_file)
    rm $temp_file
end

# Git info in prompt (Fish has built-in git support)
function fish_prompt
    set -l status_color (set_color green)
    if test $status -ne 0
        set status_color (set_color red)
    end

    set -l git_info ""
    if git rev-parse --git-dir > /dev/null 2>&1
        set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
        set -l status_flags ""

        if not git diff-index --quiet HEAD --
            set status_flags "*"
        end

        if git diff-index --cached --quiet HEAD --
        else
            set status_flags "$status_flags+"
        end

        if test -n "$branch"
            set git_info (set_color yellow)" [$branch"(set_color red)"$status_flags"(set_color yellow)"]"(set_color normal)
        end
    end
end

# Navigation (using zoxide)
alias  cd z
alias  .. "cd .."
alias  ... "cd ../.."
alias  .... "cd ../../.."

# i find this a hard word to type
abbr -a lz lazygit

abbr -a ss "exec dbus-run-session startx"

# System
# abbr -a gentoo "sudo systemd-nspawn -D /mnt/gentoo --bind /boot"
abbr -a dls "docker container ls -a"
abbr -a net "ping 1.1.1.1"
abbr -a ports "ss -tulpn"
abbr -a mem "free -h"
abbr -a cpu "lscpu | sed -n '1,12p'"
abbr -a top btop

# Docker
abbr -a dstop "docker ps -q | xargs -r docker stop"
abbr -a drm "docker ps -a -q | xargs -r docker rm -f"
abbr -a drmi "docker images -q | xargs -r docker rmi -f"
abbr -a drnet "docker network ls -q | xargs -r docker network rm"
abbr -a drv "docker volume ls -q | xargs -r docker volume rm"
abbr -a dclean "dstop && drm && drmi && drnet && drv"

# Editor shortcuts
abbr -a vim nvim
abbr -a vi nvim
abbr -a v nvim

# Web server
abbr -a server "python -m http.server 8000"

# Modern replacements (safety nets)
# abbr -a grep rg
# abbr -a cat bat
# abbr -a find fd
abbr -a ps procs
abbr -a du dust
abbr -a df duf
abbr -a rm rm
abbr -a cp cp
abbr -a mv mv

# Directory listing (eza)
alias  l "eza -l --group"
alias  ls "eza --group --group-directories-first"
alias  ll "eza -l --group --group-directories-first --git"
alias  la "eza -la --group --group-directories-first --git"
alias  lt "eza --tree --level=2 --group --group-directories-first"
alias  lta "eza --tree --level=2 --group --group-directories-first -a"

# Git shortcuts
abbr -a g git
abbr -a gs "git status"
abbr -a ga "git add"
abbr -a gc "git commit"
abbr -a gp "git push"
abbr -a gl "git pull"
abbr -a gd "git diff"
abbr -a gco "git checkout"
abbr -a gb "git branch"
abbr -a glog "git log --oneline --graph --decorate"
abbr -a checkpoint "git add . && git commit -m 'checkpoint' && git push"

# Tmux
abbr -a attach "tmux attach-session -t"
abbr -a new "tmux new-session -s"
abbr -a list "tmux list-sessions"
abbr -a ta "tmux attach"
abbr -a tls "tmux list-sessions"

# Utilities
abbr -a copypath "pwd | xsel --clipboard"
abbr -a copy "xsel --clipboard"
abbr -a t todocli
abbr -a battery "cat /sys/class/power_supply/macsmc-battery/capacity"
abbr -a weather "curl wttr.in"
abbr -a myip "curl ifconfig.me"
abbr -a speedtest "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"
abbr -a kbbr "echo 0 | sudo tee /sys/class/leds/kbd_backlight/brightness"

# Config
abbr -a zshconfig "nvim ~/.config/fish/config.fish"
abbr -a reload "source ~/.config/fish/config.fish"

# Cpupower
abbr -a powersave "sudo cpupower frequency-set -g powersave"
abbr -a performance "sudo cpupower frequency-set -g performance"

# Fuzzy file editor with git awareness
function edit
    set -l file
    if not git rev-parse --git-dir > /dev/null 2>&1
        set file (fzf --preview 'bat --style=full --color=always {} 2>/dev/null' \
                       --preview-window=right:60%:wrap)
    else
        set file (git ls-files | fzf --preview 'bat -n --style=full --color=always {} 2>/dev/null' \
                                         --preview-window=right:60%:wrap)
    end
    test -n "$file" && nvim "$file"
end

# Config file editor
function config
    set -l file (git -C ~/.config ls-files | fzf \
        --preview "bat -n --style=full --color=always \$HOME/.config/{} 2>/dev/null" \
        --preview-window=right:60%:wrap)

    test -n "$file" && nvim ~/.config/"$file"
end

# Open file/directory
function open
    if test (count $argv) -eq 0
        xdg-open . > /dev/null 2>&1
    else
        xdg-open $argv > /dev/null 2>&1
    end
end

function goto
    set -l file
    set file (fd --type f --hidden --follow --exclude node_modules .git | \
              fzf --preview 'bat -n --style=full --color=always {} 2>/dev/null' \
                  --preview-window=right:60%:wrap)

    test -z "$file" && return
    cd (dirname "$file")
end

# Jump to project and open in editor
function wo
    set -l dir (zoxide query -l | fzf --height 40% --reverse --header="Jump to Project")
    if test -n "$dir"
        cd "$dir"
        test -n "$TMUX" && tmux rename-window (basename "$dir")
        nvim .
    end
end

# Install package with fuzzy search
function install
    set -l pkg (dnf search all 2>/dev/null \
        | awk '{print $1}' \
        | sed 's/\.$//' \
        | sort -u \
        | fzf --prompt="dnf install > " \
              --preview 'dnf info {} 2>/dev/null' \
              --preview-window=right:60%:wrap)
    test -n "$pkg" && sudo dnf install "$pkg"
end

function memleak
    while true
        grep -E "VmRSS|VmSize|VmPeak" /proc/70409/status
        sleep 1
    end
end

# Git utilities
function groot
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -n "$root"
        cd "$root"
    else
        echo "Not in a git repository"
        return 1
    end
end

function screenrec
    if pgrep ffmpeg > /dev/null
        pkill -SIGINT ffmpeg
    else
        set -l timestamp (date +%Y-%m-%d-%H%M%S)
        ffmpeg -f x11grab -r 15 -s 2560x1664 -i :0.0 \
            -c:v libx264 -preset ultrafast \
            -vf scale=1280:832 \
            -crf 32 \
            -maxrate 400k -bufsize 800k \
            "/home/nasr/videos/$timestamp.mp4" &
    end
end

function gnb
    git checkout -b $argv[1]
end

function gcm
    git commit -m $argv
end

function gac
    git add .
    git commit -m $argv
end

function gitls
    git rev-parse --is-inside-work-tree > /dev/null 2>&1 || return 1
    git ls-files -z | xargs -0 eza --color=always --icons --group-directories-first
end

# Directory utilities
function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

# Extract archives
function extract
    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.bz2' '*.tbz2'
                tar xjf $argv[1]
            case '*.tar.gz' '*.tgz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar x $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted via extract()"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

# Process utilities
function psg
    ps aux | grep -v grep | grep -i -e VSZ -e $argv
end

function killp
    set -l pid (psg $argv[1] | awk '{print $2}')
    if test -n "$pid"
        echo "Killing process $pid"
        kill -9 $pid
    else
        echo "No process found matching: $argv[1]"
    end
end

# Utilities
function backup
    set -l filename (basename $argv[1])
    set -l timestamp (date +%Y%m%d_%H%M%S)
    cp -r $argv[1] "$argv[1].backup_$timestamp"
    echo "Backed up to: $argv[1].backup_$timestamp"
end

function note
    set -l note_file ~/notes/(date +%Y-%m-%d).md
    if not test -e "$note_file"
        echo "# Notes for $(date +%Y-%m-%d)" > "$note_file"
        echo "" >> "$note_file"
    end
    echo "- [$(date +%H:%M)] $argv" >> "$note_file"
    echo "Note added to $note_file"
end

# Colored man pages
function man
    env \
    LESS_TERMCAP_mb="\033[01;31m" \
    LESS_TERMCAP_md="\033[01;31m" \
    LESS_TERMCAP_me="\033[0m" \
    LESS_TERMCAP_se="\033[0m" \
    LESS_TERMCAP_so="\033[01;44;33m" \
    LESS_TERMCAP_ue="\033[0m" \
    LESS_TERMCAP_us="\033[01;32m" \
    /usr/bin/man $argv
end

# SSH Agent
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) > /dev/null
end

# Initialize zoxide (better cd)
if command -v zoxide &> /dev/null
    zoxide init fish | source
end

# Initialize direnv (directory-specific env)
if command -v direnv &> /dev/null
    direnv hook fish | source
end

# Initialize fzf key bindings (fish handles this natively)
if command -v fzf &> /dev/null
    fzf --fish | source
end
