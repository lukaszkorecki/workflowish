setlocal foldlevel=1
setlocal foldenable
setlocal foldmethod=indent

setlocal autoindent

function! workflowish#convert_from_workflowy()
  execute 'silent %s/\v^( *)- /\1* /e'
  execute 'silent %s/\v^( *)\* \[COMPLETE\] /\1- /e'
  execute 'silent %s/\v^( *)([^\-\* ])/\1\\ \2/e'
endfunction

