" Make sure any autocommands are replaced not added to when reloading this file
augroup vimrc
autocmd!
"===============================================================================

" Debugging
"set verbose=9

" Change out of the c:\windows\system32 directory because NERDtree seems to
" fail to load (or loads *really* slowly) in that directory
if getcwd() == $windir . "\\system32"
    cd $HOME
endif

" Use Pathogen to manage plugin bundles
call pathogen#infect()
call pathogen#helptags()

" Helper to run a command while preserving cursor position & search history
" http://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
function! PreserveCursor(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let pos = getpos('.')
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call setpos('.', pos)
endfunction

" Behave more like a Windows program
runtime mswin.vim

" Make % jump between XML tags as well as normal brackets
runtime macros/matchit.vim

" Enable syntax highlighting
syntax on

" Change color scheme
colorscheme torte

" Make the line numbers less visible
hi LineNr guifg=#444444

" Make folded sections easier to read (dark grey instead of light background)
hi Folded guibg=#111111

" Highlight just *after* columns 80 and 120
set colorcolumn=81,121
hi ColorColumn ctermbg=DarkGray guibg=#333333

" PHP syntax highlighting settings
"let php_sql_query = 1
"let php_htmlInStrings = 1
let php_smart_members = 1
"let php_highlight_quotes = 1
let php_alt_construct_parents = 1
let php_sync_method = 0            " Sync from file start
let php_show_semicolon_error = 0   " This causes errors with /* */ multiline comments

" File type detection
filetype plugin on

" Always use Unix-format new lines for new files
au BufNewFile * if !&readonly && &modifiable | set fileformat=unix | endif

" Tab2Space - http://vim.wikia.com/wiki/Super_retab
command! -range=% -nargs=0 Tab2Space execute "<line1>,<line2>s/^\\t\\+/\\=substitute(submatch(0), '\\t', repeat(' ', ".&ts."), 'g')"

" Space2Tab - http://vim.wikia.com/wiki/Super_retab
command! -range=% -nargs=0 Space2Tab execute "<line1>,<line2>s/^\\( \\{".&ts."\\}\\)\\+/\\=substitute(submatch(0), ' \\{".&ts."\\}', '\\t', 'g')"

" Convert mixed spaces/tabs to all spaces:
" :ReIndent       Convert 2 space indents & tabs to current shiftwidth (i.e. default 4)
" :ReIndent <N>   Convert N space indents & tabs to current shiftwidth (i.e. default 4)
" Based on http://vim.wikia.com/wiki/Super_retab
function! <SID>ReIndent(...)
    let origts = (a:0 >= 3 ? a:3 : 2)
    let newts = &tabstop
    silent execute a:1 . "," . a:2 . "s/^\\( \\{" . origts . "\\}\\)\\+/\\=substitute(submatch(0), ' \\{" . origts . "\\}', '\\t', 'g')"
    silent execute a:1 . "," . a:2 . "s/^\\t\\+/\\=substitute(submatch(0), '\\t', repeat(' ', " . newts . "), 'g')"
endfunction

command! -range=% -nargs=? ReIndent call <SID>ReIndent(<line1>, <line2>, <f-args>)

" Automatically cd to the directory that the current file is in
" This first option is built in but doesn't quite work as you'd expect - see
" http://stackoverflow.com/questions/164847/what-is-in-your-vimrc/652632#652632
" Added silent! to prevent error messages if the file & directory has been deleted
"set autochdir
" Removed 2012-04-19 because I want paths relative to the project root
"autocmd BufEnter * execute "silent! chdir ".escape(expand("%:p:h"), ' ')

" Auto-complete (X)HTML tags with Ctrl-Hyphen
au Filetype * runtime closetag.vim

" Use Sparkup to generate HTML quickly (Ctrl-E)
au Filetype * runtime sparkup.vim

" FuzzyFinder - if search begins with a space do a recursive search
if v:version >= 700
    let g:fuf_abbrevMap = {
        \   "^ " : [ "**/", ],
        \}
endif

" Sort CSS properties alphabetically
command! SortCSS silent! call PreserveCursor("?{?+1,/}/-1sort")

" Sort .snippets files alphabetically
function! <SID>SortSnippets()
    " Join all lines together
    %s/\n/__NEWLINE__
    " Split by where the snippets start, so each snippet is one line
    %s/__NEWLINE__snippet /__NEWLINE__\rsnippet 
    " Remove any __NEWLINE__s that are already followed by a new line
    %s/__NEWLINE__\n/\r
    " Delete the extra blank line that gets added at the end
    $d
    " Sort the lines alphabetically
    sort
    " Split the snippets into separate lines again
    %s/__NEWLINE__/\r
endfunction

command! SortSnippets silent! call PreserveCursor("call <SID>SortSnippets()")

"===============================================================================

" <Ctrl-Alt-Up/Down> swaps lines
" http://vim.wikia.com/wiki/Transposing
function! <SID>MoveLineUp()
    call <SID>MoveLineOrVisualUp(".", "")
endfunction

function! <SID>MoveLineDown()
    call <SID>MoveLineOrVisualDown(".", "")
endfunction

function! <SID>MoveVisualUp()
    call <SID>MoveLineOrVisualUp("'<", "'<,'>")
    normal gv
endfunction

function! <SID>MoveVisualDown()
    call <SID>MoveLineOrVisualDown("'>", "'<,'>")
    normal gv
endfunction

function! <SID>MoveLineOrVisualUp(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num - v:count1 - 1 < 0
        let move_arg = "0"
    else
        let move_arg = a:line_getter." -".(v:count1 + 1)
    endif
    call <SID>MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! <SID>MoveLineOrVisualDown(line_getter, range)
    let l_num = line(a:line_getter)
    if l_num + v:count1 > line("$")
        let move_arg = "$"
    else
        let move_arg = a:line_getter." +".v:count1
    endif
    call <SID>MoveLineOrVisualUpOrDown(a:range."move ".move_arg)
endfunction

function! <SID>MoveLineOrVisualUpOrDown(move_arg)
    let col_num = virtcol(".")
    execute "silent! ".a:move_arg
    execute "normal! ".col_num."|"
endfunction

nnoremap <silent> <C-A-Up> :<C-u>call <SID>MoveLineUp()<CR>
nnoremap <silent> <C-A-Down> :<C-u>call <SID>MoveLineDown()<CR>
inoremap <silent> <C-A-Up> <C-o>:<C-u>call <SID>MoveLineUp()<CR>
inoremap <silent> <C-A-Down> <C-o>:<C-u>call <SID>MoveLineDown()<CR>
vnoremap <silent> <C-A-Up> :<C-u>call <SID>MoveVisualUp()<CR>
vnoremap <silent> <C-A-Down> :<C-u>call <SID>MoveVisualDown()<CR>

"===============================================================================

" Remember cursor position for each file
" http://vim.sourceforge.net/tips/tip.php?tip_id=80
autocmd BufReadPost *
\   if expand("<afile>:p:h") !=? $TEMP |
\       if line("'\"") > 1 && line("'\"") <= line("$") |
\           let JumpCursorOnEdit_foo = line("'\"") |
\           let b:doopenfold = 1 |
\           if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
\               let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
\               let b:doopenfold = 2 |
\           endif |
\           exe JumpCursorOnEdit_foo |
\       endif |
\   endif

" Need to postpone using "zv" until after reading the modelines.
autocmd BufWinEnter *
\   if exists("b:doopenfold") |
"\       exe "normal zv" |
\       if (b:doopenfold > 1) |
\           exe  "+".1 |
\       endif |
\       unlet b:doopenfold |
\   endif

"===============================================================================

let snips_author = 'Dave James Miller'

if !exists('g:snipMate')
  let g:snipMate = {}
endif

let g:snipMate['scope_aliases'] = {
    \   'cpp':      'c',
    \   'cs':       'c',
    \   'eco':      'html',
    \   'eruby':    'html',
    \   'html':     'htmlonly',
    \   'less':     'css',
    \   'mxml':     'actionscript',
    \   'objc':     'c',
    \   'php':      'html',
    \   'scss':     'css',
    \   'smarty':   'html',
    \   'ur':       'html',
    \   'xhtml':    'htmlonly,html',
    \}

" Ruby
function! Snippet_RubyClassNameFromFilename(...)
    let name = expand("%:t:r")
    if len(name) == 0
        if a:0 == 0
            let name = 'MyClass'
        else
            let name = a:1
        endif
    endif
    return Snippet_Camelcase(substitute(name, '_spec$', '', ''))
endfunction

function! Snippet_MigrationNameFromFilename(...)
    let name = substitute(expand("%:t:r"), '^.\{-}_', '', '')
    if len(name) == 0
        if a:0 == 0
            let name = 'MyClass'
        else
            let name = a:1
        endif
    endif
    return Snippet_Camelcase(name)
endfunction


" Python
function! Snippet_PythonClassNameFromFilename(...)
    let name = expand("%:t:r")
    if len(name) == 0
        if a:0 == 0
            let name = 'MyClass'
        else
            let name = a:1
        endif
    endif
    return Snippet_Camelcase(name)
endfunction

" PHP
function! Snippet_PHPClassNameFromFilename(...)
    let name = expand("%:t:r:r")
    if len(name) == 0
        if a:0 == 0
            let name = 'MyClass'
        else
            let name = a:1
        endif
    endif
    return name
endfunction

" Java
function! Snippet_JavaClassNameFromFilename(...)
    let name = expand("%:t:r")
    if len(name) == 0
        if a:0 == 0
            let name = 'MyClass'
        else
            let name = a:1
        endif
    endif
    return name
endfunction

function! Snippet_JavaInstanceVarType(name)
    let oldview = winsaveview()
    if searchdecl(a:name) == 0
        normal! B
        let old_reg = @"
        normal! yaW
        let type = @"
        let @" = old_reg
        call winrestview(oldview)
        let type = substitute(type, '\s\+$', '', '')

        "searchdecl treats  'return foo;' as a declaration of foo
        if type != 'return'
            return type
        endif
    endif
    return "<+type+>"
endfunction


" Global
function! s:start_comment()
    return substitute(&commentstring, '^\([^ ]*\)\s*%s\(.*\)$', '\1', '')
endfunction

function! s:end_comment()
    return substitute(&commentstring, '^.*%s\(.*\)$', '\1', '')
endfunction

function! Snippet_Modeline()
    return s:start_comment() . " vim: set ${1:settings}:" . s:end_comment()
endfunction

function! Snippet_Camelcase(s)
    "upcase the first letter
    let toReturn = substitute(a:s, '^\(.\)', '\=toupper(submatch(1))', '')
    "turn all '_x' into 'X'
    return substitute(toReturn, '_\(.\)', '\=toupper(submatch(1))', 'g')
endfunction

function! Snippet_Underscore(s)
    "down the first letter
    let toReturn = substitute(a:s, '^\(.\)', '\=tolower(submatch(1))', '')
    "turn all 'X' into '_x'
    return substitute(toReturn, '\([A-Z]\)', '\=tolower("_".submatch(1))', 'g')
endfunction

" Used to generate PHP class name automatically from the filename
fun! Snippet_AutoClassName()
    let filename = expand('%:p')
    if filename == ''
        return 'ClassName'
    endif
    let filename = substitute(filename, '\\', '/', 'g')
    if match(filename, '/classes/') > -1
        " /classes/A/B/C.php -> "A_B_C"
        let filename = substitute(filename, '^.*/classes/', '', '')
        let filename = substitute(filename, '/', '_', 'g')
        let filename = substitute(filename, '\.php$', '', '')
    else
        " /A/B/C.php -> "C"
        let filename = expand('%:t:r')
    endif
    return filename
endf

" HTML snippet common to PHP, Smarty and HTML
fun! Snippet_HTML()
   return "
       \<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n
       \<html lang=\"en-GB\" xml:lang=\"en-GB\" dir=\"ltr\" xmlns=\"http://www.w3.org/1999/xhtml\">\n
       \	<head>\n
       \\n
       \		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n
       \		<meta http-equiv=\"Content-Language\" content=\"en-GB\" />\n
       \\n
       \		<title>${1:Untitled Document}</title>\n
       \\n
       \		<link rel=\"stylesheet\" href=\"/css/main.css\" type=\"text/css\" />\n
       \\n
       \	</head>\n
       \	<body>\n
       \\n
       \		${2}\n
       \\n
       \	</body>\n
       \</html>"
endf

"===============================================================================

" Make ^Z undo smaller chunks at a time
" http://vim.wikia.com/wiki/Modified_undo_behavior
inoremap <BS> <C-g>u<BS>
inoremap <Del> <C-g>u<Del>
inoremap <C-W> <C-g>u<C-W>

" Make paste an undoable action, rather than joining it with any text that's typed in
" Also use character-wise instead of line-wise paste, so it goes where the
" cursor is instead of on the line above
if exists("*paste#Paste")

    function! <SID>MyPaste()

        " Set to character-wise
        " http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
        let reg_type = getregtype("+")
        call setreg("+", getreg("+"), "v")

        " Use the bundled paste command
        call paste#Paste()

        " Reset line/character-wise
        call setreg("+", getreg("+"), reg_type)

    endfunction

    " Explanation:
    " <C-g>u                      Set undo point
    " <C-o>:call MyPaste()<CR>    Call the function above
    " <C-g>u                      Set another undo point
    " 2010-06-19 Removed the final undo point because it seems to cause problems
    "            when ThinkingRock is open...
    "inoremap <C-V> <C-g>u<C-o>:call MyPaste()<CR><C-g>u
    inoremap <C-V> <C-g>u<C-o>:call <SID>MyPaste()<CR>

endif

"===============================================================================
" Finish the autocommands group
augroup END

"===============================================================================

augroup filetypedetect

    " AutoIt
    au BufNewFile,BufRead *.au3 setf autoit

    " Standard ML
    au BufNewFile,BufRead *.ml,*.sml setf sml

    " Java
    au BufNewFile,BufRead *.class setf class
    au BufNewFile,BufRead *.jad setf java

    " CSV
    au BufNewFile,BufRead *.csv setf csv

    " CakePHP
    au BufNewFile,BufRead *.thtml,*.ctp setf php

    " Drupal
    au BufNewFile,BufRead *.module,*.install setf php
    au BufNewFile,BufRead *.info setf dosini

    " Ruby
    au BufNewFile,BufRead *.rabl setf ruby

    " Text files
    au BufNewFile,BufRead *.txt setf txt

augroup END

"===============================================================================

"---------------------------------------
" Settings
"---------------------------------------

" Use UTF-8 for everything, but no byte-order mark because it breaks things
"set encoding=utf-8
"set fileencoding=utf-8
"set fileencodings=ucs-bom,utf-8,default,latin1
"set nobomb

" Use 4 spaces to indent (use ":ret" to convert tabs to spaces)
set expandtab tabstop=4 softtabstop=4 shiftwidth=4

" Allow pressing arrows (without shift) in visual mode
" This gives the best of both worlds - you can use shift+arrow in insert mode to
" quickly start visual mode (instead of <Esc>v<Arrow>), but still use the arrow
" keys in visual mode as normal (instead of having to hold shift)
" TODO: Learn to use hjkl instead of the arrow keys so this isn't an issue!
set keymodel-=stopsel

" Case-insensitive search unless there's a capital letter (then case-sensitive)
set ignorecase
set smartcase

" Highlight search results as you type
"set hlsearch
set incsearch

" Default to replacing all occurrences in :s (swaps the meaning of the /g flag)
set gdefault

" Wrap to the next line for all commands that move left/right
set whichwrap=b,s,h,l,<,>,~,[,]

" Show line numbers
set number

" Always show the status line
set laststatus=2

" Open split windows below/right instead of above/left by default
set splitbelow
set splitright

" Shorten some status messages, and don't show the intro splash screen
set shortmess=ilxtToOI

" Use dialogs to confirm things like quiting without saving, instead of failing
set confirm

" Don't put two spaces between sentences
set nojoinspaces

" Always write a separate backup, don't use renaming because it resets the
" executable flag when editing over Samba
set backupcopy=yes

" Don't hide the mouse when typing
set nomousehide

" Remember 50 history items instead of 20
set history=50

" Show position in the file in the status line
set ruler

" Show selection size
set showcmd

" Show list of matches when tab-completing commands
set wildmenu

" Don't redraw the screen while executing macros, etc.
set lazyredraw

" Enable modeline support, because Debian disables it (for security reasons)
set modeline

" Allow hidden buffers, so I can move between buffers without having to save first
set hidden

" Use existing window/tab if possible when switching buffers
set switchbuf=useopen,usetab

" Show the filename in the titlebar when using console vim
set title

" Keep 5 lines/columns of text on screen around the cursor
" Removed 2012-08-13 because it makes double-clicking near the edge of the
" screen impossible
"set scrolloff=5
"set sidescroll=1
"set sidescrolloff=5

" Enable mouse support in all modes#
if has("mouse")
    set mouse=a
endif

" Automatically fold when markers are used
if has("folding")
    set foldmethod=marker
endif

" Remove all the ---s after a fold to make it easier to read
set fillchars=vert:\|,fold:\ 

" Keep an undo history after closing Vim (Vim 7.3+)
if version >= 703
    set undofile
endif

" In case I ever use encryption, Blowfish is more secure (but requires Vim 7.3+)
if version >= 703
    set cryptmethod=blowfish
endif

" Show tabs and trailing spaces...
set list
set listchars=tab:-\ ,trail:.

" Except in snippet files because they have to use tabs
au FileType snippet,snippets setl listchars+=tab:\ \ 

" Use the temp directory for all backups and swap files, instead of cluttering
" up the filesystem with .*.swp and *~ files
" Note the trailing // means include the full path of the current file so
" files with the same name in different folders don't conflict
set backupdir=~/.cache/vim//
set directory=~/.cache/vim//
set undodir=~/.cache/vim//

" Remember mark positions
set viminfo+=f1

" Indenting
set autoindent
"set smartindent    " Removed because it prevent #comments being indented
"set cindent        " Removed because it indents things when it shouldn't
"set cinoptions-=0# " So #comments aren't unindented with cindent
set formatoptions+=ro " Duplicate comment lines when pressing enter

" No GUI toolbar - I never use it
set guioptions-=T

" Keep scrollbars on the right - the left scrollbar doesn't work with my
" gaming mouse software
set guioptions-=L

"set autoindent
"set autoread
"set backupdir=~/.cache/vim//
"set confirm
"set directory=~/.cache/vim//
"set expandtab
"set formatoptions+=ro
"set gdefault
"set hidden
"set ignorecase
"set incsearch
"set laststatus=2
"set list
"set listchars=tab:→\ ,trail:·
"set modeline
"set number
"set shiftwidth=4
"set shortmess=filnotxIOT
"set smartcase
"set softtabstop=4
"set tabstop=4
set ttimeout
set ttimeoutlen=50
"set undodir=~/.cache/vim//
"set undofile
"set viminfo='100,<50,s10,h,n~/.cache/vim/viminfo
"set whichwrap=<,>,[,],h,l,b,s
"set wildmenu
"
"let g:netrw_list_hide='.*\.swp$,\~$'

if !isdirectory($HOME . '/.cache/vim')
    call mkdir($HOME . '/.cache/vim', 'p', 0700)
endif


"---------------------------------------
" Colours
"---------------------------------------

"colorscheme torte
"set colorcolumn=81,121
"highlight ColorColumn ctermbg=DarkGray guibg=#333333
"
"
""---------------------------------------
"" Helpers
""---------------------------------------
"
"" Run a command while preserving cursor position & search history
"" https://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
"function! PreserveCursor(command)
"    let _s=@/
"    let pos = getpos('.')
"    execute a:command
"    let @/=_s
"    call setpos('.', pos)
"endfunction


"---------------------------------------
" Autocommands
"---------------------------------------

augroup myvimrc

    " Clear previously defined autocommands
    autocmd!

    " Restore the last cursor position
    "autocmd BufReadPost *
    "\   if line("'\"") > 0 && line("'\"") <= line("$") |
    "\       exe "normal! g`\"" |
    "\   endif

    " Reload Tmux config
    autocmd BufWritePost .tmux.conf
    \   silent exec '!tmux source $HOME/.tmux.conf \; display "Reloaded ~/.tmux.conf" 2>/dev/null'

    " Reload Vim config
    autocmd BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc nested
    \   source $MYVIMRC |
    \   if has('gui_running') |
    \       so $MYGVIMRC |
    \   endif

augroup END


"---------------------------------------
" Key mappings
"---------------------------------------

" Use ; instead of : for commands (don't need to press shift so much)
nnoremap ; :
vnoremap ; :

" Ctrl+tab to switch windows
nnoremap <C-Tab> <C-w>w
nnoremap <C-S-Tab> <C-w>p

" Ctrl+direction to switch windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Cycle through buffers
"nnoremap <C-n> :bnext<CR>
"nnoremap <C-p> :bprevious<CR>

" Switch buffer quickly by pressing spacebar
nmap <Space> :Buffers<CR>

" Ctrl-P
nnoremap <C-p> :Files<CR>

" Ctrl-Space for Buffer Explorer - slower, but easier for browsing the list of
" open buffers if I can't remember the filename
nmap <silent> <C-Space> :call MyBufExplorer()<CR>

" Navigate by screen lines rather than file lines
nnoremap k gk
nnoremap j gj
nnoremap <Up> gk
inoremap <Up> <C-O>gk
vnoremap <Up> gk
nnoremap <Down> gj
inoremap <Down> <C-O>gj
vnoremap <Down> gj
nnoremap <Home> g0
inoremap <Home> <C-O>g0
nnoremap <End> g$
inoremap <End> <C-O>g$

" gf = Goto file under cursor (even if it doesn't exist yet)
nmap gf :e <cfile><CR>

" Use visual mode for Ctrl-A (select all)
noremap <C-A> ggvG$
inoremap <C-A> <C-O>gg<C-O>vG$
cnoremap <C-A> <C-C>ggvG$
onoremap <C-A> <C-C>ggvG$
snoremap <C-A> <C-C>ggvG$
xnoremap <C-A> <C-C>ggvG$

" Keep selection when indenting block-wise
xnoremap < <gv
xnoremap > >gv

" Swap two text blocks by deleting the first block then visually selecting the
" second block and pressing x (mneumonic: eXchange)
vnoremap x <Esc>`.``gvP``P

" Make increment/decrement work in Windows using alt
noremap <M-a> <C-a>
noremap <M-x> <C-x>

" Make F5 run macro @q (so it can be quickly recorded with 'qq' and then
" run repeatedly with <F5>)
nnoremap <F5> @q
vnoremap <F5> @q

" Leader mappings
" Use , as the leader for my own keyboard shortcuts
let mapleader = ","

" Alternate files (a.vim)
nmap <Leader>a :A<CR>

" Remove DOS line endings
nmap <silent> <Leader>dr :call PreserveCursor('%s/\r$//')<CR>

" Delete spaces from otherwise empty lines
nmap <silent> <Leader>ds :call PreserveCursor('%s/^\s\+$//e')<CR>

" Delete trailing spaces
nmap <silent> <Leader>dt :call PreserveCursor('%s/\s\+$//e')<CR>

" Browse current directory
nmap <silent> <Leader>e :Explore<CR>
nmap <silent> <Leader>E :Vexplore!<CR>

" Toggle search highlight
nmap <silent> <Leader>h :set hlsearch!<CR>

" Find current file in NERDtree
nmap <silent> <Leader>n :NERDTreeFind<CR>

" Toggle line numbers
nmap <silent> <Leader>N :set number!<CR>

" Open snippets directory
nmap <silent> <Leader>os :edit $HOME/.vim/snippets<CR>

" Open Vim settings
nmap <silent> <Leader>ov :edit $HOME/.vim<CR>

" Toggle paste mode
nmap <silent> <Leader>p :set paste!<CR>

" Quit
nmap <silent> <Leader>q :q<CR>
nmap <silent> <Leader>Q :wq<CR>

" Split screen in various directions
nmap <silent> <Leader>sh         :split<CR>
nmap <silent> <Leader>sv         :vsplit<CR>
nmap <silent> <Leader>s<Left>    :leftabove  :vsplit<CR>
nmap <silent> <Leader>s<Down>    :belowright :split<CR>
nmap <silent> <Leader>s<Up>      :aboveleft  :split<CR>
nmap <silent> <Leader>s<Right>   :rightbelow :vsplit<CR>

" Change the tab size
nmap <Leader>0t :set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab listchars-=tab:-\   listchars+=tab:\ \ <CR>
nmap <Leader>1t :set tabstop=1 softtabstop=1 shiftwidth=1 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>2t :set tabstop=2 softtabstop=2 shiftwidth=2 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>3t :set tabstop=3 softtabstop=3 shiftwidth=3 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>4t :set tabstop=4 softtabstop=4 shiftwidth=4 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>5t :set tabstop=5 softtabstop=5 shiftwidth=5 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>6t :set tabstop=6 softtabstop=6 shiftwidth=6 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>7t :set tabstop=7 softtabstop=7 shiftwidth=7 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>8t :set tabstop=8 softtabstop=8 shiftwidth=8 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>

nmap <Leader>0T :setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab listchars-=tab:-\   listchars-=tab:-\ <CR>
nmap <Leader>1T :setlocal tabstop=1 softtabstop=1 shiftwidth=1 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>2T :setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>3T :setlocal tabstop=3 softtabstop=3 shiftwidth=3 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>4T :setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>5T :setlocal tabstop=5 softtabstop=5 shiftwidth=5 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>6T :setlocal tabstop=6 softtabstop=6 shiftwidth=6 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>7T :setlocal tabstop=7 softtabstop=7 shiftwidth=7 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>
nmap <Leader>8T :setlocal tabstop=8 softtabstop=8 shiftwidth=8 expandtab   listchars-=tab:\ \  listchars+=tab:-\ <CR>

" Write
nmap <silent> <Leader>w :w<CR>

" HTML tags
function! <SID>VisualWrap(before, after, ...)
    let tmp = @k
    " Copy to register
    normal gv"ky
    " Modify register
    let @k = a:before . @k . a:after
    " Paste from register
    normal gv"kp
    " Revert register contents
    let @k = tmp
    " Position cursor
    if a:0 > 0 && a:1 > 0
        normal `<
        exe "normal " . a:1 . "l"
    endif
endfunction

vmap <silent> <Leader><C-b> <Esc>:call <SID>VisualWrap("<strong>", "</strong>")<CR>
vmap <silent> <Leader><C-d> <Esc>:call <SID>VisualWrap("<div>", "</div>", 4)<CR>
vmap <silent> <Leader><C-i> <Esc>:call <SID>VisualWrap("<em>", "</em>")<CR>
vmap <silent> <Leader><C-k> <Esc>:call <SID>VisualWrap("<a href=\"\">", "</a>", 9)<CR>
vmap <silent> <Leader><C-p> <Esc>:call <SID>VisualWrap("<p>", "</p>")<CR>
vmap <silent> <Leader><C-s> <Esc>:call <SID>VisualWrap("<span>", "</span>", 5)<CR>
vmap <silent> <Leader><C-u> <Esc>:call <SID>VisualWrap("<u>", "</u>")<CR>


"" Ctrl-S
"noremap  <silent> <C-S> :wall<CR>
"vnoremap <silent> <C-S> <C-C>:wall<CR>
"inoremap <silent> <C-S> <Esc>:wall<CR>gi
"
"" Ctrl-Y
"noremap  <silent> <C-Y> <C-R>
"inoremap <silent> <C-Y> <C-O><C-R>
"
"" Ctrl-Z
"noremap  <silent> <C-Z> u
"inoremap <silent> <C-Z> <C-O>u
"
"" Ctrl-Tab
"noremap <C-Tab> :bn<CR>
"noremap <C-S-Tab> :bp<CR>
"
"" Spacebar
"noremap <Space> :CtrlPBuffer<CR>
"
"" ,
"let mapleader = ','
"
"" ,d*
"noremap <silent> <Leader>dt :call PreserveCursor('%s/\s\+$//e')<CR>
"
"" ,e
"noremap <silent> <Leader>e :Explore<CR>
"
"" ,n
"noremap <silent> <Leader>n :set number!<CR>

" ,p*
noremap <silent> <Leader>pc :PlugClean<CR>

noremap <silent> <Leader>pi
\   :PlugInstall<CR>

noremap <silent> <Leader>pr
\   :source $MYVIMRC<CR>

noremap <silent> <Leader>pu
\   :PlugUpgrade<CR>
\   :PlugUpdate --sync<CR>

"" ,q
"noremap <silent> <Leader>q :q<CR>

"" ,w
"noremap <silent> <Leader>w :set wrap!<CR>
"
"" ;
"nnoremap ; :
"vnoremap ; :


"---------------------------------------
" Plugins
"---------------------------------------

" Auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !echo "Downloading vim-plug..."; curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Configure plugins
call plug#begin('~/.vim/plugged')

    Plug 'ap/vim-css-color'

    Plug 'bogado/file-line'

    Plug 'editorconfig/editorconfig-vim'

    Plug 'itchyny/lightline.vim'
    let g:lightline = {
    \   'colorscheme': 'wombat',
    \}
    set noshowmode

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'preservim/nerdcommenter'

    " This adds :Rename, :Delete, :SudoWrite, etc.
    Plug 'tpope/vim-eunuch'

call plug#end()

" Automatically install missing plugins
augroup vim-plug
    autocmd! VimEnter *
    \   if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|      PlugInstall --sync
    \|      quit
    \|      source $MYVIMRC
    \|  endif
augroup END
