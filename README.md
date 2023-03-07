# vim-sessions
## Intro
This simple **vim** session manager looks for a `.session.vim` file starting in the current working directory. On startup, if one is found there or in any parent directory (checked one level at a time), the user is asked whether or not it should be opened. If a session is being used, it is saved automatically when exiting **vim**.

## Commands
There are four commands defined by this plugin:
* `OpenSession` does the same search for a session file that was done at startup.
* `SaveSession` saves the current session, either in the same file or in a new one in the current working directory.
* `CloseSession` stops associating the current session with the session file. All buffers remain open.
* `DeleteSession` closes the session (`:CloseSession`) and deletes the session file.

## Quit Confirmation
When a session file has been opened or created, the `:q` command will behave differently. In order to prevent unwanted alteration of your window layout, the plugin will more or less ask "Do you want to close all windows and exit vim, or close just this one window?" To avoid this prompt, use `:quit` or `<C-w>c` to close the current window, or `:qa` to close all windows.

## Status Line
The name of a session can be displayed in the status line. The session's name is the subdirectory in which the active `.session.vim` file exists. Use a statement like this one:
```
set statusline+=%{SessionNameStatusLineFlag()}
```
