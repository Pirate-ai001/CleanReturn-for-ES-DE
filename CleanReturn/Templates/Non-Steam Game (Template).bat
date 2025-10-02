@echo off
:: ==================================================
:: CleanReturn - Non-Steam Game Template (v1.1 optimized)
:: ==================================================

:: 1. Load global config values
for /f "tokens=1,2 delims==" %%a in ('findstr "=" "G:\ES-DE\Scripts\CleanReturn\CleanReturn.config"') do (
    set %%a=%%b
)

:: 2. Game-specific values
set AppId=NONSTEAM_EXAMPLE
set GameProcessName=ExampleGame.exe
set LauncherProcessName=
set FlagFile="%SCRIPTS_PATH%\KILL_NONSTEAM_FLAG.tmp"

:: Path to game executable
set "GAME_PATH=C:\Path\To\Game\ExampleGame.exe"

:: ==================================================
:: 3. Validation
:: ==================================================
powershell -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference='SilentlyContinue';" ^
    "if (-not (Test-Path '%GAME_PATH%')) { Write-Host '============================='; Write-Host '⚠️ CLEANRETURN CONFIG ERROR ⚠️'; Write-Host '============================='; Write-Host ''; Write-Host '❌ GAME_PATH is invalid:'; Write-Host '   %GAME_PATH%'; Write-Host ''; Write-Host '🔧 How to fix:'; Write-Host '   1. Edit this .bat file'; Write-Host '   2. Set GAME_PATH to the correct full path of your game''s .exe'; Write-Host '   3. Save and try again'; exit 1 }" ^
    "if (-not '%AppId%') { Write-Host '============================='; Write-Host '⚠️ CLEANRETURN CONFIG ERROR ⚠️'; Write-Host '============================='; Write-Host ''; Write-Host '❌ AppId is missing.'; Write-Host ''; Write-Host '🔧 How to fix:'; Write-Host '   1. Edit this .bat file'; Write-Host '   2. Set AppId to a unique identifier (example: NONSTEAM_MYGAME)'; Write-Host '   3. Save and try again'; exit 1 }" ^
    "if (-not '%GameProcessName%') { Write-Host '============================='; Write-Host '⚠️ CLEANRETURN CONFIG ERROR ⚠️'; Write-Host '============================='; Write-Host ''; Write-Host '❌ GameProcessName is missing.'; Write-Host ''; Write-Host '🔧 How to fix:'; Write-Host '   1. Launch your game manually'; Write-Host '   2. Open Task Manager → Details tab'; Write-Host '   3. Find the game''s process (e.g. ExampleGame.exe)'; Write-Host '   4. Edit this .bat file and set GameProcessName=ExampleGame.exe'; Write-Host '   5. Save and try again'; exit 1 }"

if errorlevel 1 (
    pause
    exit /b 1
)

echo ✅ Validation passed. Launching game...

:: ==================================================
:: 4. Launch Game
:: ==================================================
cd /d "%~dp0"
start "" "%GAME_PATH%"

:: ==================================================
:: 5. Cleanup / Monitoring
:: ==================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS_PATH%\CleanReturn.ps1" ^
-AppId "%AppId%" -LauncherProcessName "%LauncherProcessName%" ^
-FlagFile %FlagFile% -GameProcessName "%GameProcessName%"

exit
