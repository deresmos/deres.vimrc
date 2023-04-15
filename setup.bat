set NVIM_PATH=%LOCALAPPDATA%\nvim
set WORK_DIR=%~d0%~p0

mklink /H %NVIM_PATH%\init.vim %WORK_DIR%\init.vim

mklink /D %NVIM_PATH%\conf.d %WORK_DIR%\conf.d
mklink /D %NVIM_PATH%\dein %WORK_DIR%\dein
