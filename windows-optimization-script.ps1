# ============================
# 🏆 ULTIMATE WINDOWS 11 CLEANUP & OPTIMIZATION SCRIPT
# ============================
# Author: Javian Picardo
# Last Updated: February 2025
# Execution Order:
# 1. Admin Check
# 2. Old Windows Removal
# 3. Windows Update Cache Clear
# 4. Performance Optimization 
# 5. Bloatware Removal
# 6. GPU Optimization
# 7. Virtual Memory Configuration
# 8. System Files Cleanup
# 9. Registry Cleanup
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
# 🗑️ 2. OLD WINDOWS REMOVAL
# ============================
function Remove-OldWindowsInstallation {
    Write-Host "🔄 Removing old Windows installation..." -ForegroundColor Yellow
    
    $oldWindowsFolder = "$env:SystemDrive\Windows.old"
    if (Test-Path $oldWindowsFolder) {
        Remove-Item -Path $oldWindowsFolder -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "✅ Removed Windows.old folder" -ForegroundColor Green
    } else {
        Write-Host "ℹ️ No Windows.old folder found" -ForegroundColor Cyan
    }
}

# ============================
# 🔄 3. WINDOWS UPDATE CACHE
# ============================
function Clear-WindowsUpdateCache {
    Write-Host "🔄 Clearing Windows Update Cache..." -ForegroundColor Yellow
    
    # Stop Windows Update service
    Stop-Service -Name "wuauserv" -Force
    
    # Clear update cache
    Remove-Item -Path "$env:windir\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    # Restart Windows Update service
    Start-Service -Name "wuauserv"
    
    Write-Host "✅ Windows Update Cache Cleared!" -ForegroundColor Green
}

# ============================
# ⚡ 4. PERFORMANCE OPTIMIZATION
# ============================
function Optimize-WindowsPerformance {
    Write-Host "⚡ Applying Windows Performance Tweaks..." -ForegroundColor Yellow
    
    # Disable Hibernate to save space
    powercfg -h off
    Write-Host "✅ Hibernation disabled" -ForegroundColor Green
    
    # Disable startup delay
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f
    Write-Host "✅ Startup delay disabled" -ForegroundColor Green
    
    # Enable high-performance power plan
    powercfg -setactive SCHEME_MIN
    Write-Host "✅ High-performance power plan enabled" -ForegroundColor Green
}

# ============================
# 📦 5. BLOATWARE REMOVAL
# ============================
function Remove-Bloatware {
    Write-Host "🚮 Removing Bloatware & Unused Apps..." -ForegroundColor Yellow
    
    $appsToRemove = @(
        "Microsoft.3DBuilder",
        "Microsoft.BingNews",
        "Microsoft.GetHelp",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.NetworkSpeedTest",
        "Microsoft.OneConnect",
        "Microsoft.People",
        "Microsoft.Print3D",
        "Microsoft.SkypeApp",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.YourPhone",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo"
    )
    
    foreach ($app in $appsToRemove) {
        Write-Host "Removing $app..." -ForegroundColor Yellow
        Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue
    }
    
    Write-Host "✅ Bloatware Removal Complete!" -ForegroundColor Green
}

# ============================
# 🎮 6. GPU OPTIMIZATION
# ============================
function Set-GpuPreference {
    param (
        [string]$AppPath,
        [string]$Preference
    )
    
    $regPath = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
    $value = "${AppPath},$Preference"
    
    if (-not (Test-Path $regPath)) {
        New-Item -Path "HKCU:\Software\Microsoft\DirectX" -Name "UserGpuPreferences" -Force
    }
    Set-ItemProperty -Path $regPath -Name $AppPath -Value $value
}

function Optimize-GpuSettings {
    Write-Host "🎮 Configuring GPU Settings..." -ForegroundColor Yellow
    
    $gpuApps = @(
        "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
        "C:\Program Files\Google\Chrome\Application\chrome.exe",
        "C:\Program Files\Mozilla Firefox\firefox.exe",
        "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
    )
    
    foreach ($app in $gpuApps) {
        if (Test-Path $app) {
            Set-GpuPreference $app 2
            Write-Host "✅ GPU preference set for $(Split-Path $app -Leaf)" -ForegroundColor Green
        }
    }
}

# ============================
# 💾 7. VIRTUAL MEMORY
# ============================
function Set-VirtualMemory {
    Write-Host "💾 Configuring Virtual Memory..." -ForegroundColor Yellow
    
    try {
        # Get system memory info
        $systemMemory = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).Sum / 1MB
        
        # Calculate optimal sizes
        $initialSize = [math]::Round($systemMemory * 1.5)
        $maximumSize = [math]::Round($systemMemory * 3)
        
        # Set pagefile
        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
        $value = "C:\pagefile.sys $initialSize $maximumSize"
        Set-ItemProperty -Path $regPath -Name "PagingFiles" -Value $value
        
        Write-Host "✅ Virtual Memory Configured (Initial: ${initialSize}MB, Maximum: ${maximumSize}MB)" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Failed to configure virtual memory" -ForegroundColor Yellow
    }
}

# ============================
# 🧹 8. SYSTEM FILES CLEANUP
# ============================
function Clear-SystemFiles {
    Write-Host "🧹 Performing System Files Cleanup..." -ForegroundColor Yellow
    
    $cleanPaths = @(
        "$env:TEMP\*",
        "C:\Windows\Temp\*",
        "$env:windir\Prefetch\*",
        "$env:windir\Minidump\*"
    )
    
    foreach ($path in $cleanPaths) {
        if (Test-Path $path) {
            Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "✅ Cleaned $path" -ForegroundColor Green
        }
    }
    
    # Empty Recycle Bin
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Recycle Bin Emptied" -ForegroundColor Green
}

# ============================
# 🔧 9. REGISTRY CLEANUP
# ============================
function Clear-Registry {
    Write-Host "🔧 Performing Registry Cleanup..." -ForegroundColor Yellow
    
    $keysToRemove = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    
    foreach ($key in $keysToRemove) {
        Remove-Item -Path $key -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "✅ Registry Cleanup Complete!" -ForegroundColor Green
}

# ============================
# 🚀 MAIN EXECUTION
# ============================
function Start-Optimization {
    Write-Host "
============================
🏆 WINDOWS 11 OPTIMIZATION SCRIPT
============================" -ForegroundColor Cyan
    
    # 1. Check Admin Rights
    Check-Admin
    
    # 2. Remove Old Windows Installation
    Remove-OldWindowsInstallation
    
    # 3. Clear Windows Update Cache
    Clear-WindowsUpdateCache
    
    # 4. Optimize Windows Performance
    Optimize-WindowsPerformance
    
    # 5. Remove Bloatware
    Remove-Bloatware
    
    # 6. Optimize GPU Settings
    Optimize-GpuSettings
    
    # 7. Configure Virtual Memory
    Set-VirtualMemory
    
    # 8. Clean System Files (Second to Last)
    Clear-SystemFiles
    
    # 9. Clean Registry (Last Step)
    Clear-Registry
    
    # Final Message
    Write-Host "
============================
✨ OPTIMIZATION COMPLETE!
============================" -ForegroundColor Cyan
    
    Write-Host "⚠️ Please restart your computer to apply all changes." -ForegroundColor Yellow
    Write-Host "Press any key to exit..." -ForegroundColor Cyan
    $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Run the optimization script
Start-Optimization
