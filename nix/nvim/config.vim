set nocompatible

"Standard vimrc stuff
"-------------------------
filetype plugin indent on
set backspace=indent,eol,start
set dir=~/.vim/.swp//
set encoding=utf-8
set expandtab
set exrc
set history=50
set hlsearch
set incsearch
set laststatus=2
set nocompatible
set number
set ruler
set shiftwidth=2
set showcmd
set showmatch
set autoindent
set nocindent
set smartindent
set softtabstop=2
set t_Co=256
set ts=2
"set lazyredraw
"set ttyfast
syntax enable

"Get rid of annoyances
set noswapfile
set nobackup
set nowritebackup

"Convenience
"-------------------------
"Make ";" synonymous with ":" to enter commands
nmap ; :

"C-x as a shortcut for exiting Goyo, save the file and exit Vim altogether
:map <C-X> <ESC>:x<CR>:x<CR>

"Mouse
"-------------------------
set mouse=a
if !has('nvim')
  set ttymouse=sgr
endif

"Escape
"-------------------------
if has('nvim')
  set ttimeoutlen=10
endif

"Colorscheme
"-------------------------
set background=dark
"let base16colorspace=256
"colorscheme base16-mexico-light
colorscheme PaperColor
"Adjust theme search colors
hi Search ctermbg=250 ctermfg=240
hi Comment ctermfg=245

"Clipboard (C-c / C-v)
"-------------------------
if has("xterm_clipboard")
  vnoremap <C-c> "+y
  inoremap <C-v> <Esc>"+p i
elseif executable('xclip')
  vnoremap <C-c> :!xclip -f -sel clip <CR>
  inoremap <C-v> <Esc>:r!xclip -o -sel clip <CR>
endif

"NERDTree
"-------------------------
map <leader>\ :NERDTreeToggle<CR>
let NERDTreeIgnore = [ '\.js_dyn_o', '\.js_hi', '\.js_o', '\.js_dyn_hi', '\.dyn_hi', '\.dyn_o', '\.hi', '\.o', '\.p_hi', '\.p_o' ]
"Automatically close if NERDTree is the only buffer left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"Saving	
"-------------------------	
" If the current buffer has never been saved, it will have no name,	
" call the file browser to save it, otherwise just save it.	
command -nargs=0 -bar Update if &modified	
                          \|    if empty(bufname('%'))	
                          \|        browse confirm write	
                          \|    else	
                          \|        confirm write	
                          \|    endif	
                          \|endif
"<C-s> to save
nnoremap <silent> <C-s> :<C-u>Update<CR>
inoremap <C-s> <C-o>:Update<CR>

"TODO
"-------------------------
" Add TODO highlighting for all filetypes
augroup HiglightTODO
    autocmd!
        autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO', -1)
        augroup END

"Dhall
let g:dhall_format=1

"ormolu
let g:ormolu_options=["-o -XTypeApplications"]


"Ctrl-O/P to open files
"-------------------------
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'Files'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_lazy_update = 10
nnoremap <C-o> :CtrlPBuffer<CR>
inoremap <C-o> <Esc>:CtrlPBuffer<CR>
"And to open by searching file content
nnoremap <C-l> :Rg<CR>