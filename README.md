# 🎮 CleanReturn-for-ES-DE

**CleanReturn** is a lightweight script system for managing Steam, Epic Games Store, and Non-Steam games in [ES-DE (EmulationStation Desktop Edition)](https://es-de.org/).  
It ensures a seamless controller-only loop: **ES-DE → Game → ES-DE** — no lingering launchers or Alt+Tab required.

---

## 🚀 Quick Start

### 1. Download / Clone
Clone this repository or download the latest release from the [Releases](https://github.com/your-repo/releases) page.

### 2. Create Config
Copy `CleanReturn.config.example` into the **Scripts folder** (where `CleanReturn.ps1` is located).  
Rename it to `CleanReturn.config` and edit the paths for your system:

```ini
[SCRIPTS]
SCRIPTS_PATH=G:\ES-DE\Scripts\CleanReturn

[STEAM]
STEAM_EXE_PATH=C:\Program Files (x86)\Steam\steam.exe

[EPIC]
EPIC_SHORTCUTS_PATH=G:\ES-DE\Roms\Windows\Epic Shortcuts
```

### ⚠️ Important: CleanReturn.config must be placed in:
* ES-DE\Scripts\CleanReturn\CleanReturn.config 
  If the file is missing or in the wrong place, templates will fail with a clear error message:
  
> **⚠️ CRITICAL ERROR: CleanReturn.config not found.**
> Please ensure the config is copied and correctly named in the Scripts folder.

- The new templates are designed to be robust, but the config must be named `CleanReturn.config` and be present in the main **Scripts folder** next to `CleanReturn.ps1`.

## 3. Pick a Template

**Steam Game Template**

* Works for most Steam games.  
* Launches the game directly through Steam using its `AppId`.  
* CleanReturn monitors the running game process automatically — you don’t need to set `GameProcessName` unless detection fails.  
* After the game exits, if Steam was launched by ES-DE, it is closed automatically.  

Setup:  
1. Copy **Steam Game (Template).bat** from `/Templates` into your ES-DE `Roms\windows` folder.  
2. Rename it (e.g. `Blur.bat`).  
3. Edit the file and set the correct `AppId` (find this on the game’s SteamDB page or in Steam’s launch options).  

---

**Steam Game Exception Template**

* Use this when CleanReturn cannot automatically detect the game process (rare, but happens with some titles).  
* Works the same way as the default Steam template, but requires you to manually set `GameProcessName`.  
* `GameProcessName` must match the process name shown in Task Manager (no `.exe` extension needed).  

Setup:  
1. Copy **Steam Game Exception (Template).bat** from `/Templates` into your ES-DE `Roms\windows` folder.  
2. Rename it (e.g. `Bomb Rush Cyberfunk.bat`).  
3. Edit the file:  
   - Set `AppId` (Steam game ID).  
   - Set `GameProcessName` (from Task Manager → Details tab).  

---  
# 

**Non-Steam Game Template**

* Launches a standalone `.exe` game with no launcher involved.  
* Requires both `GAME_PATH` (full path to the game’s executable) and `GameProcessName` (so CleanReturn can monitor and detect when the game closes).  
* No launcher cleanup is performed, since the game runs directly.  

Setup:  
1. Copy **Non-Steam Game (Template).bat** from `/Templates` into your ES-DE `Roms\windows` folder.  
2. Rename it (e.g. `Tony Hawk's American Wasteland.bat`).  
3. Edit the file and set:  
   - `AppId` (give it a unique identifier, e.g. `NONSTEAM_THAW`).  
   - `GAME_PATH` (full path to the game’s `.exe`, e.g. `G:\PC Games\THAW\Game\reTHAWed.exe`).  
   - `GameProcessName` (the process name from Task Manager, e.g. `reTHAWed.exe`).  
4. Launch from ES-DE — CleanReturn will start the game, monitor the process, and return you cleanly back to ES-DE after exit.  

# 
- **Epic Games Store (Template).bat** → Launches `.url` shortcuts, requires `GameProcessName`

ℹ️ **Epic Games setup note**  
Epic does not allow games to be launched directly by .exe.  
Instead, you must create a shortcut for each game from the Epic Launcher:  
- In Epic, right-click the game → Manage → Create Desktop Shortcut.  
- Move the shortcut (.url file) into the folder you set as `EPIC_SHORTCUTS_PATH` in CleanReturn.config.  
  - Example: if your config has `EPIC_SHORTCUTS_PATH=G:\ES-DE\Roms\Windows\Epic Shortcuts`  
    then place the shortcut (e.g. `Control.url`) into that folder.  
- Copy the **Epic Games Store (Template).bat** from `/Templates` into your ES-DE `Roms\windows` folder.  
- Rename it (e.g. `Control.bat`) and edit the `AppId` and `GameProcessName` values inside.  
## 


## 4. Edit Per-Game Values

Each template includes placeholders you must fill in:
| Variable              | Example Value                               | Required For                                  |
| --------------------- | ------------------------------------------- | --------------------------------------------- |
| `AppId`               | `1353230`, `EPIC_CONTROL`, `NONSTEAM_MYEXE` | All templates (Steam, Epic, Non-Steam)        |
| `GameProcessName`     | `Control_DX12.exe`                          | Required for Epic, Non-Steam, Steam Exception |
| `LauncherProcessName` | `steam`, `EpicGamesLauncher`, *blank*       | Optional, depends on launcher                 |
| `GAME_PATH`           | `C:\Games\Blur\Blur.exe`                    | Required for Non-Steam only                   |

👉 For a detailed step-by-step walkthrough with examples, see [Adding-New-Games.md](Adding-New-Games.md)

## 5. Launch via ES-DE

Place the .bat files in your ES-DE Windows ROMs folder (e.g. G:\ES-DE\Roms\windows) and launch them directly from ES-DE.

## 🔧 Validation System (v1.0+)

Before launching, templates validate required values.

If something is missing or incorrect:

❌ The game will not launch

A clear error message will appear with step-by-step fix instructions
##
If everything is correct:

✅ You’ll see “Validation passed. Launching game…”

The game launches normally

This prevents silent failures and makes setup easier for new users.
##

## 🛠️ Troubleshooting

FINDSTR: Cannot open CleanReturn.config
→ You forgot to copy CleanReturn.config.example to CleanReturn.config.

Game doesn’t close properly
→ Check that GameProcessName matches Task Manager’s process name exactly.

Launcher stays open
→ Ensure the flag file path in your template matches CleanReturn.config.

Scripts won’t run
→ Run PowerShell as Admin and set execution policy:
```Set-ExecutionPolicy RemoteSigned```

##
## 📝 Changelog
### v1.0.0 — First Release

- Core cleanup script (`CleanReturn.ps1`).
- Config system (`CleanReturn.config`):
  - Copy `CleanReturn.config.example` → rename to `CleanReturn.config`.
  - Place in Scripts folder with `CleanReturn.ps1`.
- Four ready-to-use templates:
  - Steam Game (Template).bat
  - Steam Game Exception (Template).bat
  - Epic Games Store (Template).bat
  - Non-Steam Game (Template).bat
- **Validation system**:
  - Prevents launching if `AppId`, `GameProcessName`, or `GAME_PATH` are missing.
  - Clear error messages with step-by-step fix instructions.
  - ✅ Success message *“Validation passed. Launching game…”* when setup is correct.
- Unified template structure (Validation → Launch → Cleanup).
- Improved error display formatting for clarity.
- Documentation updated:
  - `README.md` (quick start + validation info)
  - `TechnicalNotes.md` (detailed breakdown)
  - `Adding-New-Games.md` (step-by-step guide)

##

## ❤️ Support This Project

I built this project to make ES-DE integration easier for everyone, these things take time & effort.

I would really appreciate a cup of coffee if this helped you out. ☕

- [Buy Me a Coffee] https://buymeacoffee.com/pirateai001

---

## 🔗 More Projects

I plan to release more tools like this.
Check my [GitHub profile](https://github.com/yourname) to see other projects I’m working on!

---

## ⚖️ License

This project is licensed under the **GNU GPLv3**.

You are free to use, share, and modify this project for **personal use**.
If you are interested in commercial use or integration into a paid product, please contact me.

👉 See the [LICENSE](./LICENSE) file or the full text at
[https://www.gnu.org/licenses/gpl-3.0.txt](https://www.gnu.org/licenses/gpl-3.0.txt).
---


