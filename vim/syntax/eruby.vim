" Vim syntax file
" Language:		eRuby
" Maintainer:		Tim Pope <vimNOSPAM@tpope.info>
" Info:			$Id: eruby.vim,v 1.19 2007/05/15 17:10:58 tpope Exp $
" URL:			http://vim-ruby.rubyforge.org
" Anon CVS:		See above site
" Release Coordinator:	Doug Kearns <dougkearns@gmail.com>

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'eruby'
endif

if !exists("g:eruby_default_subtype")
  let g:eruby_default_subtype = "html"
endif

if !exists("b:eruby_subtype") && main_syntax == 'eruby'
  let s:lines = getline(1)."\n".getline(2)."\n".getline(3)."\n".getline(4)."\n".getline(5)."\n".getline("$")
  let b:eruby_subtype = matchstr(s:lines,'eruby_subtype=\zs\w\+')
  if b:eruby_subtype == ''
    let b:eruby_subtype = matchstr(substitute(expand("%:t"),'\c\%(\.erb\)\+$','',''),'\.\zs\w\+$')
  endif
  if b:eruby_subtype == 'rhtml'
    let b:eruby_subtype = 'html'
  elseif b:eruby_subtype == 'rb'
    let b:eruby_subtype = 'ruby'
  elseif b:eruby_subtype == 'yml'
    let b:eruby_subtype = 'yaml'
  elseif b:eruby_subtype == 'js'
    let b:eruby_subtype = 'javascript'
  elseif b:eruby_subtype == 'txt'
    " Conventional; not a real file type
    let b:eruby_subtype = 'text'
  elseif b:eruby_subtype == ''
    let b:eruby_subtype = g:eruby_default_subtype
  endif
endif

if !exists("b:eruby_nest_level")
  let b:eruby_nest_level = strlen(substitute(substitute(substitute(expand("%:t"),'@','','g'),'\c\.\%(erb\|rhtml\)\>','@','g'),'[^@]','','g'))
endif
if !b:eruby_nest_level
  let b:eruby_nest_level = 1
endif

if exists("b:eruby_subtype") && b:eruby_subtype != ''
  exe "runtime! syntax/".b:eruby_subtype.".vim"
  unlet! b:current_syntax
endif
syn include @rubyTop syntax/ruby.vim

syn cluster erubyRegions contains=erubyOneLiner,erubyBlock,erubyExpression,erubyComment

exe 'syn region  erubyOneLiner   matchgroup=erubyDelimiter start="^%\{1,'.b:eruby_nest_level.'\}%\@!"    end="$"     contains=@rubyTop	     containedin=ALLBUT,@erbRegions keepend oneline'
exe 'syn region  erubyBlock      matchgroup=erubyDelimiter start="<%\{1,'.b:eruby_nest_level.'\}%\@!-\=" end="-\=%\@<!%\{1,'.b:eruby_nest_level.'\}>" contains=@rubyTop        containedin=ALLBUT,@erbRegions keepend'
exe 'syn region  erubyExpression matchgroup=erubyDelimiter start="<%\{1,'.b:eruby_nest_level.'\}="       end="-\=%\@<!%\{1,'.b:eruby_nest_level.'\}>" contains=@rubyTop        containedin=ALLBUT,@erbRegions keepend'
exe 'syn region  erubyComment    matchgroup=erubyDelimiter start="<%\{1,'.b:eruby_nest_level.'\}#"       end="-\=%\@<!%\{1,'.b:eruby_nest_level.'\}>" contains=rubyTodo,@Spell containedin=ALLBUT,@erbRegions keepend'

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_eruby_syntax_inits")
  if version < 508
    let did_ruby_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink erubyDelimiter		Delimiter
  HiLink erubyComment		Comment

  delcommand HiLink
endif
let b:current_syntax = 'eruby'

if main_syntax == 'eruby'
  unlet main_syntax
endif

" vim: nowrap sw=2 sts=2 ts=8 ff=unix:
