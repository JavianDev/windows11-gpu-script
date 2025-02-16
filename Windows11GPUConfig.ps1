# ============================
# 🏆 ULTIMATE WINDOWS 11 CLEANUP & OPTIMIZATION SCRIPT
# ============================
# 🚀 Optimizes Performance, Cleans Junk, Removes Bloat, Clears Registry, Sets GPU Preferences, Adjusts Virtual Memory
# ⚠️ RUN AS ADMINISTRATOR!

# Ensure script runs with admin privileges
function Check-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "❌ Please run this script as Administrator!" -ForegroundColor Red
        exit
    }
}
Check-Admin

# ============================
# 🚹 1. DEEP SYSTEM CLEANUP
# ============================
Write-Host "🥳 Running deep system cleanup..." -ForegroundColor Yellow

# Delete Temp files
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Delete Windows.old if it exists
$windowsOld = "C:\Windows.old"
if (Test-Path $windowsOld) {
    Remove-Item -Path $windowsOld -Recurse -Force
}

# Clear Windows Update Cache
Stop-Service wuauserv -Force
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force
Start-Service wuauserv

# Empty Recycle Bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Write-Host "✅ System Cleanup Complete!" -ForegroundColor Green

# ============================
# 🚀 2. WINDOWS PERFORMANCE BOOST
# ============================
Write-Host "⚡ Applying Windows Performance Tweaks..." -ForegroundColor Yellow

# Disable Hibernate to Save Space
powercfg -h off

# Disable Startup Delay for Faster Boot
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f

# Enable High-Performance Power Plan
powercfg -setactive SCHEME_MIN

Write-Host "✅ Performance Boost Applied!" -ForegroundColor Green

# ============================
# 🚽 3. UNINSTALL BLOATWARE & UNUSED PROGRAMS
# ============================
Write-Host "🚹 Removing Bloatware & Unused Apps..." -ForegroundColor Yellow

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
# 🧜 4. REGISTRY CLEANUP
# ============================
Write-Host "🧹 Cleaning Registry..." -ForegroundColor Yellow

# Remove Old Software Registry Keys
$keysToRemove = @("HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*")
foreach ($key in $keysToRemove) {
    Remove-Item -Path $key -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host "✅ Registry Cleanup Complete!" -ForegroundColor Green

# ============================
# 🔧 5. SET GPU PREFERENCES
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
# 🛠️ 6. SET VIRTUAL MEMORY
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
# 🎥 FINISH & RESTART PROMPT
# ============================
Write-Host "
🎯 Optimization Completed! A restart is recommended."
Write-Host "Press any key to exit..." -ForegroundColor Cyan
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
