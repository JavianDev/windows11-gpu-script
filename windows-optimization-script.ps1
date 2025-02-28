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
# Function to clear temporary files.
function ClearTempFiles {
    Write-Host "🧹 Clearing Temporary Files..." -ForegroundColor Yellow
    $tempPaths = @("$env:windir\Temp", "$env:localappdata\Temp", "$env:SystemRoot\Temp", "$env:LOCALAPPDATA\Temp\")

    foreach ($path in $tempPaths) {
        if (Test-Path $path) {
            Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Host "✅ Temporary files cleared!" -ForegroundColor Green
}

# Function to remove Windows.old and perform deep Windows cleanup
function RemoveOldWindowsInstallation {
    Write-Host "🗑️ Removing Old Windows Installation..." -ForegroundColor Yellow
    $oldWindowsFolder = "$env:SystemDrive\Windows.old"

    if (Test-Path $oldWindowsFolder) {
        Write-Host "Deleting Windows.old folder..." -ForegroundColor Cyan
        Remove-Item -Path $oldWindowsFolder -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Windows.old folder removed!" -ForegroundColor Green
    }
    else {
        Write-Host "No Windows.old folder found." -ForegroundColor Cyan
    }

    # Run Disk Cleanup in silent mode
    Write-Host "🗑️ Running Disk Cleanup for system files..." -ForegroundColor Yellow
    cleanmgr /sagerun:1
    Write-Host "✅ Disk Cleanup completed!" -ForegroundColor Green
}

# Function to clean Windows Update cache and remove unnecessary update files
function ClearWindowsUpdateCache {
    Write-Host "🔄 Clearing Windows Update Cache..." -ForegroundColor Yellow

    # Stop Windows Update services
    Write-Host "Stopping Windows Update services..." -ForegroundColor Cyan
    $services = @("wuauserv", "bits", "cryptsvc")
    foreach ($service in $services) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
    }

    # Define cache paths
    $updateCache = "$env:windir\SoftwareDistribution"
    $catroot2 = "$env:windir\System32\catroot2"

    # Remove Windows Update cache
    if (Test-Path $updateCache) {
        Write-Host "Deleting SoftwareDistribution cache..." -ForegroundColor Yellow
        Remove-Item -Path "$updateCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    if (Test-Path $catroot2) {
        Write-Host "Deleting Catroot2 cache..." -ForegroundColor Yellow
        Remove-Item -Path "$catroot2\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host "✅ Windows Update cache cleared successfully!" -ForegroundColor Green

    # Restart Windows Update services
    Write-Host "Restarting Windows Update services..." -ForegroundColor Cyan
    foreach ($service in $services) {
        Start-Service -Name $service
    }

    Write-Host "✅ Windows Update services restarted successfully!" -ForegroundColor Green
}


# ============================
# 🚀 REMOVE WINDOWS BLOATWARE
# ============================

function RemoveBloatware {
    Write-Host "🛠️ Removing Bloatware..." -ForegroundColor Yellow

    # List of unwanted apps (Add or remove apps as needed)
    $bloatwareApps = @(
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.YourPhone",
        "Microsoft.BingNews",
        "Microsoft.BingWeather",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.People",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps",
        "Microsoft.3DBuilder",
        "SpotifyAB.SpotifyMusic",
        "King.com.CandyCrushSaga",
        "King.com.CandyCrushFriends",
        "Twitter.Twitter"
    )

    # Remove AppxPackages (per user)
    foreach ($app in $bloatwareApps) {
        Get-AppxPackage -AllUsers -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue
    }

    # Remove AppxProvisionedPackage (so it doesn’t come back)
    foreach ($app in $bloatwareApps) {
        Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match $app } | ForEach-Object {
            Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
        }
    }

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
    Write-Host "Clearing Log Files..." -ForegroundColor Yellow
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

# Function to manage system restore size
function ManageSystemRestore {
    Write-Host "🛠️ Managing System Restore Points..." -ForegroundColor Yellow
    
    # Set System Restore to use a maximum of 5% disk space
    vssadmin Resize ShadowStorage /On=C: /For=C: /MaxSize=5%
    
    # Delete the oldest restore point
    vssadmin delete shadows /for=c: /oldest /quiet

    Write-Host "✅ System Restore points managed!" -ForegroundColor Green
}

# Function to delete all system restore points
function RemoveOldRestorePoints {
    Write-Host "🗑️ Deleting all system restore points..." -ForegroundColor Yellow
    
    # Delete all shadow copies (restore points)
    vssadmin delete shadows /all /quiet

    Write-Host "✅ System Restore points removed!" -ForegroundColor Green
}

# Remove old Windows update backup files
function RemoveOldWindowsBackupFiles {
    Write-Host "🗑️ Removing obsolete Windows update backup files..." -ForegroundColor Yellow
    Remove-Item -Path "$env:SystemRoot\WinSxS\Backup\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Obsolete Windows update backup files removed!" -ForegroundColor Green
}

# Function to disable hibernation (frees up hiberfil.sys)
function DisableHibernation {
    Write-Host "🚀 Disabling Hibernation to free up space..." -ForegroundColor Yellow
    powercfg -h off
    Write-Host "✅ Hibernation disabled!" -ForegroundColor Green
}

# Function to clean Windows component store
function CleanupWinSxS {
    Write-Host "🧹 Running Windows Component Cleanup..." -ForegroundColor Yellow
    DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase
    Write-Host "✅ Component store cleaned!" -ForegroundColor Green
}

# Function to delete old unused drivers
function RemoveOldDrivers {
    Write-Host "🗑️ Removing old device drivers..." -ForegroundColor Yellow
    pnputil /e | ForEach-Object { 
        if ($_ -match "Published Name : (oem\d+\.inf)") { 
            pnputil /d $matches[1] 
        } 
    }
    Write-Host "✅ Old drivers removed!" -ForegroundColor Green
}

# Function to enable Windows Storage Sense for automatic cleanup
function EnableStorageSense {
    Write-Host "🛠️ Enabling Storage Sense..." -ForegroundColor Yellow
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 01 /t REG_DWORD /d 1 /f
    Write-Host "✅ Storage Sense enabled!" -ForegroundColor Green
}

# Function to compress Windows files
function CompressSystemFiles {
    Write-Host "🔧 Compressing Windows system files..." -ForegroundColor Yellow
    Compact.exe /CompactOS:always
    Write-Host "✅ System files compressed!" -ForegroundColor Green
}

# Function to clear Windows Event Logs
function ClearEventLogs {
    Write-Host "📜 Clearing Windows Event Logs..." -ForegroundColor Yellow
    wevtutil el | Foreach-Object { wevtutil cl $_ }
    Write-Host "✅ Event logs cleared!" -ForegroundColor Green
}

# ============================
# 💾 3. VIRTUAL MEMORY CONFIGURATION
# ============================
function SetVirtualMemory {
    param ([int]$InitialSizeMB, [int]$MaximumSizeMB)
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    $value = "C:\pagefile.sys $InitialSizeMB $MaximumSizeMB"
    Set-ItemProperty -Path $regPath -Name "PagingFiles" -Value $value
}

# ============================
# 💾 3. Smart Virtual Memory Configuration Script
# ============================

function Get-SystemRAM {
    $physicalMemory = Get-WmiObject -Class Win32_ComputerSystem
    return [Math]::Round($physicalMemory.TotalPhysicalMemory / 1GB, 2)
}

function Set-OptimalVirtualMemory {
    Write-Host "Analyzing System Memory Configuration..." -ForegroundColor Yellow
    
    try {
        # Get current RAM in GB
        $ramInGB = Get-SystemRAM
        Write-Host "✅ Detected Physical RAM: $ramInGB GB" -ForegroundColor Green

        # Calculate optimal sizes based on RAM
        $initialSizeMB = [Math]::Round($ramInGB * 1 * 1024) # 1.5x RAM in MB
        $maxSizeMB = [Math]::Round($ramInGB * 2 * 1024)    # 3x RAM in MB

        # Registry path for virtual memory settings
        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
        
        # Check available disk space
        $systemDrive = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"
        $freeSpaceGB = [Math]::Round($systemDrive.FreeSpace / 1GB, 2)
        
        Write-Host "📊 System Analysis:" -ForegroundColor Cyan
        Write-Host "   • Physical RAM: $ramInGB GB"
        Write-Host "   • Free Disk Space: $freeSpaceGB GB"
        Write-Host "   • Recommended Initial Size: $([Math]::Round($initialSizeMB/1024, 2)) GB"
        Write-Host "   • Recommended Maximum Size: $([Math]::Round($maxSizeMB/1024, 2)) GB"

        # Check if we have enough disk space
        if ($freeSpaceGB -lt ($maxSizeMB / 1024 + 10)) {
            Write-Host "⚠️ WARNING: Limited disk space available!" -ForegroundColor Yellow
            Write-Host "   Consider cleaning up disk space or using smaller page file sizes." -ForegroundColor Yellow
        }

        # Get current page file settings
        $currentSettings = Get-WmiObject -Class Win32_PageFileSetting

        # Backup current settings
        $backupValue = $null
        if (Test-Path $regPath) {
            $backupValue = (Get-ItemProperty -Path $regPath -Name "PagingFiles").PagingFiles
        }

        # Configure new page file
        Write-Host "🔧 Configuring Virtual Memory..." -ForegroundColor Yellow
        
        # Remove current page file settings
        if ($currentSettings) {
            $currentSettings | ForEach-Object { $_.Delete() }
        }

        # Set new page file
        $pageFile = "C:\pagefile.sys $initialSizeMB $maxSizeMB"
        Set-ItemProperty -Path $regPath -Name "PagingFiles" -Value $pageFile

        Write-Host "`n✅ Virtual Memory Configuration Complete!" -ForegroundColor Green
        Write-Host "   Initial Size: $([Math]::Round($initialSizeMB/1024, 2)) GB"
        Write-Host "   Maximum Size: $([Math]::Round($maxSizeMB/1024, 2)) GB"
        
        # Performance recommendations
        Write-Host "`n💡 Recommendations:" -ForegroundColor Cyan
        if ($ramInGB -lt 8) {
            Write-Host "   • Consider upgrading RAM to at least 8GB for better performance"
            Write-Host "   • Limit the number of applications running simultaneously"
        }
        Write-Host "   • Restart your computer to apply changes"
        Write-Host "   • Monitor system performance after restart"

        return $true
    }
    catch {
        Write-Host "`n❌ Error configuring Virtual Memory:" -ForegroundColor Red
        Write-Host "   $_" -ForegroundColor Red
        
        # Restore backup if available
        if ($backupValue) {
            Write-Host "`n🔄 Restoring previous settings..." -ForegroundColor Yellow
            Set-ItemProperty -Path $regPath -Name "PagingFiles" -Value $backupValue
        }
        
        return $false
    }
}

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
    ManageSystemRestore
    
    RemoveOldRestorePoints
    RemoveOldWindowsBackupFiles
    DisableHibernation
    CleanupWinSxS
    RemoveOldDrivers
    EnableStorageSense
    CompressSystemFiles
    ClearEventLogs
    # Empty Recycle Bin
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue

    Write-Host "✅ System Cleanup Completed!" -ForegroundColor Green
}

# ============================
# 🚀 5. EXECUTE OPTIMIZATION
# ============================
function StartOptimization {
    Write-Host "✨ OPTIMIZATION Start!" -ForegroundColor Cyan
    
    CheckAdmin
    Write-Host "✨ Check Admin Complete!" -ForegroundColor Cyan
    CleanWindowsSystem
    
    Write-Host "✨ OPTIMIZATION COMPLETE! Please restart your computer." -ForegroundColor Cyan
}

# Run optimizations
StartOptimization

# Set virtual memory
# SetVirtualMemory -InitialSizeMB 16384 -MaximumSizeMB 32768
if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Set-OptimalVirtualMemory
}
else {
    Write-Host "❌ This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
}
Write-Host "✅ Virtual Memory Adjusted! Restart required." -ForegroundColor Green

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

$gpuApps = @(
    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files\Mozilla Firefox\firefox.exe",
    "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
)
foreach ($app in $gpuApps) {
    Set-GpuPreference $app 2
}
Write-Host "✅ GPU Preferences Applied!" -ForegroundColor Green

# ============================
# 🎥 FINISH & RESTART PROMPT
# ============================
Write-Host "
🎯 Optimization Completed! A restart is recommended." -ForegroundColor Green
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")