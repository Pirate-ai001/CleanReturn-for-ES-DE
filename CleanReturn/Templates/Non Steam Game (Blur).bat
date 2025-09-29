@echo off
:: ==================================================
:: CleanReturn - Non-Steam Template
:: Use this for standalone .exe games
:: ==================================================

:: Load global config values (paths only)
for /f "tokens=1,2 delims==" %%a in ('findstr "=" "CleanReturn.config"') do (
    set %%a=%%b
)

:: Game-specific values
set AppId=NONSTEAM_BLUR
set GameProcessName=Blur
set LauncherProcessName=
set FlagFile="%SCRIPTS_PATH%\KILL_NONSTEAM_FLAG.tmp"

:: Launch game directly
start "" "C:\Games\Blur\Blur.exe"

:: Run cleanup script
powershell -ExecutionPolicy Bypass -File "%SCRIPTS_PATH%\CleanReturn.ps1" ^
-AppId "%AppId%" -LauncherProcessName "%LauncherProcessName%" ^
-FlagFile %FlagFile% -GameProcessName "%GameProcessName%"

exit
