param (
    [string]$AppId,
    [string]$LauncherProcessName,
    [string]$FlagFile,
    [string]$GameProcessName
)

# --- CONFIG VALIDATION START ---

$ErrorsFound = $false

# Check that required params are not empty
if (-not $AppId) {
    Write-Host "❌ Config Error: AppId is missing."
    $ErrorsFound = $true
}

if (-not $GameProcessName) {
    Write-Host "❌ Config Error: GameProcessName is missing."
    $ErrorsFound = $true
}

# Check that scripts path exists
if (-not (Test-Path $PSScriptRoot)) {
    Write-Host "❌ Config Error: Scripts path ($PSScriptRoot) not found."
    $ErrorsFound = $true
}

# Check that FlagFile directory is valid (if defined)
if ($FlagFile -and -not (Test-Path (Split-Path $FlagFile))) {
    Write-Host "❌ Config Error: FlagFile directory does not exist: $FlagFile"
    $ErrorsFound = $true
}

# If any validation failed, stop execution
if ($ErrorsFound) {
    Write-Host "🚫 Validation failed. Fix config before continuing."
    exit 1
}

# --- CONFIG VALIDATION END ---

# Existing CleanReturn logic continues below...
# e.g. Monitor process, cleanup, etc.
