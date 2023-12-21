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
    if (get(g:, 'sessionAskOnStartup', 1) && argc() == 0) || a:manual
        let l:paths = map(findfile('.session.vim', getcwd().';', -1), {_,v -> fnamemodify(v,':p:h')})
        for g:sessionPath in l:paths
            if confirm('Open session: ' . fnamemodify(g:sessionPath,':t'), "&Yes\n&No") == 1
                execute 'confirm bufdo bdelete'
                execute 'source ' . expand(g:sessionPath . '/.session.vim')

                command! -nargs=0 CloseSession :call s:CloseSession()
                command! -nargs=0 DeleteSession :call s:DeleteSession()

                if get(g:, 'sessionConfirmQuit', 1) == 1
                    cnoreabbrev <silent> q call <SID>ConfirmQuit()
                endif

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
    cunabbrev q
    delcommand CloseSession
    delcommand DeleteSession
endfunction

function! s:DeleteSession()
    call delete(expand(g:sessionPath . '/.session.vim'))
    call s:CloseSession()
endfunction

" Confirmation upon quitting to preserve window setup for sessions.
function s:ConfirmQuit()
    if tabpagenr('$') > 1 || winnr('$') > 1
        let choice = confirm("Quit all windows and tabs?", "&Yes\n&No\n&Cancel", 1)
        if choice == 1
            quitall
        elseif choice == 2
            quit
            echo "Tip: Use <C-w>c or :quit instead."
        endif
    else
        quit
    endif
endfunction

function! SessionNameStatusLineFlag()
    return exists('g:sessionPath') ? fnamemodify(g:sessionPath,':t') : ''
endfunction
