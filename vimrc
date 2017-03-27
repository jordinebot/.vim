" Jordi Nebot's .vimrc based on $VIMRUNTIME/vimrc_example.vim
" and $VIMRUNTIME/defaults.vim

" Enable pathogen to load plugins
" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = ['ctrlp.vim']
execute pathogen#infect()

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
    finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=50      " keep 200 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set wildmenu        " display completion matches in a status line

set ttimeout        " time out for key codes
set ttimeoutlen=100 " wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
    set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
    set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
    set mouse=a
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
    " Revert with ":syntax off".
    syntax on

    " I like highlighting strings inside C comments.
    " Revert with ":unlet c_comment_strings".
    let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    " Revert with ":filetype off".
    filetype plugin indent on

    " Put these in an autocmd group, so that you can revert them with:
    " ":augroup vimStartup | au! | augroup END"
    augroup vimStartup
        au!

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufReadPost *
                    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If set (default), this may break plugins (but it's backward
    " compatible).
    set nolangremap
endif
" End of defaults.vim

if has("vms")
    set nobackup      " do not keep a backup file, use versions instead
else
    set backup        " keep a backup file (restore to previous version)
    if has('persistent_undo')
        set undofile    " keep an undo file (undo changes after closing)
    endif
endif

if &t_Co > 2 || has("gui_running")
    " Switch on highlighting the last used search pattern.
    set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

    augroup END

else

    set autoindent        " always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
if has('syntax') && has('eval')
    packadd matchit
endif


""" MY CUSTOM SETUP

" Remove trailing spaces on save
autocmd BufWritePre * :%s/\s\+$//e

let mapleader=","

" Cancel a search with Esc
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

" Automatically close parenthesis, brackets, quotes, etc
inoremap ( ()<Esc>i
inoremap {<CR> {<CR>}<Esc>ko

" Fast save
map <Leader>w :w<CR>
map <Leader>s :w!<CR>
map <D-s> :w<CR>

" Map ,v to source (reload) .vimrc.
map <Leader>v :source ~/.vimrc<CR>

" Map ,ai to reindent the current buffer and return cursor to its position
map <Leader>ai mzgg=G`z

" Map ,t to TagBar
nmap <Leader>t :TagbarToggle<CR>

" Replace all occurrences of word under cursor in the whole file
nnoremap <Leader>r :%s/\<<C-r><C-w>\>//g<Left><Left>

" Easy buffer switch with ,.#
map <Leader>. :ls<CR>:b
map <Leader>g :e /git<CR>
map <Leader>j :bnext<CR>
map <Leader>k :bprev<CR>
" Fast switch to previous file
nnoremap <Leader><Leader> :e#<CR>

" Quick way to move lines of text up or down.
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Insert mode
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Map Shift Tab
" for command mode
nnoremap <S-Tab> <<
" for insert mode
inoremap <S-Tab> <C-d>


" Set color theme to molokai
colorscheme monokai

" Set fontsize (only for GUI mode e.g. MacVim)
if has('gui_running')
    set guifont=mononoki:h20
    set guioptions-=T  " no toolbar
    set linespace=10
endif

filetype indent on
set hidden          " Allows to switch buffers without saving first
set number
set nowrap
set tabstop=4
set shiftwidth=4
set expandtab       " Convert TAB to spaces
set smartindent
set autoindent
set cursorline
set conceallevel=0  " Don't hide conceal text (e.g. quotes on JSON files)
set tags=./tags;/
" Make search (but not replacement) case insensitive:
" Explanation ->  http://stackoverflow.com/a/35359583/1534704
nnoremap / /\c
nnoremap ? ?\c

" Plugin setup
let g:netrw_home='/git'
let g:netrw_list_hide='node_modules,\.git,.DS_Store,\~$,\.swp$'

" NerdTree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['node_modules', '\~$']
" Quit vim if NERDTree is the last remaining buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Always show Bookmarks
let NERDTreeShowBookmarks=1
"Auto open NERDtree on enter vim
au VimEnter *  NERDTree /git/

" Emmet expand with TAB
autocmd BufNewFile,BufRead *.html imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" Use The Silver Searcher (https://robots.thoughtbot.com/faster-grepping-in-vim)
if executable('ag') && exists(":CtrlP")
    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor

    " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0
endif

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Remove CoffeeScript blocks from TagBar
let g:tagbar_type_coffee = {
    \ 'kinds' : [
        \ 'f:functions',
        \ 'c:classes',
        \ 'o:object',
        \ 'v:variables',
        \ 'p:prototypes',
        \ '?:unknown',
    \ ],
\ }

" Setting Working Directory
" set working directory to git project root
" or directory of current file if not git project
function! SetProjectRoot()
  " default to the current file's directory
  lcd %:p:h
  let git_dir = system("git rev-parse --show-toplevel")
  " See if the command output starts with 'fatal' (if it does, not in a git repo)
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " if git project, change local directory to git project root
  if empty(is_not_git_dir)
    lcd `=git_dir`
  endif
endfunction

autocmd BufRead *
    \ call SetProjectRoot()

" netrw: set working directory
autocmd CursorMoved silent *
    " short circuit for non-netrw files
    \ if &filetype == 'netrw' |
    \   call SetProjectRoot() |
    \ endif

" My custom statusline
function! HighlightSearch()
    if &hls
        return 'H'
    else
        return ''
    endif
endfunction

set laststatus=2                                          " This makes the statusline always visible
set statusline=
set statusline+=%7*\[%n]                                  " buffernr
set statusline+=%1*\ %<%F\                                " File+path
set statusline+=%2*\ %y\                                  " FileType
set statusline+=%3*\ %{''.(&fenc!=''?&fenc:&enc).''}      " Encoding
set statusline+=%3*\ %{(&bomb?\",BOM\":\"\")}\            " Encoding2
set statusline+=%4*\ %{&ff}\                              " FileFormat (dos/unix..)
set statusline+=%5*\ %{&spelllang}\%{HighlightSearch()}\  " Spellanguage & Highlight on?
set statusline+=%8*\ %=\ row:%l/%L\ (%03p%%)\             " Rownumber/total (%)
set statusline+=%9*\ col:%03c\                            " Colnr
set statusline+=%0*\ \ %m%r%w\ %P\ \                      " Modified? Readonly? Top/bot.
set cmdheight=1
