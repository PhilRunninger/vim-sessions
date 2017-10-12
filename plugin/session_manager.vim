set sessionoptions-=options
set sessionoptions-=help
set sessionoptions-=blank

augroup SessionManager
    autocmd!
    autocmd VimLeave * call VimLeave()
    autocmd VimEnter * call VimEnter()
augroup END

if !exists("g:PathToSessions")
    if has("win32") || has("win64")
        let g:PathToSessions = $HOME . "/vimfiles/sessions"
    else
        let g:PathToSessions = $HOME . "/.vim/sessions"
    endif
endif

function! VimLeave()
    if exists("g:SessionName") && g:SessionName != ""
        exe "mksession! " . g:PathToSessions . '/' . g:SessionName . '.vim'
    endif
endfunction

function! VimEnter()
    if argc() == 0
        call LoadASession()
    endif
endfunction

function! LoadASession()
    let session_files = glob(g:PathToSessions . "/*.vim", 0, 1)
    if len(session_files) > 0
        let session_names = map(copy(session_files), 'fnamemodify(v:val, ":t:r")')
        let s:num = 0
        let choices = map(copy(session_names), function('NumberChoices'))
        let session_num = inputlist(insert(choices, 'Saved Sessions --------→', 0))
        if session_num > 0
            execute "source " . session_files[session_num-1]
            let g:SessionName = session_names[session_num-1]
        endif
    endif
endfunction

function! NumberChoices(key, val)
    let s:num = s:num + 1
    return  printf("%5d:  %s", s:num, a:val)
endfunction

function! SessionNameStatusLineFlag()
    return (exists("g:SessionName") && g:SessionName != "") ? " Session: " . g:SessionName . ' ' : ''
endfunction

" Commands for setting and unsetting the session name
command! -nargs=1 SetSession :let g:SessionName = "<args>"
command! -nargs=0 UnsetSession :unlet g:SessionName
