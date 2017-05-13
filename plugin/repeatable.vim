"=============================================================================
" File:        plugin/Repeatable.vim {{{
" Author:      Jason Kreski <kreskij {at} gmail {dot} com>
" License:     MIT license
" Description: User-friendly 'Repeatable' command for repeat.vim
"}}}
"=============================================================================
" Guard, save_cpo {{{
if exists('g:loaded_vim_repeatable')
  finish
endif
let g:loaded_vim_repeatable = 1
let s:save_cpo = &cpoptions
set cpoptions&vim
"}}}

" Autoloaded to allow the user to either call the #Setup manually,
" or use On-Demand loading via their plugin manager.
if ! exists(':Repeatable')
  call repeatable#Setup()
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo
