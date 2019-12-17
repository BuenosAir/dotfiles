" Remap the leader key
let mapleader = ','

" Termguicolors for alacrittyk
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Indentation
set expandtab       "Tabs to spaces
set smarttab
set tabstop=4
set softtabstop=4
set linebreak
set autoindent

set backspace=indent,eol,start
                    " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                    "    case-sensitive otherwise
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type

if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if &t_Co > 2 || has("gui_running")
    " switch syntax highlighting on, when the terminal has colors
    syntax on
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'pearofducks/ansible-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/vim-easy-align'
Plug 'OmniSharp/omnisharp-vim'
Plug 'ap/vim-css-color'
Plug 'vim-syntastic/syntastic'
Plug 'w0rp/ale'
Plug 'fatih/vim-go'
Plug 'lervag/vimtex'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-scripts/c.vim'
Plug 'csexton/trailertrash.vim'
Plug 'tpope/vim-fugitive'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'alvan/vim-closetag'
Plug 'mxw/vim-jsx'
Plug 'moll/vim-node'
Plug 'drewtempelmeyer/palenight.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
"
" No mouse
set mouse=

filetype plugin indent on
syntax on

set background=dark
colorscheme palenight
"colorscheme onedark

" History
set history=1000    " much more history than base
set undolevels=1000 " much more undo

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Indentation
set expandtab       "Tabs to spaces
set smarttab
set softtabstop=4
set linebreak
set autoindent

" Menu completion
set wildmenu

" Better indent
vmap > >gv
vmap < <gv

" Set encoding
set encoding=utf-8 nobomb

" Highlight trailing spaces
highlight ExtraWhitespace term=reverse ctermbg=11
au BufNewFile,BufRead * :match ExtraWhitespace /\s\+$/

" Show all kinds of stuff
set ruler           " Show the cursor position
set shortmess=atI   " Don’t show the intro message when starting Vim
set showmode        " Show the current mode
set title           " Show the filename in the window titlebar
set showcmd         " Show the (partial) command as it’s being typed
set lazyredraw      " redraw only when we need to


" Spelling colors
hi clear SpellBad
hi SpellBad cterm=italic,bold,underline ctermfg=208
hi clear SpellCap
hi SpellCap cterm=italic ctermfg=208
hi clear SpellRare
hi SpellRare ctermfg=200

" Don’t add empty newlines at the end of files
set noeol

" jk or kj to quit insert mode
imap jk <Esc>

" Moves between splits the easy way
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" More natural splits
set splitright
set splitbelow
set diffopt+=vertical

" Navigate through tabs / buffers
nnoremap gl    :tabnext<CR>
nnoremap gh    :tabprev<CR>
nnoremap gL    :bnext<CR>
nnoremap gH    :bprev<CR>

" Open a new tab the easy way
nnoremap <leader>t :tabedit<Space>

" Use arrows for resizing windows
map <Left>  <C-W><
map <Right> <C-W>>
map <Up>    <C-W>+
map <Down>  <C-W>-

" autocmd filetype group
augroup filetype_set
    " Clear the autocmd
    autocmd!
    " Markdown filetype
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    " Vagrantfile
    autocmd BufRead,BufNewFile Vagrantfile set filetype=ruby
    " JSON
    autocmd BufRead,BufNewFile *.json set filetype=json syntax=javascript
augroup END

" autocmd paste mode
augroup paste_helper
    " Clear the autocmd
    autocmd!
    " set not paste in normal mode
    autocmd InsertLeave * set nopaste
augroup END

" autocmd spell group
augroup spell_set
    " Clear the autocmd
    autocmd!
    " svn
    autocmd BufNewFile,BufRead svn-commit.tmp setlocal spell
augroup END

	" autocmd vim help
augroup vim_help
    " Clear the autocmd
    autocmd!
    " open vim help in a right split
    au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
augroup END

" autocmd location list
augroup locationlist
    autocmd!
    autocmd QuickFixCmdPost *grep* cwindow
augroup END
"
"Easy regex on visual
vnoremap <leader>r :<C-BS><C-BS><C-BS><C-BS><C-BS>%s/\%V

"Easy fzf
nnoremap <leader>f    :FZF<Space>
nnoremap <leader>a    :FZF /manager<CR>
set rtp+=fzf

"Same cursor than vim
set guicursor=

let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0

nnoremap <leader>scfr :setlocal spell spelllang=fr<CR>
nnoremap <leader>scus :setlocal spell spelllang=en<CR>

" Ale
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_linters = {'go': ['go build', 'gofmt', 'golint', 'gosimple', 'go vet', 'staticcheck'] }
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

"Configure vim for latex
let g:vimtex_view_general_viewer = 'zathura'

" Open nerdtree with ctrl n
map <C-n> :NERDTreeToggle<CR>

" Sudo
nnoremap <leader>sudo :w !sudo tee %

" Enable trailertrash for good
hi UnwantedTrailerTrash guibg=red ctermbg=red
au BufWritePre * :TrailerTrim

" Replace with the first occurence
nnoremap <leader>z 1z=

autocmd BufNewFile,BufRead *.fizz set syntax=sql

" Ansible highlight
let g:ansible_attribute_highlight = "a"

let g:go_fmt_command = "goimports"

let g:closetag_xhtml_filenames = '*.xhtml,*.jsx, App.js'
let g:closetag_filenames = '*.html,*.xhtml,*.phtml, App.js'

" Autocompletion with tab
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Syntastic config
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_auto_jump = 0
