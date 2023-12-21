# vim-sessions
## Intro
This simple **vim** session manager looks for a `.session.vim` file in the current or closest parent directory. On startup, if one is found, the user is asked whether it should be opened. The plugin will continue asking until a 'Yes' answer is given, or no more `.session.vim` files are found. If a session is being used, it is saved automatically when exiting **vim**.

## Installation

Use your favorite plugin manager. If you don't have one, try one of these: [vim-pathogen](https://github.com/tpope/vim-pathogen), [vim-plug](https://github.com/junegunn/vim-plug), [Packer.nvim](https://github.com/wbthomason/packer.nvim) or [lazy.nvim](https://github.com/folke/lazy.nvim). Alternatively, you can use packages and submodules, as Greg Hurrell ([@wincent](https://github.com/wincent)) describes in his excellent Youtube video: [Vim screencast #75: Plugin managers](https://www.youtube.com/watch?v=X2_R3uxDN6g)

## Commands
There are four commands defined by this plugin:
* `:OpenSession` does the same search for a session file that was done at startup.
* `:SaveSession` creates a new `.session.vim` file in the current directory, or overwrites the active session file.
* `:CloseSession` stops associating the current session with the `.session.vim` file. All buffers remain open.
* `:DeleteSession` closes the session (`:CloseSession`) and deletes the `.session.vim` file.

## Disabling Startup Behavior
By default, the plugin will ask the user on startup if no files were specified on the command line. To disable this feature, add this to your `.vimrc`:
```vim
let g:sessionAskOnStartup = 0
```

## Quit Confirmation
When this plugin opens a session file, the `:q` command is modified to behave differently. In order to prevent unwanted alteration of your window layout, the plugin will ask:
```
Quit all windows and tabs?
[Y]es, (N)o, (C)ancel:
```
Answering *Yes* will close all buffers and exit **vim**, *No* will close just the current window, and *Cancel* does nothing. To avoid this prompt, use `:quit` or <kbd>Ctrl-W</kbd>,<kbd>c</kbd> to close the current window, `:qa` to close all windows, or add this line to your `.vimrc` to disable the feature altogether:
```vim
let g:sessionConfirmQuit = 0
```

## Status Line
The `SessionNameStatusLineFlag()` function returns the name of the current session. The session's name is the subdirectory in which the active `.session.vim` file exists. Use a statement like this one to display it in the statusline:
```vim
set statusline+=%{SessionNameStatusLineFlag()}
```
