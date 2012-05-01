runtime! ftplugin/workflowish.vim

describe 'workflowish#convert_from_workflowy'

  function! s:before()
    new
    setfiletype=workflowish
  endfunction

  function! s:after()
    close!
  endfunction

  it 'should convert standard indented lists'
    call s:before()

    execute 'normal' 'i' . join([
    \	'- Fix some bugs',
    \	'  - Backspace is annoying',
    \ ], "\<Return>")

    call workflowish#convert_from_workflowy()

    Expect getline(1, '$') ==# [
    \	'* Fix some bugs',
    \	'  * Backspace is annoying',
    \ ]

    call s:after()
  end

  it 'should convert completed items'
    call s:before()

    execute 'normal' 'i' . join([
    \	'- [COMPLETE] Fix some bugs',
    \	'  - [COMPLETE] Backspace is annoying',
    \ ], "\<Return>")

    call workflowish#convert_from_workflowy()

    Expect getline(1, '$') ==# [
    \	'- Fix some bugs',
    \	'  - Backspace is annoying',
    \ ]

    call s:after()
  end

  it 'should convert notes'
    call s:before()

    execute 'normal' 'i' . join([
    \	'- Fix some bugs',
    \	'  - Backspace is annoying',
    \	'    This is a note',
    \ ], "\<Return>")

    call workflowish#convert_from_workflowy()

    Expect getline(1, '$') ==# [
    \	'* Fix some bugs',
    \	'  * Backspace is annoying',
    \	'    \ This is a note',
    \ ]

    call s:after()
  end

  it 'should convert multiple notes'
    call s:before()

    execute 'normal' 'i' . join([
    \	'- Fix some bugs',
    \	'  - Backspace is annoying',
    \	'    This is a note with',
    \	'    multiple notes',
    \	'    spanning 4',
    \	'    lines',
    \ ], "\<Return>")

    call workflowish#convert_from_workflowy()

    Expect getline(1, '$') ==# [
    \	'* Fix some bugs',
    \	'  * Backspace is annoying',
    \	'    \ This is a note with',
    \	'    \ multiple notes',
    \	'    \ spanning 4',
    \	'    \ lines',
    \ ]

    call s:after()
  end

  it 'should convert notes with indentation'
    call s:before()

    execute 'normal' 'i' . join([
    \	'- Fix some bugs',
    \	'  - This function is broken',
    \	'    def add(a, b)',
    \	'      a * b',
    \	'    end',
    \ ], "\<Return>")

    call workflowish#convert_from_workflowy()

    Expect getline(1, '$') ==# [
    \	'* Fix some bugs',
    \	'  * This function is broken',
    \	'    \ def add(a, b)',
    \	'    \   a * b',
    \	'    \ end',
    \ ]

    call s:after()
  end

  it 'should convert notes with only whitespace'
    call s:before()

    execute 'normal' 'i' . join([
    \	'- Fix some bugs',
    \	'  - This function has a whitespace note',
    \	'    ',
    \	'    def add(a, b)',
    \	'    ',
    \	'    end',
    \ ], "\<Return>")

    call workflowish#convert_from_workflowy()

    Expect getline(1, '$') ==# [
    \	'* Fix some bugs',
    \	'  * This function has a whitespace note',
    \	'    \ ',
    \	'    \ def add(a, b)',
    \	'    \ ',
    \	'    \ end',
    \ ]

    call s:after()
  end

  it 'should convert crazy structure'
    call s:before()

    execute 'normal' 'i' . join([
    \	'- Fix some bugs',
    \	'  - Backspace is annoying',
    \	'    This is a note with',
    \	'    multiple lines',
    \	'  - Some other bug',
    \	'  - [COMPLETE] Easify thing to fix',
    \	'    - [COMPLETE] Just do this',
    \	'    - [COMPLETE] Then this',
    \	'      - [COMPLETE] But first just this thing',
    \	'    - Just one more, promise',
    \	' - [COMPLETE] Should not destroy BIOS at exit',
    \	'   Nothing to worry about',
    \	'   hehe...',
    \ ], "\<Return>")

    call workflowish#convert_from_workflowy()

    Expect getline(1, '$') ==# [
    \	'* Fix some bugs',
    \	'  * Backspace is annoying',
    \	'    \ This is a note with',
    \	'    \ multiple lines',
    \	'  * Some other bug',
    \	'  - Easify thing to fix',
    \	'    - Just do this',
    \	'    - Then this',
    \	'      - But first just this thing',
    \	'    * Just one more, promise',
    \	' - Should not destroy BIOS at exit',
    \	'   \ Nothing to worry about',
    \	'   \ hehe...',
    \ ]

    call s:after()
  end

end
