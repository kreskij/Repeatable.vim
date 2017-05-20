let g:repeatable_test_enable = 1

"------------------------------------------------------------------------------
" COMBINATIONS
"-------------------------------------------------------------------------------

augroup RepeatableTest
  autocmd!
augroup END

function! g:RepeatableTest()
   
  "{{{ NONE
  "--------------------------------------------------------------------
  " NONE (PASS)
  "--------------------------------------------------------------------
  Repeatable nnoremap aaa H
  Repeatable nmap aab H
  "}}}

  "{{{ <buffer>
  "--------------------------------------------------------------------
  " <buffer>  (PASS)
  "--------------------------------------------------------------------
  Repeatable nnoremap <buffer> aba H
  Repeatable nmap <buffer> abb H
  "}}}

  " <nowait> {{{
  "--------------------------------------------------------------------
  " <nowait><buffer>  (PASS)
  "--------------------------------------------------------------------
  " Note: <nowait> only applies to <buffer> mappings to not wait for global 
  " mappings
  " 'acaa' shouldn't be accessible
  Repeatable nnoremap <buffer><nowait> aca dd
  Repeatable nnoremap acaa j
  "let g:repeatable_test_mode = 1
  Repeatable nnoremap <nowait><buffer> acb dd
  Repeatable nnoremap acba j
  "let g:repeatable_test_mode = 0
  " 'acbb' should be accessible
  Repeatable nnoremap <buffer> acc j
  Repeatable nnoremap acca dd
  "}}}

  "{{{ <silent>
  "--------------------------------------------------------------------
  " <silent> (PASS)
  "--------------------------------------------------------------------
  "let g:repeatable_test_mode = 1
  " Should not appear in :Ex
  Repeatable nnoremap <silent> ada :sleep 2<CR>
  " Should appear in :Ex
  Repeatable nnoremap adb :sleep 2<CR>
  "let g:repeatable_test_mode = 0
  "--------------------------------------------------------------------
  " <silent> with cpoptions+=< (FAIL)
  "--------------------------------------------------------------------
  set cpoptions+=<
  " Should work with F8 fn key
  Repeatable nnoremap <silent> adba :echom 'test'
  Repeatable nnoremap <silent> adbb :let g:abc=1
  set cpoptions-=<
  "}}}

  "{{{ <silent><buffer>
  "--------------------------------------------------------------------
  " <silent><buffer> (PASS)
  "--------------------------------------------------------------------
  " Should be not silent and not buffer local 
  Repeatable nnoremap adc :sleep 2<CR>
  " Should be silent and not buffer local 
  Repeatable nnoremap <silent> add :sleep 2<CR>
  " Should be buffer-local and not silent
  Repeatable nnoremap <buffer> ade :sleep 2<CR>
  " Should be buffer-local and silent
  Repeatable nnoremap <buffer><silent> adf :sleep 2<CR>
  " Should be buffer-local and silent
  Repeatable nnoremap <silent><buffer> adg :sleep 2<CR>
  "}}}

  "{{{ <silent><buffer><nowait>
  "--------------------------------------------------------------------
  " <silent><buffer><nowait> (PASS)
  "--------------------------------------------------------------------
  Repeatable nnoremap <silent><buffer><nowait> adh :sleep 2<CR>
  Repeatable nnoremap adha :sleep 2<CR>
  Repeatable nnoremap <silent><nowait><buffer> adi :sleep 2<CR>
  Repeatable nnoremap adia :sleep 2<CR>
  Repeatable nnoremap <nowait><silent><buffer> adj :sleep 2<CR>
  Repeatable nnoremap adja :sleep 2<CR>
  Repeatable nnoremap <nowait><buffer><silent> adk :sleep 2<CR>
  Repeatable nnoremap adka :sleep 2<CR>
  Repeatable nnoremap <buffer><silent><nowait> adl :sleep 2<CR>
  Repeatable nnoremap adla :sleep 2<CR>
  Repeatable nnoremap <buffer><nowait><silent> adm :sleep 2<CR>
  Repeatable nnoremap adma :sleep 2<CR>
  " Should not be silent
  Repeatable nnoremap <buffer><nowait> adn :sleep 2<CR>
  "}}}

  let s:special_testno = 0
  "{{{ <special> 
  "--------------------------------------------------------------------
  " <special> with cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 1
  if s:special_testno ==# 1
    set cpoptions+=<
    " Should work with F8 fn key
    Repeatable nnoremap <special> <F8> :echom 'test'<CR>
    " Should not work with F8 fn key, must type literal <F9>
    Repeatable nnoremap <F9> :echom "test"
    set cpoptions-=<
  endif
  "--------------------------------------------------------------------
  " <special> without cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 2
  if s:special_testno ==# 2
    " <special> Should not matter
    Repeatable nnoremap <special> <F8> :echom 'test'<CR>
    Repeatable nnoremap <F9> :echom 'test'<CR>
  endif
  "}}}

  "{{{ <special><silent>
  "--------------------------------------------------------------------
  " <special> with cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  let s:special_testno = 3
  if s:special_testno ==# 3
    set cpoptions+=<
    " Should work with F8 fn key
    Repeatable nnoremap <silent> 333 :echom 'test'
    Repeatable nnoremap <silent> 334 :let g:abc=1
    set cpoptions-=<
  endif
  "--------------------------------------------------------------------
  " <special> without cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 4
  if s:special_testno ==# 4
    " <special> Should not matter
    Repeatable nnoremap <special> <F8> :echom 'test'<CR>
    Repeatable nnoremap <F9> :echom 'test'<CR>
  endif
  "}}}


  "{{{ <special><buffer>
  "--------------------------------------------------------------------
  " <special><buffer> with cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 5
  if s:special_testno ==# 5
    set cpoptions+=<
    " Should work with F8 fn key
    Repeatable nnoremap <special><buffer> <F8> :echom 'test'<CR>
    " Should not work with F8 fn key, must type literal <F9>
    Repeatable nnoremap <buffer> <F9> :echom "test"
    set cpoptions-=<
  endif
  "--------------------------------------------------------------------
  " <special><buffer> without cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 6
  if s:special_testno ==# 6
    " <special> Should not matter
    Repeatable nnoremap <special><buffer> <F8> :echom 'test'<CR>
    Repeatable nnoremap <buffer> <F9> :echom 'test'<CR>
  endif
  "--------------------------------------------------------------------
  " <buffer><special> with cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 7
  if s:special_testno ==# 7
    set cpoptions+=<
    " Should work with F8 fn key
    Repeatable nnoremap <buffer><special> <F8> :echom 'test'<CR>
    " Should not work with F8 fn key, must type literal <F9>
    Repeatable nnoremap <buffer> <F9> :echom "test"
    set cpoptions-=<
  endif
  "--------------------------------------------------------------------
  " <buffer><special> without cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 8
  if s:special_testno ==# 8
    " <special> Should not matter
    Repeatable nnoremap <buffer><special> <F8> :echom 'test'<CR>
    Repeatable nnoremap <buffer> <F9> :echom 'test'<CR>
  endif
  "}}}

  "{{{ <special><buffer><nowait>
  "--------------------------------------------------------------------
  " <special><buffer><nowait> with cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 9
  if s:special_testno ==# 9
    set cpoptions+=<
    " Should work with F8 fn key
    " Should not have to wait timeoutlen
    Repeatable nnoremap <special><buffer><nowait> <F8> :echom 'test'<CR>
    Repeatable nnoremap <special> <F8>a :echom 'test'<CR>
    " Should not work with F8 fn key, must type literal <F9>
    Repeatable nnoremap <buffer><nowait> <F9> :echom "test"
    " Should not have to wait timeoutlen
    Repeatable nnoremap <F9>a :echom "test"
    set cpoptions-=<
  endif
  "--------------------------------------------------------------------
  " <special><buffer><nowait> without cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 10 
  if s:special_testno ==# 10
    " <special> Should not matter
    " Should not have to wait timeoutlen
    Repeatable nnoremap <special><buffer><nowait> <F8> :echom 'test'<CR>
    Repeatable nnoremap <special> <F8>a :echom 'test'<CR>
    Repeatable nnoremap <buffer><nowait> <F9> :echom 'test'<CR>
    Repeatable nnoremap <F9>a :echom 'test'<CR>
  endif
  "--------------------------------------------------------------------
  " <buffer><nowait><special> with cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 11
  if s:special_testno ==# 11
    set cpoptions+=<
    " Should work with F8 fn key
    Repeatable nnoremap <buffer><nowait><special> <F8> :echom 'test'<CR>
    Repeatable nnoremap <special> <F8>a :echom 'test'<CR>
    " Should not work with F8 fn key, must type literal <F9>
    Repeatable nnoremap <buffer><nowait> <F9> :echom "test"
    Repeatable nnoremap <F9>a :echom "test"
    set cpoptions-=<
  endif
  "--------------------------------------------------------------------
  " <buffer><nowait><special> without cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 12
  if s:special_testno ==# 12
    " <special> Should not matter
    Repeatable nnoremap <buffer><nowait><special> <F8> :echom 'test'<CR>
    Repeatable nnoremap <special> <F8>a :echom 'test'<CR>
    Repeatable nnoremap <buffer><nowait> <F9> :echom 'test'<CR>
    Repeatable nnoremap <F9>a :echom 'test'<CR>
  endif
  "--------------------------------------------------------------------
  " <nowait><special><buffer> with cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 13 
  if s:special_testno ==# 13
    set cpoptions+=<
    " Should work with F8 fn key
    Repeatable nnoremap <nowait><special><buffer> <F8> :echom 'test'<CR>
    Repeatable nnoremap <special> <F8>a :echom 'test'<CR>
    " Should not work with F8 fn key, must type literal <F9>
    Repeatable nnoremap <nowait><buffer> <F9> :echom "test"
    Repeatable nnoremap <F9>a :echom "test"
    set cpoptions-=<
  endif
  "--------------------------------------------------------------------
  " <nowait><special><buffer> without cpoptions+=< (PASS)
  "--------------------------------------------------------------------
  "let s:special_testno = 14
  if s:special_testno ==# 14
    " <special> Should not matter
    Repeatable nnoremap <nowait><special><buffer> <F8> :echom 'test'<CR>
    Repeatable nnoremap <special> <F8>a :echom 'test'<CR>
    Repeatable nnoremap <nowait><buffer> <F9> :echom 'test'<CR>
    Repeatable nnoremap <F9>a :echom 'test'<CR>
  endif
  "}}}

  "--------------------------------------------------------------------
  " <script> (PASS)
  "--------------------------------------------------------------------
  Repeatable noremap <SID>(ScriptMap) :echom 'test'<CR>
  Repeatable nmap <script> aeb <SID>(ScriptMap)H


  "--------------------------------------------------------------------
  " <expr> (PASS)
  "--------------------------------------------------------------------
  Repeatable nnoremap <expr> afa "H"
  Repeatable nmap <expr> afb "H"

  "--------------------------------------------------------------------
  " <unique> (PASS)
  "--------------------------------------------------------------------
  Repeatable nnoremap <unique> aga H
  "Repeatable nnoremap <unique> aga H

  "--------------------------------------------------------------------
  " <C-R>= (PASS)
  "--------------------------------------------------------------------
  let g:repeatable_test_mode = 1
  Repeatable nnoremap aha i<C-R>=toupper('h')<CR><Esc>
  let g:repeatable_test_mode = 0

  "Repeatable nnoremap <expr><buffer> ad 'dd'
  let g:repeatable_test_mode = 0
endfunction


autocmd RepeatableTest BufEnter test.vim call g:RepeatableTest()

