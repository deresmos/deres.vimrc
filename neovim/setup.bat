set NVIM_PATH=%LOCALAPPDATA%\nvim
set WORK_DIR=%~d0%~p0

mklink /H %NVIM_PATH%\init.lua %WORK_DIR%\init.lua

mklink /D %NVIM_PATH%\lua %WORK_DIR%\lua
