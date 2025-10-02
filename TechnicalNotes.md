## 🛠️ Technical Notes: CleanReturn

This document explains the inner workings of the `CleanReturn.ps1` script and templates.  
Most users won’t need this — the README.md Quick Start is enough.

---

## 📂 Repository Layout

CleanReturn/
├─ CleanReturn.ps1              # Core monitoring & cleanup script
├─ CleanReturn.config.example   # Example config (copy & rename to .config)
├─ README.md                    # Quick start guide
├─ TechnicalNotes.md            # Detailed breakdown
├─ Adding-New-Games.md          # Step-by-step user guide (new)
├─ LICENSE                      # GPLv3 license
└─ Templates/                   # Ready-to-use per-store templates
   ├─ Epic Games Store (Template).bat
   ├─ Steam Game (Template).bat
   ├─ Steam Game Exception (Template).bat
   └─ Non-Steam Game (Template).bat

---

## 1. Config System

### Location
- **Portable Logic:** `CleanReturn.config` is primarily looked for in the folder two directories up from the game's launcher script, specifically: **`[ES-DE Root]\Scripts\CleanReturn\CleanReturn.config`**. This ensures the scripts work regardless of which sub-folder the game `.bat` file is in.
- **Developer Fallback:** The templates include a secondary check that allows the developer (you) to run the scripts from a separate, hardcoded location during development. This is automatically ignored by end-users.

- Copy it from `CleanReturn.config.example`, rename, and edit paths once.

### Example
```ini
[SCRIPTS]
SCRIPTS_PATH=G:\ES-DE\Scripts\CleanReturn

[STEAM]
STEAM_EXE_PATH=C:\Program Files (x86)\Steam\steam.exe

[EPIC]
EPIC_SHORTCUTS_PATH=G:\ES-DE\Roms\Windows\Epic Shortcuts
```

Edit this file once for your system.

*All templates automatically load these values.

*Only game-specific values remain inside each .bat.


⚠️ Warning!! Config Location

The `CleanReturn.config` file must be placed in:

ES-DE\Scripts\CleanReturn\CleanReturn.config

Templates are hardcoded to look for it there. If it’s missing or located elsewhere, the scripts will stop with a clear error message.  



## 2. Placeholders (Per-Game Values)

Each template still requires per-game info:
| Variable              | Example Value                         | Required For                                  |
| --------------------- | ------------------------------------- | --------------------------------------------- |
| `AppId`               | `1353230`, `EPIC_CONTROL`             | All templates (Steam, Epic, Non-Steam)        |
| `GameProcessName`     | `Control_DX12.exe`                    | Required for Epic, Non-Steam, Steam Exception |
| `LauncherProcessName` | `steam`, `EpicGamesLauncher`, *blank* | Optional, depends on launcher                 |
| `GAME_PATH`           | `C:\Games\Blur\Blur.exe`              | Required for Non-Steam only

## 3. Validation System (v1.0+)

All templates now validate required values before launching.

**If something is missing or invalid:**

❌ Game does not launch.

A clear error message appears with instructions.

**If everything is correct:**

✅ Displays “Validation passed. Launching game…”

Game runs normally.

This prevents silent failures and ensures smoother setup.

## 4. Template Breakdowns


### Steam Game (Template)

* Works for most Steam games.  
* Launches the game directly through Steam using its `AppId`.  
* CleanReturn monitors the running game process automatically — `GameProcessName` is not required unless detection fails.  
* Uses `KILL_STEAM_FLAG.tmp` so Steam is only closed if it was launched by ES-DE.  

**Setup**  
1. Copy **Steam Game (Template).bat** from `/Templates` into your ES-DE `Roms\windows` folder.  
2. Rename it to the game’s name (e.g. `Blur.bat`).  
3. Edit the file and set the correct `AppId` (Steam game ID).  

---

### Steam Game Exception (Template)

* Use if automatic detection fails (some games use unusual executables).  
* Requires both `AppId` and `GameProcessName`.  
* Same Steam flag file system as the default template.  

**Setup**  
1. Copy **Steam Game Exception (Template).bat** into `Roms\windows`.  
2. Rename it (e.g. `Bomb Rush Cyberfunk.bat`).  
3. Edit the file:  
   - Set `AppId` (Steam game ID).  
   - Set `GameProcessName` (process name from Task Manager → Details tab).  

---

### Epic Games Store (Template)

* Epic does not allow direct `.exe` launching — games must be launched via `.url` shortcuts.  
* Each game must have a shortcut created in Epic Launcher:  
  - Right-click the game → Manage → Create Desktop Shortcut.  
  - Move the shortcut into the folder you set as `EPIC_SHORTCUTS_PATH` in `CleanReturn.config`.  
    - Example: if config has `EPIC_SHORTCUTS_PATH=G:\ES-DE\Roms\Windows\Epic Shortcuts`, then place `Control.url` there.  
* CleanReturn then launches `%EPIC_SHORTCUTS_PATH%\GameName.url`, monitors `GameProcessName`, and closes EpicGamesLauncher after exit.  

**Setup**  
1. Copy **Epic Games Store (Template).bat** into `Roms\windows`.  
2. Rename it (e.g. `Control.bat`).  
3. Edit the file and set:  
   - `AppId` (unique ID, e.g. `EPIC_CONTROL`).  
   - `GameProcessName` (from Task Manager → Details tab).  

---

### Non-Steam Game (Template)

* Launches a standalone `.exe` directly (no launcher).  
* Requires both `GAME_PATH` and `GameProcessName`.  
* No launcher cleanup is performed — CleanReturn just monitors the process and returns to ES-DE.  

**Setup**  
1. Copy **Non-Steam Game (Template).bat** into `Roms\windows`.  
2. Rename it (e.g. `Tony Hawk's American Wasteland.bat`).  
3. Edit the file and set:  
   - `AppId` (unique ID, e.g. `NONSTEAM_THAW`).  
   - `GAME_PATH` (full path to the game’s `.exe`).  
   - `GameProcessName` (process name from Task Manager).  

#
## 5. Flow of Execution

Here’s how CleanReturn works from launch to cleanup:

[ES-DE]
│
└─► Launch .bat template
│
├─► Loads CleanReturn.config (global paths)
├─► Sets per-game values (AppId, GameProcessName, etc.)
├─► Runs validation
│ ├─ If validation fails → show error, stop
│ └─ If validation passes → echo success, continue
├─► Launches game (via Steam/Epic/EXE)
└─► Runs CleanReturn.ps1
├─ Detects game process
├─ Monitors until process closes
└─ Performs cleanup
├─ Close Steam (if flag present)
├─ Close EpicGamesLauncher
└─ Return to ES-DE
#
## 6. Finding the Game Process Name

Required for:

Epic Games

*Non-Steam games

*Steam exceptions

Steps:

*Launch the game.

*Open Task Manager → Details tab.

*Find the .exe process.

*Use the exact name (with .exe).

Example: BombRushCyberfunk-Win64-Shipping.exe
#

## 7. Why Epic Cloud Saves Must Be Disabled

Epic Cloud Saves can create sync popups when a game is closed outside the Epic UI.
Disabling this ensures CleanReturn can exit the Epic launcher silently without interruption.

***

## 8. Troubleshooting

Game doesn’t close properly → Check GameProcessName matches the process in Task Manager.

Launcher stays open → Verify flag file path in the .bat matches CleanReturn.config.

FINDSTR: Cannot open CleanReturn.config → You didn’t copy CleanReturn.config.example into the Scripts folder and rename it.

Script won’t run → Run PowerShell as Admin:
Set-ExecutionPolicy RemoteSigned
#

## 9. Security Notes

Batch files call PowerShell with -ExecutionPolicy Bypass.
This only affects the local, trusted CleanReturn.ps1.
No remote code is executed.




### 🔐 Advanced: Self-Signing for Stricter Policies

For users who prefer **not** to rely on `-ExecutionPolicy Bypass`, you can sign `CleanReturn.ps1` with a self-signed certificate:

1. Open PowerShell as Administrator.  
2. Create a self-signed certificate:  

   ```powershell
   New-SelfSignedCertificate -Type CodeSigningCert -Subject "CN=CleanReturn"
   ```

3. Sign the script:
Set-AuthenticodeSignature -FilePath "CleanReturn.ps1" -Certificate (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)[0]

4. Change your execution policy to only allow signed scripts: Set-ExecutionPolicy AllSigned
This way, PowerShell will only run scripts you have explicitly signed, adding another layer of trust.

***

### 10. Future Improvements / Roadmap

Planned/potential enhancements:

Additional launcher support (GOG, Ubisoft Connect, Xbox PC Game Pass).

Optional logging of launches, exits, and cleanup results.

Enhanced security (signed scripts, configurable execution modes).

Cross-platform considerations (Linux + Proton/Wine).


