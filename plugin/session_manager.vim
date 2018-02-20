set sessionoptions-=options

" Commands for setting and unsetting the session name
command! -nargs=0 OpenSession :call OpenSession(1)
command! -nargs=0 SaveSession :call SaveSession(1)

augroup SessionManager
    autocmd!
    autocmd VimLeave * call SaveSession(0)
    autocmd VimEnter * nested call OpenSession(0)
augroup END

function! SaveSession(manual)
    if  a:manual && !exists("g:sessionPath")
        let g:sessionPath = split(getcwd(),'/',1)
    endif

    if a:manual || exists("g:sessionPath")
        execute "mksession! " . join(add(copy(g:sessionPath), '.session.vim'), '/')
    endif
endfunction

function! OpenSession(manual)
    if argc() == 0 || a:manual
        let g:sessionPath = split(getcwd(),'/',1)
        while len(g:sessionPath) > 0
            let path = join(copy(g:sessionPath), '/')
            if filereadable(path . '/.session.vim')
                if confirm('Use session in: ' . path, "&Yes\n&No") == 1
                    execute "bufdo bdelete"
                    execute "source " . path . '/.session.vim'
                    return
                endif
            endif
            call remove(g:sessionPath, -1)
        endwhile
        unlet g:sessionPath
        if a:manual
            echomsg "No session files were found."
        endif
    endif
endfunction

function! SessionNameStatusLineFlag()
    return exists("g:sessionPath") ? g:sessionPath[-1] : ''
endfunction
