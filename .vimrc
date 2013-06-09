" Vim conf file
" Author:               Gonzalo Saavedra <gonz at debianuruguay dot org>
" Modified:             Alvaro Mouriño <tuxie at debianuruguay dot org>
" Created:              November 7th 2003
" Last Change:  June 5th, 2006
" vim:fdm=marker:ft=vim

" SETS {{{
" set guifont="Monospace\ 8"
set background=dark
set backspace=indent,eol,start
set backupdir=~/.vim/backup,~/tmp,.,/tmp
set cindent
set clipboard=unnamed
set complete=.,w,k,d
set cryptmethod=blowfish
set dictionary=~/.vim/wordlists/demo.list
set directory=~/.vim/swap,~/tmp,.,/tmp
set expandtab
set foldcolumn=2
set foldtext=GFoldText()
set guioptions=agimt
set history=500
set hlsearch
set incsearch
set laststatus=2
set lazyredraw
set matchtime=2
set modeline
set modelines=5
set mouse=a
set noautowrite
set nocompatible
set noequalalways
set noex
set noignorecase
set number
set previewheight=10
set ruler
set shiftwidth=4
set showcmd
set showmatch
set showmode
set smarttab
set softtabstop=4
set statusline=%F%m%r%h%w%=[TIPO=%Y(%{&ff})]\ [LINEA=%l/%L][COL=%v][%p%%]
set sts=4
set suffixes=.bak,~,.swp,.o,.info,.aux,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set sw=4
set textwidth=0
set ts=4
set ttymouse=xterm2
set viminfo='20,\"50
set wildmenu
set winminheight=0
set wrap
" http://www.vim.org/scripts/script.php?script_id=850
filetype plugin on
let g:pydiction_location = '/usr/share/vim/vim72/ftplugin/pydict/complete-dict'
" let g:pydiction_menu_height = 15
syntax on
" }}}
" FUNCTIONS {{{
function! TabComp()
   if (strpart(getline('.'),col('.')-2,1)=~'^\W\?$')
       return "\<Tab>"
   else
       return "\<C-n>"
   endif
endfunction

" Ugly function for diff'ing a file under SVN w/ the BASE version
" of the file
" TODO: Is this file under revision?
function! Gitdiff()
   let fn = expand('%:p')
       new
       set ft=diff
       execute ":.!git diff " . fn
       unlet fn
       return
endfunction

" Ugly (2) function for diff'ing a file under SVN w/ the BASE version
" of the file, this splits a window and uses vim's diff mode
" TODO: Is this file under revision?
function! Gitdiff2()
   let dir = expand('%:p:h')
   let fn = expand('%')
       execute ":vert diffsplit" . dir . "/.svn/text-base/" . fn . ".svn-base"
       unlet fn dir
       return
endfunction

function! GFoldText()
 let line = getline(v:foldstart)
 let sub = substitute(line, '/\*\|\*/\|\s*{\s\?{{\d\?\s*', '', 'g')
 let lines = v:foldend - v:foldstart
 return v:folddashes . sub . " (" . lines . " lines)"
endfunction
" }}}
" MAPS {{{
nmap          <Space> zA

map <silent>  ,fi       :set foldmethod=indent<CR>
map <silent>  ,fm       :set foldmethod=manual<CR>
map <silent>  ,f{       :set foldmethod=marker<CR>

nnoremap      <Enter>   <C-]>

nmap          <F11>     mzggVGg?`z

" nmap <silent> <F12>     :write<CR>
" imap <silent> <F12>     <ESC>:write<CR>a

imap          <Tab>     <C-R>=TabComp()<CR>
nmap <silent> ,,        :silent noh<CR>
" nmap <silent> ,c        :set cindent!<CR>
nmap <silent> ,i        :set ignorecase!<CR>
nmap <silent> ,n        :set number!<CR>

nmap          ,e        :e <C-R>=expand("%:p:h") . "/" <CR>
nmap          ,v        :vsp <C-R>=expand("%:p:h") . "/" <CR>
nmap          ,s        :sp <C-R>=expand("%:p:h") . "/" <CR>

nmap <silent> ,a        :w!<CR>:!aspell check %<CR>:e! %<CR>

nmap <silent> ,D        :call Gitdiff()<CR>
nmap <silent> ,d        :call Gitdiff2()<CR>

nmap           Y        y$

" I don't lick Ctrl-W mode... let's use alt insted
map           <M-j>    <C-W>j
map           <M-k>    <C-W>k
map           <M-h>    <C-W>h
map           <M-l>    <C-W>l
map           <M-c>    <C-W>c
map           <M-n>    <C-W>n
map           <M-s>    <C-W>s
map           <M-v>    <C-W>v
map           <M-o>    :only!
nmap          <M-+>    <C-W>+
nmap          <M-->    <C-W>-
nmap          <M->>    <C-W>>
nmap          <M-<>    <C-W><
nmap          <M-_>    <C-W>_
nmap          <M-=>    <C-W>=

map           <M-e>    :Se<CR>:set nonumber<CR>

nmap          {        [{
nmap          }        ]}
nmap          <C-S-k>  [{
nmap          <C-S-j>  ]}

" While I wait for vim7...
omap          i"       :normal  vT"ot"<CR>
omap          a"       :normal  vF"of"<CR>
omap          i'       :normal  vT'ot'<CR>
omap          a'       :normal  vF'of'<CR>
" }}}
" Explorer config{{{
let g:explVertical=1
let g:miniBufExplMaxSize=1
let g:explSplitLeft=1
let g:explSplitBelow=1
let g:netrw_altv=1
" }}}
" Plugin MiniBufferExplorer {{{
   if exists('g:minibufexplorer')
       nmap <silent> ,b     \mbt<CR>
       nmap <silent> ,B     :MiniBufExplorer<CR>
   endif
" }}}
" Plugin TagList {{{
if exists('loaded_taglist')
   nmap <silent> ,t     :Tlist<CR>
endif
" }}}

"Reload .vimrc after editing
autocmd! bufwritepost .vimrc source ~/.vimrc

"Removing trailing spaces al pedo
autocmd BufWritePre * :%s/\s\+$//e

" http://blog.fluther.com/blog/2008/10/17/django-vim/
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

"TracVim plugin
"let g:tracServerList = {}
"let g:tracServerList['(Server Name)'] = 'http://(user):(password)@(trac serverpath)/login/xmlrpc'
"let g:tracServerList['La Diaria - Trac'] = 'http://alvaro@trac.ladiaria.webfactional.com/login/xmlrpc'

" http://svn.python.org/projects/python/trunk/Misc/Vim/vimrc
" vimrc file for following the coding standards specified in PEP 7 & 8.
"
" All setting are protected by 'au' ('autocmd') statements.  Only files ending
" in .py or .pyw will trigger the Python settings.
"
" Only basic settings needed to enforce the style guidelines are set.
" Some suggested options are listed but commented out at the end of this file.

" Number of spaces that a pre-existing tab is equal to.
" For the amount of space used for a new tab use shiftwidth.
au FileType python set tabstop=8

" What to use for an indent.
" This will affect Ctrl-T and 'autoindent'.
" Python: 4 spaces
" au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
" au BufRead,BufNewFile *.py,*.pyw set expandtab

" Use the below highlight group when displaying bad whitespace is desired.
au FileType python highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au FileType python match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au FileType python match BadWhitespace /\s\+$/

" Wrap text after a certain number of characters
" au FileType python set textwidth=79

au FileType python highlight OverLength ctermbg=red ctermfg=white guibg=#592929
au FileType python match OverLength /\%81v.*/

" Use UNIX (\n) line endings.
" Only used for new files so as to not force existing files to change their
" line endings.
set fileformat=unix

" ----------------------------------------------------------------------------
" The following section contains suggested settings.  While in no way required
" to meet coding standards, they are helpful.

" Set the default file encoding to UTF-8:
set encoding=utf-8

" Puts a marker at the beginning of the file to differentiate between UTF and
" UCS encoding (WARNING: can trick shells into thinking a text file is actually
" a binary file when executing the text file): ``set bomb``

" For full syntax highlighting:
let python_highlight_all=1
" syntax on

" Automatically indent based on file type:
filetype indent on
" Keep indentation level from previous line:
set autoindent

" Folding based on indentation:
" set foldmethod=indent

" http://www.vim.org/scripts/script.php?script_id=1494
" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
map <buffer> gd /def <C-R><C-W><CR>

set foldmethod=expr
set foldexpr=PythonFoldExpr(v:lnum)
set foldtext=PythonFoldText()

map <buffer> f za
map <buffer> F :call ToggleFold()<CR>
let b:folded = 1

function! ToggleFold()
    if( b:folded == 0 )
        exec "normal! zM"
        let b:folded = 1
    else
        exec "normal! zR"
        let b:folded = 0
    endif
endfunction

function! PythonFoldText()

    let size = 1 + v:foldend - v:foldstart
    if size < 10
        let size = " " . size
    endif
    if size < 100
        let size = " " . size
    endif
    if size < 1000
        let size = " " . size
    endif

    if match(getline(v:foldstart), '"""') >= 0
        let text = substitute(getline(v:foldstart), '"""', '', 'g' ) . ' '
    elseif match(getline(v:foldstart), "'''") >= 0
        let text = substitute(getline(v:foldstart), "'''", '', 'g' ) . ' '
    else
        let text = getline(v:foldstart)
    endif

    return size . ' lines:'. text . ' '

endfunction

function! PythonFoldExpr(lnum)

    if indent( nextnonblank(a:lnum) ) == 0
        return 0
    endif

    if getline(a:lnum-1) =~ '^\(class\|def\)\s'
        return 1
    endif

    if getline(a:lnum) =~ '^\s*$'
        return "="
    endif

    if indent(a:lnum) == 0
        return 0
    endif

    return '='

endfunction

" In case folding breaks down
function! ReFold()
    set foldmethod=expr
    set foldexpr=0
    set foldnestmax=1
    set foldmethod=expr
    set foldexpr=PythonFoldExpr(v:lnum)
    set foldtext=PythonFoldText()
    echo
endfunction

"NERDCommenter
let mapleader = ","

" http://vim.wikia.com/wiki/Improved_Hex_editing
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
