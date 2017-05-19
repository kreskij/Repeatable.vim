# Repeatable.vim

Repeatable.vim provides a simple interface to create mappings via tpope's 
[repeat.vim](https://github.com/tpope/vim-repeat).  Simply add 'Repeatable' in front of your mapping and it will be
repeatable.

#### This plugin allows you to go from this:

```vim
nnoremap <silent> <Plug>PasteBelowCursorEnd p`]
\:call repeat#set("\<Plug>PasteBelowCursorEnd")<CR>
nmap gp <Plug>PasteBelowCursorEnd
```

#### To this...

```vim
Repeatable nnoremap gp p`]
```

Many users install repeat.vim as a supplement to other plugins
however some may shy away from creating their own mappings due to its interface
being verbose or intimidating. This plugin reduces it down to one 'Repeatable'
command which you add as a prefix to your mapping. No need to mess with 
custom ```<Plug>``` mappings, Repeatable.vim will take care of that for you.


## Install


```vim
" Add the 'Repeatable' command to on-demand loading if your plugin
" supports it. If your plugin manager doesn't support on-demand loading, call
" the 'repeatable#Setup()' function before any use of the 'Repeatable' command

" Example using vim-plug and on-demand loading
Plug 'tpope/vim-repeat'
Plug 'Repeatable.vim', { 'on': 'Repeatable' }

" Example using vim-plug and without on-demand loading
Plug 'tpope/vim-repeat'
Plug 'Repeatable.vim'
call repeatable#Setup()

```

## Usage

Define mappings as you normally would and add ```Repeatable``` in front. 

This plugin works with ```<expr>``` mappings too.

## Examples

```vim
" Paste below/above and put cursor at the end of the paste
Repeatable nnoremap gp p`]
Repeatable nnoremap gP P`]

" Paste inside current line (overwrites line) (repeatable)
Repeatable nnoremap <expr> gpp '"_dd"'.v:register.'P'
```
