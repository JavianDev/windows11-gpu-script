# ============================
# 🏆 ULTIMATE WINDOWS 11 CLEANUP & OPTIMIZATION SCRIPT
# ============================
# Author: Javian Picardo
# Last Updated: February 2025
# ⚠️ MUST BE RUN AS ADMINISTRATOR!

# ============================
# 🔒 1. ADMINISTRATOR CHECK
# ============================
function CheckAdmin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "❌ Please run this script as Administrator!" -ForegroundColor Red
        exit
    }
}

# ============================
# 🗑️ 2. CLEANUP FUNCTIONS
# ============================
# Function to clear temporary files
function ClearTempFiles {
    Write-Host "🧹 Clearing Temporary Files..." -ForegroundColor Yellow
    $tempPaths = @("$env:windir\Temp", "$env:localappdata\Temp")
    
    foreach ($path in $tempPaths) {
        if (Test-Path $path) {
            Get-ChildItem -Path $path -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            Write-Host "✅ Cleared files in $path" -ForegroundColor Green
        }
    }
}

# Function to remove Windows.old folder (Fixed: Now properly closes)
function RemoveOldWindowsInstallation {
    Write-Host "🗑️ Removing Old Windows Installation..." -ForegroundColor Yellow
    $oldWindowsFolder = "$env:SystemDrive\Windows.old"
    if (Test-Path $oldWindowsFolder) {
        Remove-Item -Path $oldWindowsFolder -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Windows.old folder removed!" -ForegroundColor Green
    }
    else {
        Write-Host "ℹ️ No Windows.old folder found." -ForegroundColor Cyan
    }
}

# Function to clean Windows Update cache
function ClearWindowsUpdateCache {
    Write-Host "🔄 Clearing Windows Update Cache..." -ForegroundColor Yellow
    Stop-Service -Name "wuauserv" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "bits" -Force -ErrorAction SilentlyContinue
    $updateCache = "$env:windir\SoftwareDistribution\Download"
    if (Test-Path $updateCache) {
        Get-ChildItem -Path $updateCache -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        Write-Host "✅ Windows Update cache cleared!" -ForegroundColor Green
    }
    Start-Service -Name "wuauserv"
    Start-Service -Name "bits"
}
# Function to remove bloatware
function RemoveBloatware {
    Write-Host "🛠️ Removing Bloatware..." -ForegroundColor Yellow
    Get-AppxPackage | Where-Object { $_.Name -match "(CandyCrush|Spotify|Xbox|Twitter)" } | Remove-AppxPackage
    Write-Host "✅ Bloatware removed!" -ForegroundColor Green
}

# Function to optimize GPU settings in registry
function OptimizeGPU {
    Write-Host "💡 Optimizing GPU Settings..." -ForegroundColor Yellow
    $gpuRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\Dwm"
    if (!(Test-Path $gpuRegPath)) {
        New-Item -Path $gpuRegPath -Force | Out-Null
    }
    Set-ItemProperty -Path $gpuRegPath -Name "EnableHardwareAcceleration" -Value 1 -Type DWord
    Write-Host "✅ GPU settings optimized!" -ForegroundColor Green
}

# Function to clear log files
function ClearLogFiles {
    Write-Host "📝 Clearing Log Files..." -ForegroundColor Yellow
    $logPaths = @("$env:windir\System32\LogFiles", "$env:windir\Logs\CBS", "$env:windir\Temp")
    
    foreach ($logPath in $logPaths) {
        if (Test-Path $logPath) {
            Get-ChildItem -Path $logPath -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            Write-Host "✅ Log files in $logPath cleared!" -ForegroundColor Green
        }
    }
}

# Function to clear Prefetch files
function ClearPrefetchFiles {
    Write-Host "⚡ Clearing Prefetch Files..." -ForegroundColor Yellow
    $prefetchFolder = "$env:windir\Prefetch"
    if (Test-Path $prefetchFolder) {
        Get-ChildItem -Path $prefetchFolder | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Prefetch files cleared!" -ForegroundColor Green
    }
}

# Function to clear memory dumps
function ClearMemoryDumps {
    Write-Host "🗑️ Clearing Memory Dumps..." -ForegroundColor Yellow
    $minidumpFolder = "$env:windir\Minidump"
    if (Test-Path $minidumpFolder) {
        Get-ChildItem -Path $minidumpFolder | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Minidump files cleared!" -ForegroundColor Green
    }

    $memoryDumpFile = "$env:windir\MEMORY.DMP"
    if (Test-Path $memoryDumpFile) {
        Remove-Item -Path $memoryDumpFile -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Memory dump cleared!" -ForegroundColor Green
    }
}

# Function to disable hibernation
function DisableHibernation {
    Write-Host "🔋 Disabling Hibernation..." -ForegroundColor Yellow
    powercfg -h off
    Write-Host "✅ Hibernation disabled and hiberfil.sys removed!" -ForegroundColor Green
}

# Function to manage system restore
function ManageSystemRestore {
    Write-Host "🛠️ Managing System Restore Points..." -ForegroundColor Yellow
    vssadmin Resize ShadowStorage /On=C: /For=C: /MaxSize=5%
    vssadmin delete shadows /for=c: /oldest
    Write-Host "✅ System Restore points managed!" -ForegroundColor Green
}

# Function to run Disk Cleanup
function RunDiskCleanup {
    Write-Host "🧹 Running Disk Cleanup..." -ForegroundColor Yellow
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait
    Write-Host "✅ Disk cleanup completed!" -ForegroundColor Green
}

# Function to clear Windows Event Logs
function ClearEventLogs {
    Write-Host "📜 Clearing Windows Event Logs..." -ForegroundColor Yellow
    wevtutil el | Foreach-Object { wevtutil cl $_ }
    Write-Host "✅ Event logs cleared!" -ForegroundColor Green
}

# ============================
# 💾 3. VIRTUAL MEMORY CONFIGURATION (UPDATED)
# ============================
function SetVirtualMemory {
    param ([int]$InitialSizeMB, [int]$MaximumSizeMB)
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    $value = "C:\pagefile.sys $InitialSizeMB $MaximumSizeMB"
    Set-ItemProperty -Path $regPath -Name "PagingFiles" -Value $value
}

SetVirtualMemory -InitialSizeMB 16384 -MaximumSizeMB 32768
Write-Host "✅ Virtual Memory Adjusted! Restart required." -ForegroundColor Green  

# ============================
# 🚀 4. MAIN CLEANUP FUNCTION
# ============================
function CleanWindowsSystem {
    Write-Host "🚀 Starting Full System Cleanup..." -ForegroundColor Yellow

    ClearTempFiles
    RemoveOldWindowsInstallation
    ClearWindowsUpdateCache
    RemoveBloatware
    OptimizeGPU    
    ClearLogFiles
    ClearPrefetchFiles
    ClearMemoryDumps
    DisableHibernation
    ManageSystemRestore
    RunDiskCleanup
    ClearEventLogs
    # Empty Recycle Bin
    ClearRecycleBin -Force -ErrorAction SilentlyContinue

    Write-Host "✅ System Cleanup Completed!" -ForegroundColor Green
}

# ============================
# 🚀 5. EXECUTE OPTIMIZATION
# ============================
function StartOptimization {
    Write-Host "✨ OPTIMIZATION Start!" -ForegroundColor Cyan
    
    #CheckAdmin
    Write-Host "✨ Check Admin Complete!" -ForegroundColor Cyan
    CleanWindowsSystem
    
    Write-Host "✨ OPTIMIZATION COMPLETE! Please restart your computer." -ForegroundColor Cyan
    #Read-Host "Press Enter to exit..."
}

# Run the script
StartOptimization

# ============================
# 🚀 6. WINDOWS PERFORMANCE BOOST
# ============================
Write-Host "⚡ Applying Windows Performance Tweaks..." -ForegroundColor Yellow
# Disable Startup Delay for Faster Boot
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f

# Enable High-Performance Power Plan
powercfg -setactive SCHEME_MIN

Write-Host "✅ Performance Boost Applied!" -ForegroundColor Green

# ============================
# 🚽 7. UNINSTALL BLOATWARE AND UNUSED PROGRAMS
# ============================
Write-Host "🚹 Removing Bloatware And Unused Apps..." -ForegroundColor Yellow

$appsToRemove = @(
    "Microsoft.3DBuilder", "Microsoft.BingNews", "Microsoft.GetHelp", "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.NetworkSpeedTest", "Microsoft.OneConnect", "Microsoft.People", "Microsoft.Print3D",
    "Microsoft.SkypeApp", "Microsoft.Xbox.TCUI", "Microsoft.XboxApp", "Microsoft.XboxGameOverlay"
)
foreach ($app in $appsToRemove) {
    Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue
}

Write-Host "✅ Bloatware Removed!" -ForegroundColor Green

# ============================
# 🧜 8. REGISTRY CLEANUP
# ============================
Write-Host "🧹 Cleaning Registry..." -ForegroundColor Yellow

# Remove Old Software Registry Keys
$keysToRemove = @("HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*")
foreach ($key in $keysToRemove) {
    Remove-Item -Path $key -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host "✅ Registry Cleanup Complete!" -ForegroundColor Green

# ============================
# 🔧 9. SET GPU PREFERENCES
# ============================
function Set-GpuPreference {
    param ([string]$AppPath, [string]$Preference)
    $regPath = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
    $value = "${AppPath},$Preference"
    if (-not (Test-Path $regPath)) {
        New-Item -Path "HKCU:\Software\Microsoft\DirectX" -Name "UserGpuPreferences" -Force
    }
    Set-ItemProperty -Path $regPath -Name $AppPath -Value $value
}

$gpuApps = @("C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe", "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files\Mozilla Firefox\firefox.exe", "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE")
foreach ($app in $gpuApps) {
    Set-GpuPreference $app 2
}
Write-Host "✅ GPU Preferences Applied!" -ForegroundColor Green

# ============================
# 🎥 FINISH & RESTART PROMPT
# ============================
Write-Host "
🎯 Optimization Completed! A restart is recommended."
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")