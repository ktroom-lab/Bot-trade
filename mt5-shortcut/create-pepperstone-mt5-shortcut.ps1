<#
  Create a desktop / Start Menu shortcut for Pepperstone MetaTrader 5.
  The shortcut uses the icon embedded in Pepperstone's terminal64.exe.

  Usage:
    powershell -ExecutionPolicy Bypass -File .\create-pepperstone-mt5-shortcut.ps1
    powershell -ExecutionPolicy Bypass -File .\create-pepperstone-mt5-shortcut.ps1 -TerminalPath "D:\MT5\terminal64.exe"
#>
param(
    [string]$TerminalPath,
    [string]$Name = "Pepperstone MT5",
    [string]$Hotkey = "CTRL+ALT+M",
    [switch]$NoStartMenu
)

$ErrorActionPreference = "Stop"

function Find-PepperstoneTerminal {
    # 1) Default install folders
    $roots = @($env:ProgramFiles, ${env:ProgramFiles(x86)}, "$env:LOCALAPPDATA\Programs") | Where-Object { $_ }
    foreach ($root in $roots) {
        $candidate = Join-Path $root "Pepperstone MetaTrader 5\terminal64.exe"
        if (Test-Path $candidate) { return $candidate }
    }

    # 2) Installed-programs registry entries
    $uninstallKeys = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    $entries = Get-ItemProperty $uninstallKeys -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -like "*Pepperstone*" -and $_.DisplayName -like "*MetaTrader 5*" }
    foreach ($entry in $entries) {
        foreach ($dir in @($entry.InstallLocation, (Split-Path ([string]$entry.DisplayIcon -replace '"|,\d+$', '') -Parent))) {
            if ($dir) {
                $candidate = Join-Path $dir "terminal64.exe"
                if (Test-Path $candidate) { return $candidate }
            }
        }
    }

    # 3) Any folder with "Pepperstone" in its name under Program Files
    foreach ($root in $roots) {
        $hit = Get-ChildItem $root -Directory -Filter "*Pepperstone*" -ErrorAction SilentlyContinue |
            ForEach-Object { Join-Path $_.FullName "terminal64.exe" } |
            Where-Object { Test-Path $_ } |
            Select-Object -First 1
        if ($hit) { return $hit }
    }
    return $null
}

if (-not $TerminalPath) { $TerminalPath = Find-PepperstoneTerminal }
if (-not $TerminalPath -or -not (Test-Path $TerminalPath)) {
    Write-Host "Pepperstone MT5 (terminal64.exe) not found." -ForegroundColor Red
    Write-Host 'Run again with: -TerminalPath "C:\path\to\terminal64.exe"'
    exit 1
}
$TerminalPath = (Resolve-Path $TerminalPath).Path
Write-Host "Found: $TerminalPath" -ForegroundColor Green

$shell = New-Object -ComObject WScript.Shell
$targets = @([Environment]::GetFolderPath("Desktop"))
if (-not $NoStartMenu) { $targets += [Environment]::GetFolderPath("Programs") }

foreach ($folder in $targets) {
    $lnkPath = Join-Path $folder "$Name.lnk"
    $lnk = $shell.CreateShortcut($lnkPath)
    $lnk.TargetPath = $TerminalPath
    $lnk.WorkingDirectory = Split-Path $TerminalPath -Parent
    $lnk.IconLocation = "$TerminalPath,0"
    $lnk.Description = "Open Pepperstone MetaTrader 5"
    # Hotkey only on the desktop shortcut so it is not registered twice
    if ($Hotkey -and $folder -eq $targets[0]) { $lnk.Hotkey = $Hotkey }
    $lnk.Save()
    Write-Host "Created: $lnkPath"
}

if ($Hotkey) { Write-Host "Hotkey: $Hotkey" }
Write-Host "Done. Tip: right-click the desktop icon > 'Pin to taskbar' / 'Pin to Start'."
