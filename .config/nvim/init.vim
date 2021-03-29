call plug#begin('~/.config/nvim/plugged')
Plug 'dkarter/bullets.vim'
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" source $HOME/.config/nvim/config/cocbinds.vimrc

let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]

set autoindent
set smartindent

set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set number 
set ignorecase
set smartcase
syntax on 

map <C-n> :NERDTreeToggle<CR>

" Word swap https://stackoverflow.com/questions/3578549/easiest-way-to-swap-occurrences-of-two-strings-in-vim

function! Mirror(dict)
    for [key, value] in items(a:dict)
        let a:dict[value] = key
    endfor
    return a:dict
endfunction

function! S(number)
    return submatch(a:number)
endfunction

function! SwapWords(dict, ...)
    let words = keys(a:dict) + values(a:dict)
    let words = map(words, 'escape(v:val, "|")')
    if(a:0 == 1)
        let delimiter = a:1
    else
        let delimiter = '/'
    endif
    let pattern = '\v(' . join(words, '|') . ')'
    exe '%s' . delimiter . pattern . delimiter
        \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
        \ . delimiter . 'g'
endfunction

