runtime! ftplugin/workflowish.vim

describe 'compact folds'

  function! s:before()
    new
    setfiletype=workflowish
  endfunction

  function! s:after()
    close!
  endfunction

  it 'should set the header-line to startlevel of its children'
    call s:before()

    execute 'normal' 'i' . join([
    \	'* Project1',
    \	'  * check Google Tasks',
    \	'  * boom',
    \	'    * bam #bam',
    \	'    * @lol',
    \	'* PANCAKES',
    \	'  \ here are some notes',
    \	'  * delicious! #yeah! @data',
    \	'  - this item is done',
    \	'  * this one still needs doing',
    \	'    \ notes for this todo',
    \ ], "\<Return>")

    Expect WorkflowishCompactFoldLevel(1)  ==# '>1'
    Expect WorkflowishCompactFoldLevel(2)  ==# 1
    Expect WorkflowishCompactFoldLevel(3)  ==# '>2'
    Expect WorkflowishCompactFoldLevel(4)  ==# 2
    Expect WorkflowishCompactFoldLevel(5)  ==# 2
    Expect WorkflowishCompactFoldLevel(6)  ==# '>1'
    Expect WorkflowishCompactFoldLevel(7)  ==# 1
    Expect WorkflowishCompactFoldLevel(8)  ==# 1
    Expect WorkflowishCompactFoldLevel(9)  ==# 1
    Expect WorkflowishCompactFoldLevel(10) ==# '>2'
    Expect WorkflowishCompactFoldLevel(11) ==# 2

    call s:after()
  end

end
