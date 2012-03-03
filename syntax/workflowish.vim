if exists("b:current_syntax")
  finish
endif

syn match WFToDoDot /^\s*\*/
syn match WFToDo /^\s*\*(.*)/
syn match WFPerson /@[a-zA-Z0-9_-]*/
syn match WFTag  /#[a-zA-Z0-9_-]*/
syn match WFDoneLIne /^\s*-.*$/
syn match WFComment /^\s*\\.*$/

hi def link WFToDo  Question
hi def link WFToDoDot Function
hi def link WFDoneLIne Comment
hi def link WFComment Delimiter
hi def link WFPerson Function
hi def link WFTag String

let b:current_syntax = "workflowish"
