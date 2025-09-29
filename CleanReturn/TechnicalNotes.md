## 🛠️ Technical Notes: CleanReturn

This document explains the inner workings of the CleanReturn.ps1 script and templates.
Most users won’t need this — the README.md Quick Start is enough.

## 📂 Repository Layout

CleanReturn/
├─ CleanReturn.ps1              # Core monitoring & cleanup script
├─ README.md                    # Quick start guide
├─ TechnicalNotes.md            # This file (detailed breakdown)
├─ LICENSE                      # License (GPLv3)
└─ Templates/                   # Ready-to-use per-store templates
├─ CleanReturn.config         # Global config (set paths once)
├─ Epic Games Store (Example).bat
├─ Steam Game (Default).bat
├─ Steam Game Exception (Example).bat
└─ Non Steam Game (Example).bat

---

## 1. Config System

[SCRIPTS]
SCRIPTS_PATH=G:\ES-DE\Scripts\CleanReturn

[STEAM]
STEAM_EXE_PATH=C:\Program Files (x86)\Steam\steam.exe

[EPIC]
EPIC_SHORTCUTS_PATH=G:\ES-DE\Roms\Windows\Epic Shortcuts

* Edit this file once for your system.
* All templates automatically load these values.
* Only game-specific values remain inside each .bat.

---

## 2. Placeholders (Per-Game Values)

Each template still requires game-specific info:

| Variable              | Example Value                                              | Description                        |
| --------------------- | ---------------------------------------------------------- | ---------------------------------- |
| `AppId`               | `EPIC_CONTROL`, `1353230`, `NONSTEAM_BLUR`                 | Unique identifier for the game     |
| `GameProcessName`     | `Control_DX12`, `Blur`, `BombRushCyberfunk-Win64-Shipping` | Exact process name (no `.exe`)     |
| `LauncherProcessName` | `steam`, `EpicGamesLauncher`, *blank*                      | Which launcher to close afterwards |
| `start "" "..."`      | `C:\Games\Blur\Blur.exe`                                   | (Non-Steam only) Path to `.exe`    |

---

## 3. Steam Flag File System

Steam templates create a temporary flag file (KILL_STEAM_FLAG.tmp) so the script knows whether Steam was launched from ES-DE:

* The .bat file creates the flag file.
* CleanReturn.ps1 checks for it.
* If found → Steam is closed after the game exits.
* The flag file is then deleted.

This prevents shutting down Steam if it wasn’t launched by ES-DE.

##

## 4. Template Breakdowns

**Epic Games Template**

* Launch via Epic .url shortcut and clean up EpicGamesLauncher.

**Steam Template (Default)**

* Recommended for most Steam games.

**Steam Template (Exception)**

* Use if automatic detection fails. Requires manual `GameProcessName`.

**Non-Steam Game Template**

* Launches a standalone .exe. No launcher cleanup.

---

## 5. Flow of Execution

Here’s how CleanReturn works from launch to cleanup:

[ES-DE]
│
└─► Launch .bat template
│
├─► Loads CleanReturn.config (global paths)
├─► Sets game-specific values
├─► Launches game (via Steam/Epic/EXE)
└─► Runs CleanReturn.ps1
│
├─► Detect game process
├─► Monitor until process closes
└─► Cleanup
├─► Close Steam (if flag present)
├─► Close EpicGamesLauncher
└─► Return to ES-DE

* This ensures a controller-only loop:
  ES-DE → Game → ES-DE (no Alt+Tab, no lingering launchers).

---

## 6. Finding the Game Process Name

Required for:

* Epic Games
* Non-Steam games
* Steam exceptions

Steps:

1. Launch the game.
2. Open Task Manager → Details tab.
3. Find the .exe process.
4. Use the exact name (without .exe).

Example: `BombRushCyberfunk-Win64-Shipping` (not just “Bomb Rush Cyberfunk”).

---

## 7. Why Epic Cloud Saves Must Be Disabled

Epic Cloud Saves can create sync popups when a game is closed outside the Epic UI.
Disabling this ensures CleanReturn can exit the Epic launcher silently without interruption.

---

## 8. Troubleshooting

* **Game doesn’t close properly:** Check `GameProcessName` matches the process list in Task Manager.
* **Launcher stays open:** Verify flag file path in the .bat matches your config.
* **Script won’t run:** Run PowerShell as Admin:

  ```powershell
  Set-ExecutionPolicy RemoteSigned
  ```

---

## 9. Security Notes

Batch files call PowerShell with `-ExecutionPolicy Bypass`.
This only affects the local, trusted `CleanReturn.ps1`.
No remote code is executed.

### 🔐 Advanced: Self-Signing for Stricter Policies

For users who prefer **not** to rely on `-ExecutionPolicy Bypass`, you can sign `CleanReturn.ps1` with a self-signed certificate:

1. Open PowerShell as Administrator.
2. Create a self-signed certificate:

   ```powershell
   New-SelfSignedCertificate -Type CodeSigningCert -Subject "CN=CleanReturn"
   ```
3. Sign the script:

   ```powershell
   Set-AuthenticodeSignature -FilePath "CleanReturn.ps1" -Certificate (Get-ChildItem Cert:\CurrentUser\My -CodeSigningCert)[0]
   ```
4. Change your execution policy to only allow signed scripts:

   ```powershell
   Set-ExecutionPolicy AllSigned
   ```

This way, PowerShell will only run scripts you have explicitly signed, adding another layer of trust.

---

## 10. Future Improvements / Roadmap

Planned/potential future enhancements to CleanReturn:

* Additional Launcher Support (GOG Galaxy, Ubisoft Connect, Xbox PC Game Pass).
* Unified Config for Per-Game Settings (centralize `AppId`, `GameProcessName`, and `ExePath`).
* Templates become fully generic — no edits needed.
* Logging system (optional logging of launches, exits, and cleanup results).
* Enhanced security options (signed scripts, configurable execution policy modes).
* Cross-platform considerations (investigate Linux + Proton/Wine compatibility).

ES-DE is cross-platform, so CleanReturn could eventually be too.
