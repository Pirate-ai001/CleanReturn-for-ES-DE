@echo off
:: ==================================================
:: CleanReturn - Steam Standard Template
:: Use this for most Steam games
:: ==================================================

:: Load global config values (paths only)
for /f "tokens=1,2 delims==" %%a in ('findstr "=" "CleanReturn.config"') do (
    set %%a=%%b
)

:: Game-specific values
set AppId=570
set LauncherProcessName=steam
set FlagFile="%SCRIPTS_PATH%\KILL_STEAM_FLAG.tmp"

:: Create Steam flag file
echo 1 > %FlagFile%

:: Launch Steam game by App ID
start "" "%STEAM_EXE_PATH%" steam://rungameid/%AppId%

:: Run cleanup script
powershell -ExecutionPolicy Bypass -File "%SCRIPTS_PATH%\CleanReturn.ps1" ^
-AppId "%AppId%" -LauncherProcessName "%LauncherProcessName%" -FlagFile %FlagFile%

exit
