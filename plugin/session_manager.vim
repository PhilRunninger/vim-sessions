set sessionoptions-=options

augroup SessionManager
    autocmd!
    autocmd VimLeave * call VimLeave()
    autocmd VimEnter * call VimEnter()
augroup END

if !exists("g:pathToSessions")
    if has("win32") || has("win64")
        let g:pathToSessions = $HOME . "/vimfiles/sessions"
    else
        let g:pathToSessions = $HOME . "/.vim/sessions"
    endif
endif

function! VimLeave()
    if exists("g:sessionName") && g:sessionName != ""
        exe "mksession! " . g:pathToSessions . '/' . g:sessionName . '.vim'
    endif
endfunction

function! VimEnter()
    if argc() == 0
        let session_files = glob(g:pathToSessions . "/*.vim", 0, 1)
        if len(session_files) > &lines - 2
            echohl ErrorMsg
            echomsg 'Too many session files! Clean your sessions folder: ' . g:pathToSessions
            echohl None
        elseif len(session_files) > 0
            let session_names = map(copy(session_files), 'fnamemodify(v:val, ":t:r")')
            let choices=['Saved Sessions --------→']
            for session_name in session_names
                call add(choices, printf("%5d:  %s", len(choices), session_name))
            endfor
            let selection = inputlist(choices)
            if selection > 0
                execute "source " . session_files[selection-1]
                let g:sessionName = session_names[selection-1]
            endif
        endif
    endif
endfunction

function! SessionNameStatusLineFlag()
    return (exists("g:sessionName") && g:sessionName != "") ? " Session: " . g:sessionName . ' ' : 'Use :SetSession to create a session.'
endfunction

" Commands for setting and unsetting the session name
command! -nargs=1 SetSession :let g:sessionName = "<args>"
command! -nargs=0 UnsetSession :unlet g:sessionName
