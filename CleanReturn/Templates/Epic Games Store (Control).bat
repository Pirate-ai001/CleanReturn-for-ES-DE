@echo off
:: ==================================================
:: CleanReturn - Epic Games Template
:: ==================================================

:: Load global config values (paths only)
for /f "tokens=1,2 delims==" %%a in ('findstr "=" "CleanReturn.config"') do (
    set %%a=%%b
)

:: Game-specific values
set AppId=EPIC_CONTROL
set GameProcessName=Control_DX12
set LauncherProcessName=EpicGamesLauncher
set FlagFile="%SCRIPTS_PATH%\KILL_EPIC_FLAG.tmp"

:: Launch Epic shortcut (from Epic shortcuts folder)
start "" "%EPIC_SHORTCUTS_PATH%\Control.url"

:: Run cleanup script
powershell -ExecutionPolicy Bypass -File "%SCRIPTS_PATH%\CleanReturn.ps1" ^
-AppId "%AppId%" -LauncherProcessName "%LauncherProcessName%" ^
-FlagFile %FlagFile% -GameProcessName "%GameProcessName%"

exit
