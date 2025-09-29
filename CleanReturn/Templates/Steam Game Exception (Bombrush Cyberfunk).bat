@echo off
:: ==================================================
:: CleanReturn - Steam Exception Template
:: Use this if automatic detection fails
:: ==================================================

:: Load global config values (paths only)
for /f "tokens=1,2 delims==" %%a in ('findstr "=" "CleanReturn.config"') do (
    set %%a=%%b
)

:: Game-specific values
set AppId=1353230
set GameProcessName=BombRushCyberfunk-Win64-Shipping
set LauncherProcessName=steam
set FlagFile="%SCRIPTS_PATH%\KILL_STEAM_FLAG.tmp"

:: Create Steam flag file
echo 1 > %FlagFile%

:: Launch Steam game by App ID
start "" "%STEAM_EXE_PATH%" steam://rungameid/%AppId%

:: Run cleanup script
powershell -ExecutionPolicy Bypass -File "%SCRIPTS_PATH%\CleanReturn.ps1" ^
-AppId "%AppId%" -LauncherProcessName "%LauncherProcessName%" ^
-FlagFile %FlagFile% -GameProcessName "%GameProcessName%"

exit
