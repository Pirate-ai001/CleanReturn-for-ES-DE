@echo off
:: ==================================================
:: CleanReturn - Non-Steam Game (Template)
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
set LauncherProcessName=
set FlagFile="%SCRIPTS_PATH%\KILL_NONSTEAM_FLAG.tmp"
set "GAME_PATH=C:\Path\To\YourGame.exe"

:: ==================================================
:: Validation
:: ==================================================
powershell -ExecutionPolicy Bypass -Command ^
    "if (-not (Test-Path '%GAME_PATH%')) { Write-Host '❌ ERROR: GAME_PATH is invalid: %GAME_PATH%'; exit 1 }" ^
    "; if (-not '%AppId%') { Write-Host '❌ ERROR: AppId missing'; exit 1 }" ^
    "; if (-not '%GameProcessName%') { Write-Host '❌ ERROR: GameProcessName missing'; exit 1 }"

if errorlevel 1 (
    pause
    exit /b 1
)

:: ==================================================
:: Launch Game
:: ==================================================
cd /d "%~dp0"
start "" "%GAME_PATH%"

:: ==================================================
:: Cleanup
:: ==================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS_PATH%\CleanReturn.ps1" ^
-AppId "%AppId%" -LauncherProcessName "%LauncherProcessName%" ^
-FlagFile %FlagFile% -GameProcessName "%GameProcessName%"

exit
