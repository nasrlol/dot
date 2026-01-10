"*****************************************************************************
"                        Vim Configuration File by Nasr
"*****************************************************************************

"-----------------------------------------------------------------------------
" Check and install vim-plug if not already installed
"-----------------------------------------------------------------------------
let vimplug_exists = expand('~/.vim/autoload/plug.vim')
if has('win32') && !has('win64')
  " Check for curl executable on 32-bit Windows
  let curl_exists = expand('C:\Windows\Sysnative\curl.exe')
else
  " Check for curl executable on Unix-like systems or 64-bit Windows
  let curl_exists = expand('curl')
endif

" Define languages and editor type for vim-bootstrap
let g:vim_bootstrap_langs = "c,html,javascript,python"
let g:vim_bootstrap_editor = "vim"

" Install vim-plug if not found
if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr "Curl is required to install vim-plug. Please install curl or vim-plug manually."
    execute "q!"  " Quit Vim if installation is not possible
  endif
  echo "Installing vim-plug..."
  silent exec "!" . curl_exists . " -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  " Automatically install plugins on first run
  autocmd VimEnter * PlugInstall
endif

"-----------------------------------------------------------------------------
" Plugin Management
"-----------------------------------------------------------------------------
" Begin plugin block
call plug#begin(expand('~/.vim/plugged'))

" Plugin List
Plug 'vim-airline/vim-airline'                " Status line enhancement
Plug 'airblade/vim-gitgutter'                 " Git diff in the sign column
Plug 'vim-scripts/grep.vim'                   " Grep integration
Plug 'Yggdroot/indentLine'                    " Display indent guides
Plug 'editor-bootstrap/vim-bootstrap-updater' " Update vim-bootstrap configs
Plug 'jelera/vim-javascript-syntax'           " Enhanced JavaScript syntax
Plug 'davidhalter/jedi-vim'                   " Python auto-completion
Plug 'morhetz/gruvbox'                        " Gruvbox color scheme
Plug 'junegunn/fzf.vim'                       " FZF integration
Plug 'junegunn/fzf'                           " FZF installation

" End plugin block
call plug#end()

" Enable file type-specific plugins and indenting
filetype plugin indent on

"-----------------------------------------------------------------------------
" Basic Settings
"-----------------------------------------------------------------------------
" Encoding settings
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" Backspace behavior
set backspace=indent,eol,start

" Tab and indentation settings
set tabstop=4              " Number of spaces per tab
set softtabstop=0          " Insert spaces when pressing Tab
set shiftwidth=4           " Number of spaces for indentation
set expandtab              " Convert tabs to spaces
set autoindent

" Use system clipboard
set clipboard=unnamedplus

" Wrap settings
set wrap 
set linebreak

" Disable backup files
set nobackup

" Bash-like command completion
set wildmode=longest,list
set wildmenu               " Visual command-line completion menu

" Disable swap files
set noswapfile

" Set leader key to ',' for custom shortcuts
let mapleader = ','

" Enable hidden buffers to keep unsaved files open
set hidden

" Disable compatibility with Vi
set nocompatible

"-----------------------------------------------------------------------------
" Search Settings
"-----------------------------------------------------------------------------
set hlsearch              " Highlight search matches
set incsearch             " Incremental search
set ignorecase            " Ignore case in search
set smartcase             " Override ignorecase if uppercase letters are used

" File format compatibility
set fileformats=unix,dos,mac

"-----------------------------------------------------------------------------
" Shell Configuration
"-----------------------------------------------------------------------------
if exists('$SHELL')
  set shell=$SHELL
else
  set shell=/bin/sh
endif

"-----------------------------------------------------------------------------
" Session Management
"-----------------------------------------------------------------------------
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "yes"
let g:session_command_aliases = 1

"-----------------------------------------------------------------------------
" Visual Settings
"-----------------------------------------------------------------------------
syntax enable              " Enable syntax highlighting
set ruler                  " Show cursor position in the status line
set number                 " Show absolute line numbers
set relativenumber         " Show relative line numbers
set cursorline             " Highlight the current line

" Status line settings
set laststatus=2           " Always show the status line
set title                  " Set terminal window title
set titlestring=%F         " Show the current file name in the title

" Indentation line plugin settings
let g:indentLine_enabled = 1
let g:indentLine_char = '┆'
let g:indentLine_faster = 1

"-----------------------------------------------------------------------------
" Color Scheme
"-----------------------------------------------------------------------------
colorscheme gruvbox        " Use Gruvbox color scheme
set background=dark        " Use dark background

"-----------------------------------------------------------------------------
" Key Mappings
"-----------------------------------------------------------------------------
" Search navigation: center the match after jumping
nnoremap n nzzzv
nnoremap N Nzzzv

" Open terminal in a split
nnoremap <silent> <leader>sh :terminal<CR>

"-----------------------------------------------------------------------------
" grep.vim Configuration
"-----------------------------------------------------------------------------
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git,node_modules'

"-----------------------------------------------------------------------------
" jedi-vim Configuration
"-----------------------------------------------------------------------------
autocmd FileType python call jedi#init_python()

"-----------------------------------------------------------------------------
" Miscellaneous
"-----------------------------------------------------------------------------
" Disable blinking cursor
set gcr=a:blinkon0

"-----------------------------------------------------------------------------
