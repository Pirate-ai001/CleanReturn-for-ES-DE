@echo off
:: ==================================================
:: CleanReturn - Steam Game (Template)
:: ==================================================

:: --------------------------------------------------
:: 1. Locate and load global config (Portable & Fallback Logic)
:: --------------------------------------------------

:: First, try the PORTABLE path (for end-users)
set "CONFIG_PATH=%~dp0..\..\Scripts\CleanReturn\CleanReturn.config"

:: If PORTABLE path fails, try the DEV/FALLBACK path (for developer setup)
if not exist "%CONFIG_PATH%" (
    set "CONFIG_PATH=G:\ES-DE\scripts\CleanReturn-for-ES-DE\CleanReturn\CleanReturn.config"
)

:: If the config is still not found, show error and exit
if not exist "%CONFIG_PATH%" (
    echo.
    echo ⚠️ CRITICAL ERROR: CleanReturn.config not found.
    echo Please ensure the config is copied and correctly named in the Scripts folder.
    echo.
    pause
    exit /b 1
)

:: Load variables from config
for /f "tokens=1,2 delims==" %%a in ('findstr "=" "%CONFIG_PATH%"') do (
    set %%a=%%b
)

:: --------------------------------------------------
:: 2. Game-specific values (FILL THESE IN)
:: --------------------------------------------------
set AppId=
set GameProcessName=
set LauncherProcessName=steam
set FlagFile="%SCRIPTS_PATH%\KILL_STEAM_FLAG.tmp"

:: --------------------------------------------------
:: 3. Run validation
:: --------------------------------------------------
powershell -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference='SilentlyContinue';" ^
    "if (-not '%AppId%') { Write-Host '❌ ERROR: AppId missing - Fill in the Steam AppId.'; exit 1 }" ^
    "if (-not '%GameProcessName%') { Write-Host '❌ ERROR: GameProcessName missing - Fill in the game executable name (e.g., YourGame.exe).'; exit 1 }"

if errorlevel 1 (
    pause
    exit /b 1
)

:: --------------------------------------------------
:: 4. Launch Game
:: --------------------------------------------------
start "" "%STEAM_EXE_PATH%" -applaunch %AppId%

:: --------------------------------------------------
:: 5. Run cleanup / monitoring
:: --------------------------------------------------
powershell -ExecutionPolicy Bypass -File "%SCRIPTS_PATH%\CleanReturn.ps1" -AppId "%AppId%" -GameProcessName "%GameProcessName%" -LauncherProcessName "%LauncherProcessName%" -FlagFile "%FlagFile%"