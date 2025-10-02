# 🕹️ Adding New Games to CleanReturn

This guide explains how to add your own games into **ES-DE** using CleanReturn templates.  
It expands on the Quick Start in `README.md` with step-by-step instructions and examples.

---

## 1. Pick the Right Template

Go into the **`Templates/`** folder and copy the one that matches your game:

- **Steam Game (Template).bat** → Most Steam games  
- **Steam Game Exception (Template).bat** → Steam games that need manual `GameProcessName`  
- **Epic Games Store (Template).bat** → Epic games (uses `.url` shortcut)  
- **Non-Steam Game (Template).bat** → Standalone `.exe` (games outside Steam/Epic)  

---

## 2. Copy into Roms/windows

Paste the template into your **`Roms/windows`** folder (where ES-DE looks for games).  
Rename the file to your game’s name, for example:

Blur.bat
Control.bat
Tony Hawk's Pro Skater ReTHAWed.bat


---

## 3. Edit Game-Specific Values

Open the `.bat` file in a text editor and fill in the placeholders.

### 🔹 Common to All
- **AppId**  
  - Steam: the game’s App ID (from SteamDB).  
  - Epic: unique tag like `EPIC_CONTROL`.  
  - Non-Steam: something like `NONSTEAM_BLUR`.  

- **GameProcessName**  
  - The process name shown in Task Manager (e.g. `Blur.exe`, `Control_DX12.exe`).  
  - Required for Epic, Non-Steam, and Steam Exception templates.  
  - ❗ Not required for the default Steam template.  

- **LauncherProcessName**  
  - Steam template: `steam`  
  - Epic template: `EpicGamesLauncher`  
  - Non-Steam: leave blank  

### 🔹 Non-Steam only
- **GAME_PATH**  
  - Full path to the `.exe`, for example:  
    ```
    set "GAME_PATH=G:\PC Games\Blur\Blur.exe"
    ```
  - Also update the `cd /d` line to match the folder:
    ```
    cd /d "G:\PC Games\Blur"
    ```

---

## 4. Run Validation

When you launch the game from ES-DE:

- ❌ If something is missing, you’ll see a clear error message (e.g. missing `GameProcessName`).  
- ✅ If all values are correct, you’ll see:  

Validation passed. Launching game…

---

## 5. Clean Return

While the game runs, **CleanReturn.ps1** monitors the process:

- When the game closes → Steam/Epic launcher (if opened by ES-DE) is also closed.  
- You are returned cleanly back to ES-DE without Alt+Tab or lingering processes.

---

## 📌 Example: Blur (Non-Steam)

```bat
set AppId=NONSTEAM_BLUR
set GameProcessName=Blur.exe
set LauncherProcessName=
set "GAME_PATH=G:\PC Games\Blur\Blur.exe"

cd /d "G:\PC Games\Blur"
start "" "%GAME_PATH%"
✅ Summary

Templates/ = master copies (don’t edit).

Roms/windows/ = your per-game launchers (copies filled in with real values).

👉 If you get stuck, double-check Task Manager for the correct process name or re-check your GAME_PATH.

