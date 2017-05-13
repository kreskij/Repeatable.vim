"=============================================================================
" File:        autoload/repeatable.vim {{{
" Author:      Jason Kreski <kreskij {at} gmail {dot} com>
" License:     MIT license
" Description: Autoloaded functions vim-repeatable
"}}}
"=============================================================================
let s:save_cpo = &cpoptions
set cpoptions&vim

"-------------------------------------------------------------------------------
" repeatable#Setup(): 
"-------------------------------------------------------------------------------
function! repeatable#Setup() "{{{
  let s:repeat_mapping_cnt = 1
  command! -nargs=* Repeatable call repeatable#Run(<q-args>) 
endfunction "}}}

"-------------------------------------------------------------------------------
" repeatable#Run(): 
"-------------------------------------------------------------------------------
function! repeatable#Run(mapping) "{{{
  " Get the full command arguments
  let l:mapping = a:mapping
  let l:mapping = substitute(l:mapping,'\v^\s*','','') " ltrim
  let l:bar_idx = match(l:mapping,'\v[^\\]\|') " match a '|' but not '\|', or=-1
  let l:mapping = l:mapping[0:l:bar_idx] " rtrim at '|', wont trim if -1 
  " Get the type of mapping 'vmap, nmap, nnoremap, etc'
  let l:mapping_type = matchstr(l:mapping, '\v^\w+')
  " Get the mapping type as recursive
  let l:mtr = l:mapping_type
  let l:mtr = substitute(l:mtr, '\v^((map)|(no)).*', 'map', '')
  let l:mtr = substitute(l:mtr, '\v^((nm)|(nn)).*', 'nmap', '')
  let l:mtr = substitute(l:mtr, '\v^((vm)|(vn)).*', 'vmap', '')
  let l:mtr = substitute(l:mtr, '\v^((xm)|(xn)).*', 'xmap', '')
  let l:mtr = substitute(l:mtr, '\v^((smap)|(snor)).*', 'smap', '')
  let l:mtr = substitute(l:mtr, '\v^((om)|(ono)).*', 'omap', '')
  let l:mtr = substitute(l:mtr, '\v^((im)|(ino)).*', 'imap', '')
  let l:mtr = substitute(l:mtr, '\v^((lm)|(ln)).*', 'lmap', '')
  let l:mtr = substitute(l:mtr, '\v^((cm)|(cno)).*', 'cmap', '')
  let l:mtr = substitute(l:mtr, '\v^((tm)|(tno)).*', 'tmap', '')
  let l:mapping_type_recursive = l:mtr
  " Get the mapping args <silent>, <nowait>, etc
  let l:ma = substitute(l:mapping, '\v^\w+', '', '') " Remove the mapping type
  let l:regex = 'buffer|nowait|silent|special|script|expr|unique'
  let l:regex = '\<\c(' . l:regex . ')\>' " \c is ignorecase
  let l:regex =  '\s*' . l:regex . '\s*'
  let l:regex =  '\v^(' . l:regex . ')*'
  let l:ma = matchstr(l:ma, l:regex)
  let l:ma = substitute(l:ma,'\v^\s*(.{-})\s*$','\1','') " trim
  let l:mapping_args = l:ma
  " Get the LHS+RHS
  let l:lhsrhs = substitute(l:mapping, '\v^\w+', '', '') " Remove the mapping type
  let l:lhsrhs = substitute(l:lhsrhs, l:regex, '', '') " Remove the mapping args
  let l:lhsrhs = substitute(l:lhsrhs,'\v^\s*','','') " ltrim
  " Get the LHS from LHS+RHS
  let l:lhs = matchstr(l:lhsrhs, '\v^\S+\s')
  let l:lhs = substitute(l:lhs,'\v\s$','','') " remove trailing separator space
  " Get the RHS from LHS+RHS
  let l:rhs_start = matchend(l:lhsrhs, '\v^\S+\s')
  let l:rhs = l:lhsrhs[l:rhs_start : -1]
  " Name for the <Plug> mapping
  let s:repeat_mapping_cnt = (get(s:, 'repeat_mapping_cnt', 0) + 1)
  let l:plug_map_name = '<Plug>MyRepeatMapping' . s:repeat_mapping_cnt
  " The repeat command
  let l:repeat_cmd = '<Esc>:silent! call repeat#set("\' . l:plug_map_name . '")<CR>'
  " Check if <expr> mapping
  let l:isexpr = (match(l:mapping_args, '\v\<\c(expr)\>') > -1) ? 1 : 0
  if l:isexpr ==# 1
    let l:rhs = l:rhs .'.'. "'" . l:repeat_cmd . "'"
  endif
  " The :map <Plug>MyRepeatMapping# {RHS} command
  let l:plug_mapping = l:mapping_type . ' '
  let l:plug_mapping .= l:mapping_args . ' '
  let l:plug_mapping .= l:plug_map_name . ' '
  let l:plug_mapping .= l:rhs
  if l:isexpr ==# 0
    let l:plug_mapping .= l:repeat_cmd
  endif
  " The :map {LHS} <Plug>MyRepeatMapping# command
  let l:to_plug_mapping = l:mapping_type_recursive . ' '
  let l:to_plug_mapping .= l:lhs . ' '
  let l:to_plug_mapping .= l:plug_map_name
  "echom l:plug_mapping
  "echom l:to_plug_mapping
  execute l:plug_mapping
  execute l:to_plug_mapping
endfunction "}}}


let &cpoptions = s:save_cpo
unlet s:save_cpo
