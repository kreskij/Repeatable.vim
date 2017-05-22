"=============================================================================
" File:        autoload/repeatable.vim {{{
" Author:      Jason Kreski <kreskij {at} gmail {dot} com>
" License:     MIT license
" Description: Autoloaded functions vim-repeatable
"}}}
"=============================================================================
let s:save_cpoptions = &cpoptions
set cpoptions&vim
set cpoptions-=b
set cpoptions-=B
let s:script_path = fnamemodify(resolve(expand('<sfile>')),':h')
" Guard
if exists('g:loaded_repeatable_autoload') | finish | endif
let g:loaded_repeatabe_autoload = 1
let g:repeatable_run_test = 0  " Set to 1 to source the test file

"==============================================================================
" repeatable#Setup(): 
"==============================================================================
function! repeatable#Setup() "{{{
  let s:repeat_mapping_cnt = 1
  " Define the Repeatable command
  command! -nargs=* Repeatable call repeatable#Run(<q-args>) 
  if g:repeatable_run_test ==# 1 " Test?
    execute 'source ' . fnamemodify(s:script_path, ':h') . '/test/' . 'test.vim'
  endif
endfunction "}}}

"==============================================================================
" repeatable#Run(): 
"==============================================================================
function! repeatable#Run(mapping) "{{{
  if ! exists('g:repeatable_mapping_cpo_lt')
    let g:repeatable_mapping_cpo_lt = {}
  endif

  "------------------------------------------------------------------------
  " Get the full command arguments
  "------------------------------------------------------------------------
  let l:mapping = a:mapping
  let l:mapping = substitute(l:mapping,'\v^\s*','','') " ltrim
  let l:bar_idx = match(l:mapping,'\v[^\\]\|') " match a '|' but not '\|', or=-1
  let l:mapping = l:mapping[0:l:bar_idx] " rtrim at '|', wont trim if -1 

  "------------------------------------------------------------------------
  " Get the cpoptions '<' value
  "------------------------------------------------------------------------
  let l:cpoptions_lt = strridx(&cpoptions, '<')
  let l:cpoptions_has_lt = 0
  if l:cpoptions_lt > 0
    let l:cpoptions_has_lt = 1
  endif

  "------------------------------------------------------------------------
  " Get the type of mapping 'vmap, nmap, nnoremap, etc'
  "------------------------------------------------------------------------
  let l:mapping_type = matchstr(l:mapping, '\v^\w+')

  "------------------------------------------------------------------------
  " Get the mapping type as recursive
  "------------------------------------------------------------------------
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
  "call repeatable#DebugVars('l:', l:, 'mapping_type_recursive')

  "------------------------------------------------------------------------
  " Get the mapping type as non-recursive
  "------------------------------------------------------------------------
  let l:mtnr = l:mapping_type
  let l:mtr = substitute(l:mtr, '\v^((map)|(no)).*', 'noremap', '')
  let l:mtr = substitute(l:mtr, '\v^((nm)|(nn)).*', 'nnoremap', '')
  let l:mtr = substitute(l:mtr, '\v^((vm)|(vn)).*', 'vnoremap', '')
  let l:mtr = substitute(l:mtr, '\v^((xm)|(xn)).*', 'xnoremap', '')
  let l:mtr = substitute(l:mtr, '\v^((smap)|(snor)).*', 'snoremap', '')
  let l:mtr = substitute(l:mtr, '\v^((om)|(ono)).*', 'onoremap', '')
  let l:mtr = substitute(l:mtr, '\v^((im)|(ino)).*', 'inoremap', '')
  let l:mtr = substitute(l:mtr, '\v^((lm)|(ln)).*', 'lnoremap', '')
  let l:mtr = substitute(l:mtr, '\v^((cm)|(cno)).*', 'cnoremap', '')
  let l:mtr = substitute(l:mtr, '\v^((tm)|(tno)).*', 'tnoremap', '')
  let l:mapping_type_non_recursive = l:mtnr
  "call repeatable#DebugVars('l:', l:, 'mapping_type_non_recursive')

  "------------------------------------------------------------------------
  " Is Mapping Type recursive
  "------------------------------------------------------------------------
  if l:mapping_type ==# l:mapping_type_recursive
    let l:mapping_type_is_recursive = 1
  elseif l:mapping_type ==# l:mapping_type_non_recursive
    let l:mapping_type_is_recursive = 0
  endif

  "------------------------------------------------------------------------
  " Get the mapping args (<buffer>, <silent>, <special>, ...etc)
  "------------------------------------------------------------------------
  let l:ma = substitute(l:mapping, '\v^\w+', '', '') " Remove the mapping type
  let l:regex = 'buffer|nowait|silent|special|script|expr|unique'
  let l:regex = '\<\c(' . l:regex . ')\>' " \c is ignorecase
  let l:regex = '\s*' . l:regex . '\s*'
  let l:regex = '\v^(' . l:regex . ')*'
  let l:ma = matchstr(l:ma, l:regex)
  let l:ma = substitute(l:ma,'\v^\s*(.{-})\s*$','\1','') " trim
  let l:mapping_args = l:ma
  let l:isexpr = 0
  let l:issilent = 0
  let l:isspecial = 0
  let l:isexpr = (match(l:mapping_args, '\v\<\c(expr)\>') > -1) ? 1 : 0
  let l:issilent = (match(l:mapping_args, '\v\<\c(silent)\>') > -1) ? 1 : 0
  let l:isspecial = (match(l:mapping_args, '\v\<\c(special)\>') > -1) ? 1 : 0
  let l:isscript = (match(l:mapping_args, '\v\<\c(script)\>') > -1) ? 1 : 0
  "call repeatable#DebugVars('l:', l:, 'mapping_args', 'l:isexpr', 'l:issilent')

  "------------------------------------------------------------------------
  " Get the LHS+RHS
  "------------------------------------------------------------------------
  let l:lhsrhs = substitute(l:mapping, '\v^\w+', '', '') " Remove the mapping type
  let l:lhsrhs = substitute(l:lhsrhs, l:regex, '', '') " Remove the mapping args
  let l:lhsrhs = substitute(l:lhsrhs,'\v^\s*','','') " ltrim
  "call repeatable#DebugVars('l:', l:, 'lhsrhs')

  "------------------------------------------------------------------------
  " Get the LHS from LHS+RHS
  "------------------------------------------------------------------------
  let l:lhs = matchstr(l:lhsrhs, '\v^\S+\s')
  let l:lhs = substitute(l:lhs,'\v\s$','','') " remove trailing separator space
  "call repeatable#DebugVars('l:', l:, 'lhs')

  "------------------------------------------------------------------------
  " Get the RHS from LHS+RHS
  "------------------------------------------------------------------------
  let l:rhs_start = matchend(l:lhsrhs, '\v^\S+\s')
  let l:rhs = l:lhsrhs[l:rhs_start : -1]
  "call repeatable#DebugVars('l:', l:, 'rhs')

  "------------------------------------------------------------------------
  " Names for the <Plug> mappings to create
  "------------------------------------------------------------------------
  let s:repeat_mapping_cnt = (get(s:, 'repeat_mapping_cnt', 0) + 1)
  let l:plug_map_name = '<Plug>(repeatable-mapping-' . s:repeat_mapping_cnt . '-full)'
  let l:plug_map_name_l = '<Plug>(repeatable-mapping-' . s:repeat_mapping_cnt . '-left)'
  let l:plug_map_name_r = '<Plug>(repeatable-mapping-' . s:repeat_mapping_cnt . '-right)'
  "call repeatable#DebugVars('l:', l:, 'plug_map_name', 'plug_map_name_l', 'plug_map_name_r')
  "call repeatable#DebugVars('l:', l:, 'cpoptions_has_lt')

  "----------------------------------------------------------
  " {<Plug>(repeatable-mapping-#-left)} -> {RHS} mapping
  "----------------------------------------------------------
  let l:plug_mapping_l_args = ' '
  " Add <silent> if present
  if l:issilent ==# 1
    let l:plug_mapping_l_args .= '<silent>'
  endif
  " Add <expr> if present
  if l:isexpr ==# 1
    let l:plug_mapping_l_args .= '<expr>'
  endif
  if l:isscript ==# 1
    let l:plug_mapping_l_args .= '<script>'
  endif

  let l:plug_mapping_l_rhs = l:rhs

  " If cpoptions has '<'
  if l:cpoptions_has_lt
    let l:plug_mapping_l_args .= '<special>'
  endif
  " If cpoptions has '<' and not <special
  if l:cpoptions_has_lt && ! l:isspecial
    if l:issilent ==# 0
      let l:plug_mapping_l_args .= '<silent>'
    endif
    if l:mapping_type_is_recursive ==# 1
      let l:norm = 'norm'
    else
      let l:norm = 'norm!'
    endif
    let g:repeatable_mapping_cpo_lt[string(s:repeat_mapping_cnt)] = l:norm . ' ' . l:rhs
    let l:cpo_lt_idx = 'g:repeatable_mapping_cpo_lt["'.string(s:repeat_mapping_cnt).'"]'
    let l:plug_mapping_l_rhs = '<Esc>:execute ' . l:cpo_lt_idx . '<CR>'
    "call repeatable#DebugVars('g:', g:, 'repeatable_mapping_cpo_lt')
  endif

  if l:plug_mapping_l_args !=# ' ' " Fix spaces
    let l:plug_mapping_l_args .= ' '
  endif
  let l:plug_mapping_l = l:mapping_type
  let l:plug_mapping_l .= l:plug_mapping_l_args
  let l:plug_mapping_l .= l:plug_map_name_l . ' '
  let l:plug_mapping_l .= l:plug_mapping_l_rhs
  "call repeatable#DebugVars('l:', l:, 'plug_mapping_l')

  "----------------------------------------------------------
  " {<Plug>(repeatable-mapping-#-right)} -> {REPEAT COMMAND}
  "----------------------------------------------------------
  let l:plug_mapping_r = l:mapping_type_non_recursive . ' '
  " Add <special> to prevent cpoptions+=< from breaking the mapping
  let l:plug_mapping_r .= '<silent><special> '
  let l:plug_mapping_r .= l:plug_map_name_r . ' '
  "let l:plug_mapping_r .= '<Esc>:silent! call repeat#set("\' . l:plug_map_name . '")<CR>'
  let l:plug_mapping_r .= '<Esc>:call repeatable#Set("\' . l:plug_map_name . '")<CR>'
  "call repeatable#DebugVars('l:', l:, 'plug_mapping_r')

  "-----------------------------------------------------------------------------
  " {<Plug>(repeatable-mapping-#-full)} -> 
  "   {<Plug>(repeatable-mapping-#-left)}{<Plug>(repeatable-mapping-#-right)}
  "-----------------------------------------------------------------------------
  let l:plug_mapping_full = ''
  let l:plug_mapping_full .= l:mapping_type_recursive . ' '
  " Ignore cpoptions+=<  with <special> ('<' option disables special keys such
  " as <Plug>, the angle brackets are interpretted literally with '<')
  let l:plug_mapping_full .= '<special>' . ' '
  let l:plug_mapping_full .= l:plug_map_name . ' '
  let l:plug_mapping_full .= l:plug_map_name_l
  let l:plug_mapping_full .= l:plug_map_name_r
  "call repeatable#DebugVars('l:', l:, 'plug_mapping_full')

  "-----------------------------------------------------------------------------
  " {LHS} -> {<Plug>(repeatable-mapping-#-full)} mapping
  "-----------------------------------------------------------------------------
  " <args>
  let l:to_plug_mapping_args = l:mapping_args
  " Remove the <expr>
  if l:isexpr ==# 1
    let l:to_plug_mapping_args = substitute(l:to_plug_mapping_args, '\v\s*\<expr\>\s*', '', 'g')
  endif
  " Remove the <silent>
  if l:issilent ==# 1
    let l:to_plug_mapping_args = substitute(l:to_plug_mapping_args, '\v\s*\<silent\>\s*', '', 'g')
  endif
  if l:isscript ==# 1
    let l:to_plug_mapping_args = substitute(l:to_plug_mapping_args, '\v\s*\<script\>\s*', '', 'g')
  endif

  " If cpoptions+=< and no <special> arg is present, the mapping {RHS}
  " must be escaped
  let l:to_plug_mapping_type = l:mapping_type_recursive
  let l:plug_map_name_esc = l:plug_map_name
  if l:cpoptions_has_lt && ! l:isspecial
    let l:to_plug_mapping_args .= '<silent>'
    let l:to_plug_mapping_type = l:mapping_type_non_recursive
    let l:plug_map_name_esc = ':execute "norm \' . l:plug_map_name . '"' . '' 
  endif

  " Fix spaces around args or the lack thereof
  if l:to_plug_mapping_args !=# ''
    let l:to_plug_mapping_args .= ' '
  endif

  let l:to_plug_mapping = ''
  let l:to_plug_mapping .= l:to_plug_mapping_type . ' '
  let l:to_plug_mapping .= l:to_plug_mapping_args
  let l:to_plug_mapping .= l:lhs . ' '
  let l:to_plug_mapping .= l:plug_map_name_esc

  "call repeatable#DebugVars('l:', l:, 'to_plug_mapping')
  "call repeatable#Debug('-----------------------------------------------')

  "-----------------------------------------------------------------------------
  " Create the 4 mappings needed
  "-----------------------------------------------------------------------------
  execute l:plug_mapping_l
  execute l:plug_mapping_r
  execute l:plug_mapping_full
  execute l:to_plug_mapping

endfunction "}}}

"==============================================================================
" repeatable#Set(): 
"==============================================================================
function! repeatable#Set(mapping) "{{{
  try
    call repeat#set(a:mapping)
  catch /E117.*/
    echohl Error
    echon 'Repeatable.vim: function repeat#set() not found. Repeatable.vim depends on repeat.vim (tpope/vim-repeat)'
    echohl Normal
  endtry
endfunction "}}}

"==============================================================================
" repeatable#DebugVars(): 
"==============================================================================
function! repeatable#DebugVars(scopename, scope, ...) "{{{
  if g:repeatable_run_test ==# 1
    if a:0 ==# 1
      echohl ModeMsg
      echom a:scopename . a:1
      echohl Normal 
      if type(a:scope[a:1]) ==# 1 " String
        echom a:scope[a:1]
      else
        echom string(a:scope[a:1])
      endif
    else
      let l:title = ''
      for l:i in a:000
        let l:title .= a:scopename . l:i . ' '
      endfor
      echohl ModeMsg
      echom l:title
      echohl Normal 
      for l:i in a:000
        if type(a:scope[l:i]) ==# 1 " String
          echom a:scope[l:i]
        else
          echom string(a:scope[l:i])
        endif
      endfor
    endif
  endif
endfunction "}}}
"==============================================================================
" repeatable#Debug(): 
"==============================================================================
function! repeatable#Debug(str) "{{{
  if g:repeatable_run_test ==# 1
    echom a:str
  endif
endfunction "}}}


let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
