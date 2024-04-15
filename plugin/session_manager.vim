set sessionoptions-=options

let s:settings = extend({'normalBuffersOnly':0, 'excludedFileTypes':[], 'askOnStartup':1, 'confirmQuit':1 },
    \ get(g:, 'SessionsSetup', {}), 'force')

command! -nargs=0 OpenSession :call s:OpenSession(1)
command! -nargs=0 SaveSession :call s:SaveSession(1)

augroup SessionManager
    autocmd!
    autocmd VimLeave * call <SID>SaveSession(0)
    autocmd VimEnter * nested call <SID>OpenSession(0)
augroup END


function! s:SaveSession(manual)
    if  a:manual && !exists('s:sessionPath')
        let s:sessionPath = getcwd()
    endif

    if !exists('s:sessionPath')
        return
    endif

    if !a:manual
        for b in filter(range(1,bufnr('$')), {_,v ->
              \ (s:settings.normalBuffersOnly && getbufvar(v,'&buftype')!='') ||
              \ index(s:settings.excludedFileTypes, getbufvar(v,'&filetype'))!=-1 })
            execute 'bwipeout ' . b
        endfor
    endif

    execute 'mksession! ' . expand(s:sessionPath . '/.session.vim')
endfunction

function! s:OpenSession(manual)
    if (s:settings.askOnStartup && argc() == 0) || a:manual
        let l:paths = map(findfile('.session.vim', getcwd().';', -1), {_,v -> fnamemodify(v,':p:h')})
        for s:sessionPath in l:paths
            if confirm('Open this session? ' . fnamemodify(s:sessionPath,':t'), "&Yes\n&No") == 1
                execute 'confirm bufdo bdelete'
                execute 'source ' . expand(s:sessionPath . '/.session.vim')

                command! -nargs=0 CloseSession :call s:CloseSession()
                command! -nargs=0 DeleteSession :call s:DeleteSession()

                if s:settings.confirmQuit == 1
                    cnoreabbrev <silent> q call <SID>ConfirmQuit()
                endif

                return
            endif
        endfor
        unlet! s:sessionPath
        if a:manual
            echo 'No session files were found.'
        endif
    endif
endfunction

function! s:CloseSession()
    unlet! s:sessionPath
    cunabbrev q
    delcommand CloseSession
    delcommand DeleteSession
endfunction

function! s:DeleteSession()
    call delete(expand(s:sessionPath . '/.session.vim'))
    call s:CloseSession()
endfunction

" Confirmation, when using `:q`, to preserve window setup for sessions.
function s:ConfirmQuit()
    if tabpagenr('$') > 1 || winnr('$') > 1
        let choice = confirm("Quit all windows and tabs?", "&Yes\n&No\n&Cancel", 1)
        if choice == 1
            quitall
        elseif choice == 2
            quit
        endif
    else
        quit
    endif
endfunction

function! SessionNameStatusLineFlag()
    return exists('s:sessionPath') ? fnamemodify(s:sessionPath,':t') : ''
endfunction
