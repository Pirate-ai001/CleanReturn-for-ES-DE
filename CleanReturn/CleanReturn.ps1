param(
    [string]$AppId,
    [string]$LauncherProcessName,
    [string]$FlagFile,
    [string]$GameProcessName = "", # Supports comma-separated list
    [string]$SteamPath = ""        # Override Steam path if desired
)

# =================================================================
# CONFIG LOADING
# =================================================================

# Function to parse INI-style config file
function Load-Config {
    param([string]$Path)
    $dict = @{}

    if (-not (Test-Path $Path)) {
        Write-Host "No config file found at $Path, skipping."
        return $dict
    }

    Write-Host "Loading configuration from $Path"

    foreach ($line in Get-Content $Path) {
        if ($line -match '^\s*;' -or $line -match '^\s*$') { continue } # Skip comments/empty lines
        if ($line -match '^\s*\[(.+)\]\s*$') {
            $section = $matches[1]
            continue
        }
        if ($line -match '^\s*([^=]+)=(.+)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            if ($section) {
                $dict["$section.$key"] = $value
            } else {
                $dict[$key] = $value
            }
        }
    }
    return $dict
}

# Load config file from same folder as script
$configPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "CleanReturn.config"
$config = Load-Config $configPath

# Apply config defaults if parameters were not provided
if (-not $SteamPath -and $config.ContainsKey("STEAM.STEAM_EXE_PATH")) {
    $SteamPath = $config["STEAM.STEAM_EXE_PATH"]
}
if (-not $LauncherProcessName -and $config.ContainsKey("DEFAULT.LauncherProcessName")) {
    $LauncherProcessName = $config["DEFAULT.LauncherProcessName"]
}

# =================================================================
# UTILITY FUNCTION
# =================================================================

function IsProcessRunning {
    param([string[]]$ProcessNames)
    foreach ($Name in $ProcessNames) {
        if (Get-Process -Name $Name -ErrorAction SilentlyContinue) {
            return $true
        }
    }
    return $false
}

# =================================================================
# SCRIPT START
# =================================================================

# 1. Determine the FINAL Game Process Name(s) to monitor.
$ProcessToMonitor = $null
$ProcessesToMonitorArray = @()

# --- A. Use explicit override ---
if (-not [string]::IsNullOrEmpty($GameProcessName)) {
    $ProcessToMonitor = $GameProcessName
    Write-Host "Using explicit GameProcessName(s): $ProcessToMonitor"

} 
# --- B. Auto-detect for Steam ---
elseif ($LauncherProcessName -ieq "steam") {
    if (-not $SteamPath) {
        $SteamPath = "C:\Program Files (x86)\Steam\steam.exe" # fallback
    }
    $steamDir = Split-Path $SteamPath -Parent
    $AppManifestPath = Join-Path $steamDir "steamapps\appmanifest_$AppId.acf"

    if (Test-Path $AppManifestPath) {
        $Content = Get-Content $AppManifestPath -Encoding UTF8 | Out-String
        $Match = [regex]::Match($Content, '"installdir"\s+"([^"]+)"')
        
        if ($Match.Success) {
            $ProcessToMonitor = $Match.Groups[1].Value
            Write-Host "Steam manifest found for App ID $AppId, process guess: $ProcessToMonitor"
        }
    }
}

# --- C. Validation ---
if (-not $ProcessToMonitor) {
    Write-Error "Could not determine process name for App ID $AppId or GameProcessName. Cannot proceed."
    exit 1
}

# Split into array if multiple processes
$ProcessesToMonitorArray = $ProcessToMonitor.Split(',') | ForEach-Object { $_.Trim() }
Write-Host "Monitoring processes: $($ProcessesToMonitorArray -join ', ')"

# =================================================================
# 2. WAIT FOR GAME TO START
# =================================================================
$WaitTime = 0
$MaxWait = 60
do {
    Start-Sleep -Seconds 2
    $IsRunning = IsProcessRunning -ProcessNames $ProcessesToMonitorArray
    $WaitTime += 2
} until ($IsRunning -or $WaitTime -ge $MaxWait)

if (-not $IsRunning) {
    Write-Error "Game process(es) '$($ProcessesToMonitorArray -join ', ')' did not start within $MaxWait seconds."
} else {
    Write-Host "Game started. Monitoring until closure..."
    
    # =================================================================
    # 3. MONITOR UNTIL GAME CLOSES
    # =================================================================
    $MonitorTime = 0
    $MaxMonitor = 7200 # 2 hours
    do {
        Start-Sleep -Seconds 5
        $IsRunning = IsProcessRunning -ProcessNames $ProcessesToMonitorArray
        $MonitorTime += 5
    } until (-not $IsRunning -or $MonitorTime -ge $MaxMonitor)

    if ($MonitorTime -ge $MaxMonitor) {
        Write-Warning "Maximum monitor time reached. Forcing cleanup."
    } else {
        Write-Host "Game closed."
    }
}

# =================================================================
# 4. CLEANUP LAUNCHER
# =================================================================
if ($LauncherProcessName -ieq "steam") {
    if (Test-Path $FlagFile) {
        Write-Host "Steam flag detected. Closing Steam."
        & "$SteamPath" -shutdown
        Remove-Item $FlagFile -ErrorAction SilentlyContinue
    } else {
        Write-Host "Steam flag not found. Leaving Steam open."
    }
}
elseif (-not [string]::IsNullOrEmpty($LauncherProcessName)) {
    Write-Host "Closing $LauncherProcessName."
    Stop-Process -Name $LauncherProcessName -Force -ErrorAction SilentlyContinue
}
