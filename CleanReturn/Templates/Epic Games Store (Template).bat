@echo off
:: ==================================================
:: CleanReturn - Epic Games Template (v1.1 optimized)
:: ==================================================

:: 1. Load global config values
for /f "tokens=1,2 delims==" %%a in ('findstr "=" "G:\ES-DE\Scripts\CleanReturn\CleanReturn.config"') do (
    set %%a=%%b
)

:: 2. Game-specific values
set AppId=EPIC_CONTROL
set GameProcessName=Control_DX12.exe
set LauncherProcessName=EpicGamesLauncher
set FlagFile="%SCRIPTS_PATH%\KILL_EPIC_FLAG.tmp"

:: Path to Epic shortcut (.url)
set "GAME_SHORTCUT=%EPIC_SHORTCUTS_PATH%\%AppId%.url"

:: ==================================================
:: 3. Validation
:: ==================================================
powershell -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference='SilentlyContinue';" ^
    "if (-not (Test-Path '%GAME_SHORTCUT%')) { Write-Host '============================='; Write-Host '⚠️ CLEANRETURN CONFIG ERROR ⚠️'; Write-Host '============================='; Write-Host ''; Write-Host '❌ Epic shortcut not found:'; Write-Host '   %GAME_SHORTCUT%'; Write-Host ''; Write-Host '🔧 How to fix:'; Write-Host '   1. Make sure you disabled Epic Cloud Saves'; Write-Host '   2. Move the game''s .url shortcut into %EPIC_SHORTCUTS_PATH%'; Write-Host '   3. Edit this .bat file and set AppId correctly'; exit 1 }" ^
    "if (-not '%AppId%') { Write-Host '============================='; Write-Host '⚠️ CLEANRETURN CONFIG ERROR ⚠️'; Write-Host '============================='; Write-Host ''; Write-Host '❌ AppId is missing.'; Write-Host ''; Write-Host '🔧 How to fix:'; Write-Host '   1. Edit this .bat file'; Write-Host '   2. Set AppId to the Epic shortcut name (without extension)'; Write-Host '   3. Save and try again'; exit 1 }" ^
    "if (-not '%GameProcessName%') { Write-Host '============================='; Write-Host '⚠️ CLEANRETURN CONFIG ERROR ⚠️'; Write-Host '============================='; Write-Host ''; Write-Host '❌ GameProcessName is missing.'; Write-Host ''; Write-Host '🔧 How to fix:'; Write-Host '   1. Launch the game manually via Epic'; Write-Host '   2. Open Task Manager → Details tab'; Write-Host '   3. Find the game''s process (e.g. Control_DX12.exe)'; Write-Host '   4. Edit this .bat file and set GameProcessName=Control_DX12.exe'; Write-Host '   5. Save and try again'; exit 1 }"

if errorlevel 1 (
    pause
    exit /b 1
)

echo ✅ Validation passed. Launching game...

:: ==================================================
:: 4. Launch Game
:: ==================================================
start "" "%GAME_SHORTCUT%"

:: ==================================================
:: 5. Cleanup / Monitoring
:: ==================================================
powershell -ExecutionPolicy Bypass -File "%SCRIPTS_PATH%\CleanReturn.ps1" ^
-AppId "%AppId%" -LauncherProcessName "%LauncherProcessName%" ^
-FlagFile %FlagFile% -GameProcessName "%GameProcessName%"

exit
