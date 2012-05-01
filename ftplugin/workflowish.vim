setlocal foldlevel=1
setlocal foldenable
setlocal foldmethod=indent

setlocal autoindent

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

