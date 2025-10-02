@echo off
:: ==================================================
:: CleanReturn - Steam Game (Template)
:: ==================================================

:: Locate and load global config
set "CONFIG_PATH=%~dp0..\..\Scripts\CleanReturn\CleanReturn.config"

if not exist "%CONFIG_PATH%" (
    echo.
    echo ⚠️ ERROR: CleanReturn.config not found.
    echo Expected here: %CONFIG_PATH%
    echo.
    echo Make sure you copied CleanReturn.config.example to:
    echo   ES-DE\Scripts\CleanReturn\CleanReturn.config
    echo.
    pause
    exit /b 1
)

for /f "tokens=1,2 delims==" %%a in ('findstr "=" "%CONFIG_PATH%"') do (
    set %%a=%%b
)

:: Game-specific values
set AppId=
set GameProcessName=
set LauncherProcessName=steam
set FlagFile="%SCRIPTS_PATH%\KILL_STEAM_FLAG.tmp"

:: ==================================================
:: Validation
:: ==================================================
powershell -ExecutionPolicy Bypass -Command ^
    "if (-not '%AppId%') { Write-Host '❌ ERROR: AppId missing'; exit 1 }"

if errorlevel 1 (
    pause
    exit /b 1
)

:: ==================================================
:: Launch Game
:: ==================================================
start "" "%STEAM_EXE_PATH%" -applaunch %AppId%

:: ==================================================
:: Cleanup
:: ==================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS_PATH%\CleanReturn.ps1" ^
-AppId "%AppId%" -LauncherProcessName "%LauncherProcessName%" ^
-FlagFile %FlagFile% -GameProcessName "%GameProcessName%"

exit
