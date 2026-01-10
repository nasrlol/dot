# ============================================================================
# FISH SHELL CONFIGURATION
# ============================================================================

# ----------------------------------------------------------------------------
# Environment Variables
# ----------------------------------------------------------------------------
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER "nvim +Man!"

# Language and locale
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Path configuration
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/odin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/.local/share/JetBrains/Toolbox/scripts $PATH

# Go configuration
set -gx GOROOT /usr/local/go
set -gx GOPATH $HOME/go
set -gx PATH $GOROOT/bin $PATH
set -gx PATH $GOPATH/bin $PATH

# .NET configuration
set -gx DOTNET_ROOT $HOME/.dotnet
set -gx PATH $DOTNET_ROOT $PATH

# Node.js configuration (if using nvm or similar)
set -gx PATH $HOME/.npm-global/bin $PATH

set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -Ux GDK_BACKEND x11

# ----------------------------------------------------------------------------
# Key Bindings
# ----------------------------------------------------------------------------
set -g fish_key_bindings fish_vi_key_bindings

# Custom key bindings (set after vi bindings are loaded)
function fish_user_key_bindings
    bind -M insert \cf accept-autosuggestion
    bind -M insert \ce edit_command_buffer
end

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------

# Navigation
alias cd "z"
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."

# Editor shortcuts
alias vim "nvim"
alias vi "nvim"
alias v "nvim"

# Enhanced ls with exa
alias ls "exa --group-directories-first"
alias ll "exa -l --group-directories-first --git"
alias la "exa -la --group-directories-first --git"
alias lt "exa --tree --level=2 --group-directories-first"
alias lta "exa --tree --level=2 --group-directories-first -a"

# Modern replacements
alias grep "rg"
alias cat "bat"
alias find "fd"
alias ps "procs"
alias du "dust"
alias df "duf"

# Git shortcuts
alias g "git"
alias gs "git status"
alias ga "git add"
alias gc "git commit"
alias gp "git push"
alias gl "git pull"
alias gd "git diff"
alias gco "git checkout"
alias gb "git branch"
alias glog "git log --oneline --graph --decorate"
alias checkpoint "git add . && git commit -m 'checkpoint' && git push"

# Tmux shortcuts
alias attach "tmux attach-session -t"
alias new "tmux new-session -s"
alias list "tmux list-sessions"
alias ta "tmux attach"
alias tls "tmux list-sessions"

# Utility aliases
alias copypath "pwd | xsel --clipboard"
alias copy "xsel --clipboard"
alias t "todocli"
alias battery "cat /sys/class/power_supply/macsmc-battery/capacity"
alias ports "ss -tulpn"
alias weather "curl wttr.in"
alias myip "curl ifconfig.me"
alias speedtest "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"

# System monitoring
alias mem "free -h"
alias cpu "lscpu | sed -n '1,12p'"
alias top "btop"

# Safety nets
alias rm "rm -i"
alias cp "cp -i"
alias mv "mv -i"

# Quick edits
alias fishconfig "nvim ~/.config/fish/config.fish"
alias reload "source ~/.config/fish/config.fish"

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------

# Fuzzy file editor with git awareness
function edit
    if not git rev-parse --git-dir >/dev/null 2>&1
        set file (fzf --preview 'bat --style=full --color=always {} 2>/dev/null' \
                      --preview-window=right:60%:wrap)
    else
        set file (git ls-files | fzf --preview 'bat -n --style=full --color=always {} 2>/dev/null' \
                                      --preview-window=right:60%:wrap)
    end
    if test -n "$file"
        nvim "$file"
    end
end

# Edit config files
function config
    set file (git -C ~/.config ls-files | fzf \
        --preview 'bat -n --style=full --color=always ~/.config/{} 2>/dev/null' \
        --preview-window=right:60%:wrap)
    if test -n "$file"
        nvim ~/.config/"$file"
    end
end

# Jump to any file location
function goto
    set file (fd --type f --hidden --follow \
        --exclude .git \
        --exclude node_modules \
        --exclude target \
        --exclude build \
        . ~ \
        | fzf --preview 'bat -n --style=full --color=always {} 2>/dev/null' \
              --preview-window=right:60%:wrap)
    if test -n "$file"
        cd (dirname "$file")
    end
end

# Jump to git root
function groot
    if git rev-parse --show-toplevel >/dev/null 2>&1
        cd (git rev-parse --show-toplevel)
    else
        echo "Not in a git repository"
        return 1
    end
end

# Create directory and cd into it
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# Extract any archive
function extract
    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar x $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted via extract()"
                return 1
        end
    else
        echo "'$argv[1]' is not a valid file"
        return 1
    end
end

# Quick git commit with message
function gcm
    git commit -m "$argv"
end

# Git add all and commit
function gac
    git add .
    git commit -m "$argv"
end

# Create new git branch and switch to it
function gnb
    git checkout -b "$argv"
end

# Find process by name
function psg
    ps aux | grep -v grep | grep -i -e VSZ -e "$argv"
end

# Kill process by name
function killp
    set pid (psg $argv | awk '{print $2}')
    if test -n "$pid"
        echo "Killing process $pid"
        kill -9 $pid
    else
        echo "No process found matching: $argv"
    end
end

# Quick backup
function backup
    set filename (basename "$argv")
    set timestamp (date +%Y%m%d_%H%M%S)
    cp -r "$argv" "$argv.backup_$timestamp"
    echo "Backed up to: $argv.backup_$timestamp"
end

# Quick note taking
function note
    set note_file ~/notes/(date +%Y-%m-%d).md
    if not test -e $note_file
        echo "# Notes for "(date +%Y-%m-%d) > $note_file
        echo "" >> $note_file
    end
    echo "- ["(date +%H:%M)"] $argv" >> $note_file
    echo "Note added to $note_file"
end

# Colored man pages
function man
    set -x LESS_TERMCAP_mb (printf "\033[01;31m")
    set -x LESS_TERMCAP_md (printf "\033[01;31m")
    set -x LESS_TERMCAP_me (printf "\033[0m")
    set -x LESS_TERMCAP_se (printf "\033[0m")
    set -x LESS_TERMCAP_so (printf "\033[01;44;33m")
    set -x LESS_TERMCAP_ue (printf "\033[0m")
    set -x LESS_TERMCAP_us (printf "\033[01;32m")
    command man $argv
end

# ----------------------------------------------------------------------------
# SSH Agent
# ----------------------------------------------------------------------------
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) > /dev/null
end

# ----------------------------------------------------------------------------
# Startup Commands
# ----------------------------------------------------------------------------

# Disable greeting
set fish_greeting

# Initialize zoxide (better cd)
if type -q zoxide
    zoxide init fish | source
end

# Initialize starship prompt (if installed)
if type -q starship
    starship init fish | source
end

# Initialize direnv (if installed)
if type -q direnv
    direnv hook fish | source
end

# Initialize fzf key bindings (if installed)
if type -q fzf
    fzf --fish | source
end

# ----------------------------------------------------------------------------
# Colors and Styling
# ----------------------------------------------------------------------------

# Syntax highlighting colors
set -g fish_color_normal normal
set -g fish_color_command blue
set -g fish_color_quote yellow
set -g fish_color_redirection cyan
set -g fish_color_end green
set -g fish_color_error red
set -g fish_color_param cyan
set -g fish_color_comment brblack
set -g fish_color_match --background=brblue
set -g fish_color_selection white --bold --background=brblack
set -g fish_color_search_match bryellow --background=brblack
set -g fish_color_operator brcyan
set -g fish_color_escape brcyan
set -g fish_color_autosuggestion brblack

# Pager colors
set -g fish_pager_color_prefix white --bold --underline
set -g fish_pager_color_completion normal
set -g fish_pager_color_description yellow
set -g fish_pager_color_progress brwhite --background=cyan

# ----------------------------------------------------------------------------
# Custom Prompt (if not using starship)
# ----------------------------------------------------------------------------

# Uncomment if you want a custom prompt instead of starship
# function fish_prompt
#     set -l last_status $status
#     
#     # User@Host
#     set_color brblack
#     echo -n "["
#     set_color blue
#     echo -n $USER
#     set_color brblack
#     echo -n "@"
#     set_color cyan
#     echo -n (prompt_hostname)
#     set_color brblack
#     echo -n "] "
#     
#     # Current directory
#     set_color magenta
#     echo -n (prompt_pwd)
#     
#     # Git status
#     if git rev-parse --git-dir >/dev/null 2>&1
#         set_color brblack
#         echo -n " on "
#         set_color yellow
#         echo -n (git branch --show-current 2>/dev/null)
#         
#         if not git diff-index --quiet HEAD -- >/dev/null 2>&1
#             set_color red
#             echo -n "*"
#         end
#     end
#     
#     # Status indicator
#     echo
#     if test $last_status -ne 0
#         set_color red
#         echo -n "✗ "
#     else
#         set_color green
#         echo -n "❯ "
#     end
#     set_color normal
# end
