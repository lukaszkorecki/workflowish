runtime! ftplugin/workflowish.vim

describe 'in focus mode'

  before
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
    \	'* Features',
    \	'  * Delicious cookies',
    \	'  * Tea: earl gray, hot',
    \ ], "\<Return>")

  end

  function! s:setFocusOn(lnum)
    " this is madness, works fine 'live'
    try
      call WorkflowishFocusOn(a:lnum)
    catch /^Vim(normal):E490:/
    endtry
  endfunction

  after
    close!
  end

  it 'should set the header-line to startlevel of its children'
    call s:setFocusOn(5)

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
    Expect WorkflowishCompactFoldLevel(12) ==# 1
    Expect WorkflowishCompactFoldLevel(13) ==# 1
    Expect WorkflowishCompactFoldLevel(14) ==# 1
    Expect WorkflowishCompactFoldLevel(15) ==# 1
    Expect WorkflowishCompactFoldLevel(16) ==# 1
    Expect WorkflowishCompactFoldLevel(17) ==# 1
  end

  it 'should set the header-line to startlevel of its children for focus on last main item'
    call s:setFocusOn(15)

    Expect WorkflowishCompactFoldLevel(1)  ==# '>1'
    Expect WorkflowishCompactFoldLevel(2)  ==# 1
    Expect WorkflowishCompactFoldLevel(3)  ==# 1
    Expect WorkflowishCompactFoldLevel(4)  ==# 1
    Expect WorkflowishCompactFoldLevel(5)  ==# 1
    Expect WorkflowishCompactFoldLevel(6)  ==# 1
    Expect WorkflowishCompactFoldLevel(7)  ==# 1
    Expect WorkflowishCompactFoldLevel(8)  ==# 1
    Expect WorkflowishCompactFoldLevel(9)  ==# 1
    Expect WorkflowishCompactFoldLevel(10) ==# 1
    Expect WorkflowishCompactFoldLevel(11) ==# 1
    Expect WorkflowishCompactFoldLevel(12) ==# 1
    Expect WorkflowishCompactFoldLevel(13) ==# 1
    Expect WorkflowishCompactFoldLevel(14) ==# 1
    Expect WorkflowishCompactFoldLevel(15) ==# '>1'
    Expect WorkflowishCompactFoldLevel(16) ==# 1
    Expect WorkflowishCompactFoldLevel(17) ==# 1
  end

  it 'it should set fold-text of first fold outside focus to breadcrumbs'
    call s:setFocusOn(5)
    let v:foldstart = 1
    let v:foldend = 4
    Expect WorkflowishFoldText() ==# "Project1 > boom                                 "
  end

  it 'it should set fold-text of first fold outside focus to Root when there are no breadcrumbs'
    call s:setFocusOn(9)
    let v:foldstart = 1
    let v:foldend = 8
    Expect WorkflowishFoldText() ==# "Root                                            "
  end

  it 'it should not affect fold-text inside focus'
    call s:setFocusOn(5)
    let v:foldstart = 7
    let v:foldend = 8
    Expect WorkflowishFoldText() ==# "      * becase they are so very nice        |1| "
  end

  it 'it should remove spaces of fold-text inside focus when horizontal scrolling is on'
    let g:workflowish_experimental_horizontal_focus = 1
    call s:setFocusOn(5)
    let v:foldstart = 7
    let v:foldend = 8
    Expect WorkflowishFoldText() ==# "  * becase they are so very nice            |1| "
  end

  it 'should change the fold-text of the last fold outside focus'
    call s:setFocusOn(5)
    let v:foldstart=9
    let v:foldend=17
    Expect WorkflowishFoldText() ==# "- - - - - - - - - - - - - - - - - - - - - - - - "
  end

end
