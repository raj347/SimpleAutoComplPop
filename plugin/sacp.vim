

let g:sacpEnable = get(g:,'sacpEnable',1)
if g:sacpEnable == 0
	finish
endif

inoremap <expr> <silent> <Plug>(sacp_cache_fuzzy_omnicomplete)  sacp#setupCacheFuzzyOmniComplete()."\<C-X>\<C-O>"

let s:sacpDefaultFileTypesEnable = { "php":1, "markdown":1, "text":1, "go":1}
let g:sacpDefaultFileTypesEnable = get(g:,'sacpDefaultFileTypesEnable',s:sacpDefaultFileTypesEnable)

" php
if get(g:sacpDefaultFileTypesEnable,'php',0) == 1

	" TODO auto filename completion pop up, for './'  '/' '../'
	autocmd FileType php,php5,php7 call sacp#enableForThisBuffer({ "matches": [
				\ { '=~': '\v[a-zA-Z]{4}$', 'feedkeys': "\<C-x>\<C-o>"},
				\ { '=~': '::$'           , 'feedkeys': "\<C-x>\<C-o>"},
				\ { '=~': '->$'           , 'feedkeys': "\<C-x>\<C-o>"},
				\ ]
				\ })

endif

" .md files
if get(g:sacpDefaultFileTypesEnable,'markdown',0) == 1

	autocmd FileType markdown call sacp#enableForThisBuffer({ "matches": [
				\ { '=~': '\v[a-zA-Z]{2}$', 'feedkeys': "\<C-x>\<C-n>"},
				\ ]
				\ })

endif

" .txt files
if get(g:sacpDefaultFileTypesEnable,'text',0) == 1

	autocmd FileType text call sacp#enableForThisBuffer({ "matches": [
				\ { '=~': '\v[a-zA-Z]{2}$', 'feedkeys': "\<C-x>\<C-n>"},
				\ ]
				\ })

endif

" golang
if get(g:sacpDefaultFileTypesEnable,'go',0) == 1

	" 1. variables are all defined in current scope, use keyword from current
	" buffer for completion `<C-x><C-n>`
	" 2. When the '.' is pressed, use smarter omnicomplete `<C-x><C-o>`, this
	" works well with the vim-go plugin
	autocmd FileType go call sacp#enableForThisBuffer({ "matches": [
				\ { '=~': '\v[a-zA-Z]{2}$' , 'feedkeys': "\<C-x>\<C-n>"} ,
				\ { '=~': '\.$'            , 'feedkeys': "\<C-x>\<C-o>", "ignoreCompletionMode":1} ,
				\ ]
				\ })

endif


