runtime! ftplugin/workflowish.vim

describe 'in focus mode'

  " TODO: scope, when focus is set on line 5
  function! s:before()
    new
    setfiletype=workflowish
    setlocal columns=50

    execute 'normal' 'i' . join([
    \	'* Project1',
    \	'  * check Google Tasks',
    \	'  * boom ',
    \	'    * bam #bam',
    \	'    * FOCUS MODE ON THIS ROW',
    \	'      * i should see these lines',
    \	'      * becase they are so very nice',
    \	'        * to look at every day',
    \	'* PANCAKES',
    \	'  \ here are some notes',
    \	'  * delicious! #yeah! @data',
    \	'  - this item is done',
    \	'  * this one still needs doing',
    \	'    \ notes for this todo',
    \ ], "\<Return>")


    " this is madness, works fine 'live'
    try
      call WorkflowishFocusOn(5)
    catch /^Vim(normal):E490:/
    endtry

  endfunction

  function! s:after()
    close!
  endfunction

  it 'should set the header-line to startlevel of its children'
    call s:before()

    Expect WorkflowishCompactFoldLevel(1)  ==# '>1'
    Expect WorkflowishCompactFoldLevel(2)  ==# 1
    Expect WorkflowishCompactFoldLevel(3)  ==# 1
    Expect WorkflowishCompactFoldLevel(4)  ==# 1
    Expect WorkflowishCompactFoldLevel(5)  ==# '>1'
    Expect WorkflowishCompactFoldLevel(6)  ==# 1
    Expect WorkflowishCompactFoldLevel(7)  ==# '>2'
    Expect WorkflowishCompactFoldLevel(8)  ==# 2
    Expect WorkflowishCompactFoldLevel(9)  ==# '>1'
    Expect WorkflowishCompactFoldLevel(10) ==# 1
    Expect WorkflowishCompactFoldLevel(11) ==# 1

    call s:after()
  end

  it 'it should set fold-text of first fold outside focus to breadcrumbs'
    call s:before()
    let v:foldstart = 1
    let v:foldend = 4
    Expect WorkflowishFoldText() ==# "Project1 > boom                                 "
    call s:after()
  end

  it 'it should not affect fold-text inside focus'
    call s:before()
    let v:foldstart = 7
    let v:foldend = 8
    Expect WorkflowishFoldText() ==# "      * becase they are so very nice        |1| "
    call s:after()
  end

  it 'it should remove spaces of fold-text inside focus when horizontal scrolling is on'
    call s:before()
    let g:workflowish_experimental_horizontal_focus = 1
    try
      call WorkflowishFocusOn(5)
    catch /^Vim(normal):E490:/
    endtry
    let v:foldstart = 7
    let v:foldend = 8
    Expect WorkflowishFoldText() ==# "  * becase they are so very nice            |1| "
    call s:after()
  end

  it 'should change the fold-text of the last fold outside focus'
    call s:before()
    let v:foldstart=9
    let v:foldend=11
    Expect WorkflowishFoldText() ==# "- - - - - - - - - - - - - - - - - - - - - - - - "
    call s:after()
  end

end
