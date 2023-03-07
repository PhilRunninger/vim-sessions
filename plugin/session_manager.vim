set sessionoptions-=options

command! -nargs=0 OpenSession :call s:OpenSession(1)
command! -nargs=0 SaveSession :call s:SaveSession(1)

augroup SessionManager
    autocmd!
    autocmd VimLeave * call <SID>SaveSession(0)
    autocmd VimEnter * nested call <SID>OpenSession(0)
augroup END

function! s:SaveSession(manual)
    if  a:manual && !exists('g:sessionPath')
        let g:sessionPath = getcwd()
    endif

    if a:manual || exists('g:sessionPath')
        execute 'mksession! ' . expand(g:sessionPath . '/.session.vim')
    endif
endfunction

function! s:OpenSession(manual)
    if argc() == 0 || a:manual
        let l:paths = map(findfile('.session.vim', getcwd().';', -1), {_,v -> fnamemodify(v,':p:h')})
        for g:sessionPath in l:paths
            if confirm('Open session: ' . fnamemodify(g:sessionPath,':t'), "&Yes\n&No") == 1
                execute 'confirm bufdo bdelete'
                execute 'source ' . expand(g:sessionPath . '/.session.vim')

                command! -nargs=0 CloseSession :call s:CloseSession()
                command! -nargs=0 DeleteSession :call s:DeleteSession()

                return
            endif
        endfor
        unlet! g:sessionPath
        if a:manual
            echomsg 'No session files were found.'
        endif
    endif
endfunction

function! s:CloseSession()
    unlet! g:sessionPath
    delcommand CloseSession
    cunabbrev q
endfunction

function! s:DeleteSession()
    call delete(expand(g:sessionPath . '/.session.vim'))
    delcommand DeleteSession
    call s:CloseSession()
endfunction

function! SessionNameStatusLineFlag()
    return exists('g:sessionPath') ? fnamemodify(g:sessionPath,':t') : ''
endfunction
