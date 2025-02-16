# ============================
# 🏆 ULTIMATE WINDOWS 11 CLEANUP & OPTIMIZATION SCRIPT
# ============================
# Author: Javian Picardo
# Last Updated: February 2025
# ⚠️ MUST BE RUN AS ADMINISTRATOR!

# ============================
# 🔒 1. ADMINISTRATOR CHECK
# ============================
function Check-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "❌ Please run this script as Administrator!" -ForegroundColor Red
        exit
    }
}

# ============================
# 🗑️ 2. CLEANUP FUNCTIONS (FIXED)
# ============================
# Function to clear temporary files
function Clear-TempFiles {
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
function Remove-OldWindowsInstallation {
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
function Clear-WindowsUpdateCache {
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
function Remove-Bloatware {
    Write-Host "🛠️ Removing Bloatware..." -ForegroundColor Yellow
    Get-AppxPackage | Where-Object { $_.Name -match "(CandyCrush|Spotify|Xbox|Twitter)" } | Remove-AppxPackage
    Write-Host "✅ Bloatware removed!" -ForegroundColor Green
}

# Function to optimize GPU settings in registry
function Optimize-GPU {
    Write-Host "💡 Optimizing GPU Settings..." -ForegroundColor Yellow
    $gpuRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\Dwm"
    if (!(Test-Path $gpuRegPath)) {
        New-Item -Path $gpuRegPath -Force | Out-Null
    }
    Set-ItemProperty -Path $gpuRegPath -Name "EnableHardwareAcceleration" -Value 1 -Type DWord
    Write-Host "✅ GPU settings optimized!" -ForegroundColor Green
}

# Function to clean up registry safely
function SafeRegistryCleanup {
    Write-Host "🔧 Cleaning Up Registry..." -ForegroundColor Yellow
    $uninstallKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    Get-ChildItem -Path $uninstallKey | Where-Object {
        $_.GetValue("DisplayName") -match "Toolbar|Bloatware"
    } | ForEach-Object {
        Remove-Item -Path $_.PSPath -Force -ErrorAction SilentlyContinue
    }
    Write-Host "✅ Registry cleaned safely!" -ForegroundColor Green
}

# Function to clear log files
function Clear-LogFiles {
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
function Clear-PrefetchFiles {
    Write-Host "⚡ Clearing Prefetch Files..." -ForegroundColor Yellow
    $prefetchFolder = "$env:windir\Prefetch"
    if (Test-Path $prefetchFolder) {
        Get-ChildItem -Path $prefetchFolder | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Prefetch files cleared!" -ForegroundColor Green
    }
}

# Function to clear memory dumps
function Clear-MemoryDumps {
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
function Disable-Hibernation {
    Write-Host "🔋 Disabling Hibernation..." -ForegroundColor Yellow
    powercfg -h off
    Write-Host "✅ Hibernation disabled and hiberfil.sys removed!" -ForegroundColor Green
}

# Function to manage system restore
function Manage-SystemRestore {
    Write-Host "🛠️ Managing System Restore Points..." -ForegroundColor Yellow
    vssadmin Resize ShadowStorage /On=C: /For=C: /MaxSize=5%
    vssadmin delete shadows /for=c: /oldest
    Write-Host "✅ System Restore points managed!" -ForegroundColor Green
}

# Function to run Disk Cleanup
function Run-DiskCleanup {
    Write-Host "🧹 Running Disk Cleanup..." -ForegroundColor Yellow
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait
    Write-Host "✅ Disk cleanup completed!" -ForegroundColor Green
}

# Function to clear Windows Event Logs
function Clear-EventLogs {
    Write-Host "📜 Clearing Windows Event Logs..." -ForegroundColor Yellow
    wevtutil el | Foreach-Object { wevtutil cl $_ }
    Write-Host "✅ Event logs cleared!" -ForegroundColor Green
}

# ============================
# 💾 3. VIRTUAL MEMORY CONFIGURATION (UPDATED)
# ============================
function Set-VirtualMemory {
    param ([int]$InitialSizeMB, [int]$MaximumSizeMB)
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    $value = "C:\pagefile.sys $InitialSizeMB $MaximumSizeMB"
    Set-ItemProperty -Path $regPath -Name "PagingFiles" -Value $value
}

Set-VirtualMemory -InitialSizeMB 16384 -MaximumSizeMB 32768
Write-Host "✅ Virtual Memory Adjusted! Restart required." -ForegroundColor Green  

# ============================
# 🚀 4. MAIN CLEANUP FUNCTION
# ============================
function Clean-WindowsSystem {
    Write-Host "🚀 Starting Full System Cleanup..." -ForegroundColor Yellow

    Clear-TempFiles
    Remove-OldWindowsInstallation
    Clear-WindowsUpdateCache
    Remove-Bloatware
    Optimize-GPU
    SafeRegistryCleanup
    Clear-LogFiles
    Clear-PrefetchFiles
    Clear-MemoryDumps
    Disable-Hibernation
    Manage-SystemRestore
    Run-DiskCleanup
    Clear-EventLogs

    Write-Host "✅ System Cleanup Completed!" -ForegroundColor Green
}

# ============================
# 🚀 5. EXECUTE OPTIMIZATION
# ============================
function Start-Optimization {
    Check-Admin
    Clean-WindowsSystem
    
    Write-Host "✨ OPTIMIZATION COMPLETE! Please restart your computer." -ForegroundColor Cyan
    Read-Host "Press Enter to exit..."
}

# Run the script
Start-Optimization
