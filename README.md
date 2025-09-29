## 🎮 CleanReturn for ES-DE 🎮

Seamless, controller-only PC game launching in EmulationStation Desktop Edition (ES-DE).

✅ No Alt+Tabbing
✅ Launchers close automatically when you exit
✅ Instant return to ES-DE
##
                            5 Step Quick Start guide 

## 1. Copy Files
Place the entire CleanReturn folder into your ES-DE scripts directory.


## 2. Create Config (once)
Rename `/Templates/CleanReturn.config.example` to `/Templates/CleanReturn.config`,  
   then edit it with your system paths::

- [SCRIPTS]
SCRIPTS_PATH=G:\ES-DE\Scripts\CleanReturn

- [STEAM]
STEAM_EXE_PATH=C:\Program Files (x86)\Steam\steam.exe

- [EPIC]
EPIC_SHORTCUTS_PATH=G:\ES-DE\Roms\Windows\Epic Shortcuts

##

## 3. Pick a Template
Copy one of the ready-to-use templates in /Templates and rename it for your game:

- Epic Games Store (Template).bat

- Steam Game (Default Template).bat

- Steam Game Exception (Template).bat

- Non Steam Game (Template).bat


##


## 4. Edit Per-Game Values
Inside your copied .bat file, update only:

- AppId → Steam ID, Epic shortcut name, or label (Non-Steam).

- GameProcessName → exact process name (no .exe).

- start "" "<path-to-game.exe>" → for Non-Steam only.

##

## 5. Add to ES-DE
Add your .bat as if it were a ROM. That’s it 🎉
##

## 🛠 Storefront Notes

Epic Games:

- Disable Cloud Saves to avoid sync popups.

- Move the game’s .url shortcut into %EPIC_SHORTCUTS_PATH%.

Steam:

- Use the game’s App ID (from its store URL).

## ***If Steam doesn’t close, use the “Exception” template and set GameProcessName*.


Non-Steam:

- Point directly to the game .exe.

- No launcher cleanup needed.

##

## ⚠️ Troubleshooting

Launcher not closing
- Check GameProcessName matches Task Manager (Details tab).

Game not closing 
- Verify the path to CleanReturn.ps1 in your config.

Script won’t run 
- Run PowerShell as Administrator once:

- Set-ExecutionPolicy RemoteSigned


##
## 🔒 Security

Batch files use:

powershell -ExecutionPolicy Bypass -File "CleanReturn.ps1"

- This only runs the local, trusted CleanReturn.ps1.

- No internet code is executed.

## (For advanced users: see TechnicalNotes.md for optional self-signing & stricter execution policies.)

##
## 📂 Repository Layout
CleanReturn/
├─ CleanReturn.ps1              # Core monitoring & cleanup script
├─ README.md                    # Quick start guide
├─ TechnicalNotes.md            # Deep dive (advanced users)
├─ LICENSE                      # GPLv3 license
└─ Templates/                   # Ready-to-use .bat templates
   ├─ CleanReturn.config
   ├─ Epic Games Store (Template).bat
   ├─ Steam Game (Default Template).bat
   ├─ Steam Game Exception (Template).bat
   └─ Non Steam Game (Template).bat
##
## 🌍 Notes

🖥 Windows only (PowerShell + Batch).

ES-DE is cross-platform, but Linux/Proton support is a future goal.
##

## 🚀 Roadmap

- Additional launcher support (GOG, Ubisoft Connect, Xbox PC Game Pass).

- Unified per-game config (no editing .bat files).

- Logging system (track launches & exits).

- Cross-platform investigation (Linux + Proton/Wine).
##



## ❤️ Support This Project

I built this project to make ES-DE integration easier for everyone, these things take time & effort.

I would really appreciate a cup of coffee if this helped you out. ☕:)

- Buy Me a Coffee: https://buymeacoffee.com/pirateai001

---

## 🔗 More Projects

I plan to release more tools like this.
Check & Bookmark my [GitHub profile](https://github.com/yourname) to see other projects I’m working on as they become available!

---

## ⚖️ License

This project is licensed under the **GNU GPLv3**.

You are free to use, share, and modify this project for **personal use**.
If you are interested in commercial use or integration into a paid product, please contact me.

👉 See the [LICENSE](./LICENSE) file or the full text at
[https://www.gnu.org/licenses/gpl-3.0.txt](https://www.gnu.org/licenses/gpl-3.0.txt).
