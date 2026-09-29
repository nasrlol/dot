# Generated from colors.fish.tmpl by theme/gen. Do not edit colors.fish.
status is-interactive; or return

set -g fish_color_normal c4a882
set -g fish_color_command d48b30
set -g fish_color_keyword d48b30
set -g fish_color_quote b86030
set -g fish_color_redirection 9b7040
set -g fish_color_end 8b7355
set -g fish_color_error dc4a20
set -g fish_color_param c4a882
set -g fish_color_option b87040
set -g fish_color_comment 6b5a45
set -g fish_color_operator d4a030
set -g fish_color_escape c05020
set -g fish_color_autosuggestion 5a4a38
set -g fish_color_valid_path --underline
set -g fish_color_search_match --background=3d2b1a
set -g fish_color_selection --background=3a0a00
set -g fish_pager_color_prefix d48b30 --bold
set -g fish_pager_color_completion c4a882
set -g fish_pager_color_description 8b7355
set -g fish_pager_color_progress 8b7355
set -g fish_pager_color_selected_background --background=1f1610

set -gx FZF_DEFAULT_OPTS "--height=40% --layout=reverse --border=none --info=inline-right \
--color=fg:#c4a882,bg:-1,hl:#d48b30,fg+:#d9c6a5,bg+:#1f1610,hl+:#f0a030 \
--color=info:#8b7355,prompt:#c84820,pointer:#c84820,marker:#d48b30,spinner:#8b7355,header:#6b5a45,gutter:-1"
