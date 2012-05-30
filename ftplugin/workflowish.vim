setlocal foldlevel=1
setlocal foldenable
setlocal sw=2 sts=2
setlocal expandtab
setlocal foldtext=WorkflowishFoldText()
setlocal foldmethod=expr
setlocal foldexpr=WorkflowishCompactFoldLevel(v:lnum)

setlocal autoindent

" unicode length, from https://github.com/gregsexton/gitv/pull/14
if exists("*strwidth")
  "introduced in Vim 7.3
  fu! s:StringWidth(string)
    return strwidth(a:string)
  endfu
else
  fu! s:StringWidth(string)
    return len(split(a:string,'\zs'))
  endfu
end

" This feature hides all nested lines under the main one, like workflowy.
function! WorkflowishCompactFoldLevel(lnum)
  " TODO: check why vspec can't handle options like &shiftwidth instead of
  " hardcoded 2
  let this_indent = indent(a:lnum) / 2
  let next_indent = indent(a:lnum + 1) / 2

  if next_indent > this_indent
    return '>' . next_indent
  else
    return this_indent
  endif
endfunction


function! WorkflowishFoldText()
  let lines = v:foldend - v:foldstart
  let firstline = getline(v:foldstart)
  let textend = '|' . lines . '| '
  let nucolwidth = &fdc + &number*&numberwidth
  let window_width = winwidth(0) - nucolwidth - 2

  return firstline . repeat(" ", window_width-s:StringWidth(firstline.textend)) . textend
endfunction

function! workflowish#convert_from_workflowy()
  " Replace all - with *
  silent %s/\v^( *)- /\1* /e

  " Fix notes under other notes or items (whitespace hack, copies the number of spaces in submatch \1 from last row), max 1000 rows in one comment block
  " The try will catch nomatch early and stop
  try
    let c = 1
    while c < 1000
      silent %s/\v^( *)(  \\|\*)( .*\n)\1  ( *)([^\-\* ]|$)/\1\2\3\1  \\\4 \5/
      let c += 1
    endwhile
  catch /^Vim(substitute):E486:/
  endtry
  " Change completed items to -
  silent %s/\v^( *)\* \[COMPLETE\] /\1- /e
endfunction

