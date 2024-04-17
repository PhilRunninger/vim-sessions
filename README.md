# vim-sessions
## Intro
This simple **vim** session manager looks for a `.session.vim` file in the current or closest parent directory. On startup, if one is found, the user is asked whether it should be opened. The plugin will continue asking until a 'Yes' answer is given, or no more `.session.vim` files are found. If a session is being used, it is saved automatically when exiting **vim**.

## Installation

Use your favorite plugin manager. If you don't have one, try one of these: [vim-pathogen](https://github.com/tpope/vim-pathogen), [vim-plug](https://github.com/junegunn/vim-plug), [Packer.nvim](https://github.com/wbthomason/packer.nvim) or [lazy.nvim](https://github.com/folke/lazy.nvim). Alternatively, you can use packages and submodules, as Greg Hurrell ([@wincent](https://github.com/wincent)) describes in his excellent Youtube video: [Vim screencast #75: Plugin managers](https://www.youtube.com/watch?v=X2_R3uxDN6g)

## Commands
There are four commands defined by this plugin:
* `:OpenSession` does the same search for a session file that is done at startup.
* `:SaveSession` creates a new `.session.vim` file in the current working directory, or rewrites the active session file.
* `:CloseSession` stops associating the current session with the `.session.vim` file. All buffers remain open.
* `:DeleteSession` closes the session (`:CloseSession`) and deletes the `.session.vim` file.

## Customization
All customizations are done through a single dictionary variable. This is a change from the prior variables, which are now deprecated: `g:sessionAskOnStartup` and `g:sessionConfirmQuit`. The dictionary looks like this one, which shows the default values:

```vim
" vimscript
let g:SessionsSetup = {
    \ 'askOnStartup':      1,
    \ 'normalBuffersOnly': 0,
    \ 'excludedFileTypes': [],
    \ 'confirmQuit':       1
\ }
```
```lua
-- lua
vim.g.SessionsSetup = {
    askOnStartup =      1,
    normalBuffersOnly = 0,
    excludedFileTypes = {},
    confirmQuit =       1
\ }
```

You need not specify all keys in your `.vimrc`, just the ones you want to override. Each key's purpose is detailed below:

### `askOnStartup: <boolean>`
By default, starting vim with no file specified on the command-line will cause the plugin to search for session files. To disable this function, use `'askOnStartup': 0`.

### `normalBuffersOnly: <boolean>`
Vim will save some non-normal buffers (see `:h 'buftype'`) in session files, and provides no option to do otherwise. When these are restored, they become empty buffers. To keep only normal buffers (ones with `&buftype == ""`) in your session file, use `'normalBuffersOnly': 1`.

### `excludedFileTypes: <list of filetypes>`
Buffers of specified filetypes can be excluded from the session file. The list must contain filetypes, not file extensions, for example: `excludedFileTypes: ['markdown','vim']`. **Note:** this and the `normalBuffersOnly` setting take effect only when exiting vim, not when using the `:SaveSession` command.

### `confirmQuit: <boolean>`
This plugin modifies the `:q` command to prevent unwanted alteration of your window layout. It will ask:
```
Quit all windows and tabs?
[Y]es, (N)o, (C)ancel:
```

*Yes* closes all buffers and exits **vim**, *No* closes the current window, and *Cancel* does nothing. To avoid this prompt, use `:quit`, <kbd>Ctrl-W</kbd><kbd>c</kbd>, or `:qa`. Use `confirmQuit: 0` to disable this feature.

## Status Line
The `SessionNameStatusLineFlag()` function returns the name of the current session, or an empty string if no session is being used. The session's name is the subdirectory in which the active `.session.vim` file exists. Use a statement like this one to display it in the statusline:
```vim
" vimscript
set statusline+=%{SessionNameStatusLineFlag()}
```
```lua
-- lua
vim.opt.statusline:append('%{SessionNameStatusLineFlag()}')
```
