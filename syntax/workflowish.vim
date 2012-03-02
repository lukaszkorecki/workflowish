if exists("b:current_syntax")
  finish
endif

syn match WFToDoDot /^\s*\*/
syn match WFPerson /@[a-zA-Z0-9_-]*/
syn match WFTag  /#[a-zA-Z0-9_-]*/

command -nargs=+ HiLink hi def link <args>

HiLink WFToDoDot Comment
HiLink WFPerson Function
HiLink WFTag String


delcommand HiLink



let b:current_syntax = "workflowish"
