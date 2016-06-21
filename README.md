# SimpleAutoComplPop

A simplified fork from [vim-scripts/AutoComplPop](https://github.com/vim-scripts/AutoComplPop)

# Why I Create This Pluign?

I'm a PHP developer, and currently I'm using neovim. 

- [Neocomplete](https://github.com/Shougo/neocomplete.vim) needs `if_lua`,
	which is not possible with neovim currently.
- With [deoplete](https://github.com/Shougo/deoplete.nvim) framework, currently
	the only option is [phpcomplete-extended](https://github.com/m2mdas/phpcomplete-extended).
	But phpcomplete_extended seems to be unmaintained right now, the latest
	comment is from two years ago.
- [YCM](https://github.com/Valloric/YouCompleteMe) is really great. It's just a
	little bit heavy for me.
- The origional [AutoComplPop](https://github.com/vim-scripts/AutoComplPop) is
	a little bit complicated, and hard to extend for me.

Finally I decided to create my own SimpleAutoComplPop, focus on easy to use,
and easy to be extended for your own use cases. SimpleAutoComplPop maps keys on
a per-buffer basis, technically it will not conflict with other auto-complete
plugin if you configure carefully. 

# Usage

## PHP

Currently, this is the default php pattern, use omnicomplete's `<C-X><C-o>` key
to for completion.

```vimscript
	autocmd FileType php,php5,php7 call sacp#enableForThisBuffer({ "matches": [
				\ { '=~': '\v[a-zA-Z]{4}$', 'feedkeys': "\<C-x>\<C-o>"},
				\ { '=~': '::$'           , 'feedkeys': "\<C-x>\<C-o>"},
				\ { '=~': '->$'           , 'feedkeys': "\<C-x>\<C-o>"},
				\ ]
				\ })
```

Demo with [phpcomplete.vim](https://github.com/shawncplus/phpcomplete.vim).
Press `<TAB>` to select the popup menu.

![php_demo](https://github.com/roxma/SimpleAutoComplPop.img/blob/master/usage_php_demo.gif)

## Golang

```
	autocmd FileType go call sacp#enableForThisBuffer({ "matches": [
				\ { '=~': '\v[a-zA-Z]{4}$' , 'feedkeys': "\<C-x>\<C-o>"} ,
				\ { '=~': '\.$'            , 'feedkeys': "\<C-x>\<C-o>"} ,
				\ ]
				\ })
```

Demo with [vim-go](https://github.com/fatih/vim-go)

![go_demo](https://github.com/roxma/SimpleAutoComplPop.img/blob/master/usage_go_demo.gif)

## Config

- Disable SimpleAutoComplPop, add `let g:sacpEnable = 0` to your vimrc file.
- Enable for php only, add `let g:sacpDefaultFiltTypesEnable = {"php":1}` to
	your vimrc file.

