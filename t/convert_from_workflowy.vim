runtime! ftplugin/workflowish.vim

describe 'workflowish#convert_from_workflowy'

  before
    new
    setfiletype=workflowish
  end

  after
    close!
  end

  it 'should convert standard indented lists'
    execute 'normal' 'i' . join([
    \	'- Fix some bugs',
    \	'  - Backspace is annoying',
    \ ], "\<Return>")

    call workflowish#convert_from_workflowy()

    Expect getline(1, '$') ==# [
    \	'* Fix some bugs',
    \	'  * Backspace is annoying',
    \ ]
  end

  it 'should convert completed items'
    execute 'normal' 'i' . join([
    \	'- [COMPLETE] Fix some bugs',
    \	'  - [COMPLETE] Backspace is annoying',
    \ ], "\<Return>")

    call workflowish#convert_from_workflowy()

    Expect getline(1, '$') ==# [
    \	'- Fix some bugs',
    \	'  - Backspace is annoying',
    \ ]
  end

  it 'should convert notes'
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
  end

  it 'should convert multiple notes'
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
  end

  it 'should convert notes with indentation'
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
  end

  it 'should convert notes with only whitespace'
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
  end

  it 'should convert crazy structure'
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
  end

end
