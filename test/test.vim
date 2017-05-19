"-------------------------------------------------------------------------------
" BASIC SCENARIOS
"-------------------------------------------------------------------------------
" NONE
" <buffer>  - Buffer local mapping

" <nowait>  - Fire immediately, even if part of another mapping

" <silent>  - Don't show any :Ex input used in the mapping

" <special> -  Define a mapping with <> notation for special keys, even though
            " the "<" flag may appear in 'cpoptions'.  This is useful if the 
            " side effect of setting 'cpoptions' is not desired.  Example: >
            " :map <special> <F12> /Header<CR>

" <script>  - If the first argument to one of these commands is "<script>" and
            " it is used to define a new mapping or abbreviation, the mapping
            " will only remap characters in the {rhs} using mappings that were
            " defined local to a script, starting with "<SID>".  This can be
            " used to avoid that mappings from outside a script interfere
            " (e.g., when CTRL-V is remapped in mswin.vim), but do use other
            " mappings defined in the script. Note: ":map <script>" and
            " ":noremap <script>" do the same thing.  The <script>" overrules
            " the command name.  Using ":noremap <script>" is preferred,
            " because it's clearer that remapping is (mostly) disabled.
" <expr>    - If the first argument to one of these commands is "<expr>" and
            " it is used to define a new mapping or abbreviation, the argument
            " is an expression.  The expression is evaluated to obtain the
            " {rhs} that is used.  Example: > :inoremap <expr> . InsertDot()
" <unique>  -  If the first argument to one of these commands is "<unique>" and
            " it is used to define a new mapping or abbreviation, the command
            " will fail if the mapping or abbreviation already exists. 
            " Example: > :map <unique> ,w  /[#&!]<CR>
            " When defining a local mapping, there will also be a check if a
            " global map already exists which is equal. 
            " Example of what will fail: >
            " :map ,w  /[#&!]<CR>
            " :map <buffer> <unique> ,w  /[.,;]<CR>
            " If you want to map a key and then have it do what it was
            " originally mapped to, have a look at |maparg()|.
" <C-R>=    - Expression register
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" COMBINATIONS
"-------------------------------------------------------------------------------
" <expr> <buffer>
" <buffer> <expr>
"-------------------------------------------------------------------------------

augroup RepeatableTest
  autocmd!
augroup END

function! g:RepeatableTest()
   
  "-------------------
  " NONE (PASS)
  "-------------------
  "Repeatable nnoremap ab dd

  "-------------------
  " <buffer>  (PASS)
  "-------------------
  "Repeatable nnoremap <buffer> ac dd

  "-------------------
  " <nowait>  (PASS)
  "-------------------
  " 'add' shouldn't work
  "Repeatable nnoremap add j
  "Repeatable nnoremap <nowait> ad dd
  " 'aee' should work
  "Repeatable nnoremap aee j
  "Repeatable nnoremap ae dd

  "-------------------
  " <silent>
  "-------------------
  " Should not appear in :Ex
  "Repeatable nnoremap <silent> af :sleep 2<CR>
  " Should appear in :Ex
  "Repeatable nnoremap ag :sleep 2<CR>
  let g:repeatable_test_mode = 1
  setlocal cpoptions+=<
  "Repeatable nnoremap <F12> :sleep 2<CR>
  "Repeatable nnoremap ah :echom "test"
  Repeatable nnoremap ah :echom 'test'
  "Repeatable nnoremap ah jjj
  setlocal cpoptions-=<

  "-------------------
  " <special>
  "-------------------
  "let g:repeatable_test_mode = 1
  "set cpoptions+=<
  "Repeatable nnoremap <F12> :echom 'test'<CR>
  "set cpoptions-=<

  "-------------------
  " <script>
  "-------------------

  "-------------------
  " <expr>
  "-------------------

  "-------------------
  " <unique>
  "-------------------

  "-------------------
  " <C-R>=
  "-------------------


  "Repeatable nnoremap <expr><buffer> ad 'dd'
  let g:repeatable_test_mode = 0
endfunction


autocmd RepeatableTest BufEnter test.vim call g:RepeatableTest()

