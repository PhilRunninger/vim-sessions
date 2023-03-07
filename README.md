# vim-sessions
This simple **vim** session manager looks for a `.session.vim` file starting in the current working directory. If one is found there or in any parent directory (checked one level at a time), the user is asked whether or not it should be opened. If a session is being used, it is saved automatically when exiting **vim**.

There are four commands defined by this plugin:
* `OpenSession` does the same search for a session file that was done at startup.
* `SaveSession` saves the current session, either in the same file or in a new one in the current working directory.
* `CloseSession` stops associating the current session with the session file. All buffers remain open.
* `DeleteSession` closes the session (`:CloseSession`) and deletes the session file.

If a session file has been read in at startup or created during the session, the name of that session can be displayed in the status line. The name being displayed is the lowest level subdirectory, in which the `.session.vim` file exists. Use a statement like this one:
```
set statusline+=%{SessionNameStatusLineFlag()}
```
