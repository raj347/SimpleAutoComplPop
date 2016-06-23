
" sacp enhanced omni complete
" cache omni list && fuzzy search complete menu

function! sacpomni#setup()

	" call sacp#writeLog('sacpomni#setup') " debug

	let b:sacpomniLFunc = &l:omnifunc
	let b:sacpomniFunc      = &omnifunc
	if b:sacpomniLFunc=="" && b:sacpomniFunc==""
		unlet b:sacpomniLFunc
		unlet b:sacpomniFunc
		call sacp#setCompleteDone()
		return ''
	endif

	let &l:omnifunc = 'sacpomni#complete'

	silent! unlet b:sacpomniCompleteCache
	let b:sacpomniCompleteStartColumn = 0
	let b:sacpomniInitialBase = ""

	augroup sacpomni
		autocmd InsertLeave,CompleteDone * call s:done()
	augroup END

	return "\<C-X>\<C-O>"

endfunction


function! s:done()

	" call sacp#writeLog('sacpomni#done') " debug

	" restore omni func, destroys variables
	silent! let &l:omnifunc = b:sacpomniLFunc
	silent! unlet b:sacpomniLFunc
	silent! unlet b:sacpomniFunc
	silent! unlet b:sacpomniCompleteStartColumn
	silent! unlet b:sacpomniCompleteCache

	" clear the group
	augroup sacpomni
		autocmd!
	augroup END

endfunction


" wrapped omni func
function! sacpomni#complete(findstart,base)

	" call sacp#writeLog("sacpomni#complete") " debug

	" first call
	if a:findstart == 1
		if b:sacpomniLFunc != ""
			let b:sacpomniCompleteStartColumn = call(b:sacpomniLFunc,[a:findstart,a:base])
		else
			let b:sacpomniCompleteStartColumn = call(b:sacpomniFunc,[a:findstart,a:base])
		endif
		return b:sacpomniCompleteStartColumn
	endif

	" read cached for complete
	if !exists('b:sacpomniCompleteCache')
		let b:sacpomniInitialBase = a:base
		if b:sacpomniLFunc != ""
			let l:ret = call(b:sacpomniLFunc,[a:findstart,a:base])
		else
			let l:ret = call(b:sacpomniFunc,[a:findstart,a:base])
		endif
		if type(l:ret)==3  " list
			let b:sacpomniCompleteCache = l:ret
		elseif type(l:ret)==4 " dict
			let b:sacpomniCompleteCache = l:ret.words
		else
			return l:ret
		endif
	endif

	let l:retlist = []
	let l:begin = len(b:sacpomniInitialBase)
	for l:w in b:sacpomniCompleteCache
		let l:m = g:WordMatchInfo(l:begin,a:base,l:w.word)
		if empty(l:m)
			" call sacp#writeLog("[" . l:w.word . "] does not match base:".a:base) " debug
			continue
		endif
		" call sacp#writeLog("[" . l:w.word . "] match base:".a:base) " debug
		let l:w.sacpomni_match = l:m
		let l:w.refresh = 'always'
		let l:retlist += [l:w]
	endfor

	return { "words":l:retlist, "refresh": "always"}

endfunction

" if doesnot match, return empty dict
" (2,'heol','helloworld') returns {4,8} 'ol' match 'oworl', 2 meas initial base is 'he', omitted for the match
function! g:WordMatchInfo(begin,base,word)
	let l:lb = len(a:base)
	let l:lw = len(a:word)
	let l:i = a:begin
	let l:j = l:i
	let l:min = 0
	let l:max = 0

	if a:begin==l:lb
		return {"min":a:begin,"max":a:begin}
	endif
	if a:base==?a:word
		" asumes world is not empty string here
		return {"min":a:begin,"max":l:lw-1}
	endif

	while l:i<l:lb
		while l:j < l:lw
			if a:base[l:i]==?a:word[l:j]
				if l:i==a:begin
					let l:min = l:j
				endif
				if l:i==l:lb-1
					let l:max = l:j
				endif
				break
			endif
			let l:j+=1
		endwhile
		let l:i+=1
	endwhile

	" not match
	if l:max==0
		return {}
	endif

	return {"min":l:min,"max":l:max}

endfunction


