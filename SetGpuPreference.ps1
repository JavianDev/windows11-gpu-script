# Function to set GPU preference
function Set-GpuPreference {
    param (
        [string]$AppPath,
        [string]$Preference
    )

    # Preference values:
    # 0 - Let Windows decide
    # 1 - Power saving
    # 2 - High performance

    $regPath = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
    $value = "${AppPath},$Preference"

    if (-not (Test-Path $regPath)) {
        New-Item -Path "HKCU:\Software\Microsoft\DirectX" -Name "UserGpuPreferences" -Force
    }

    try {
        Set-ItemProperty -Path $regPath -Name $AppPath -Value $value
        Write-Output "Successfully set GPU preference for $AppPath to $Preference (High performance)."
    } catch {
        Write-Output "Failed to set GPU preference for $AppPath."
    }
}

# Function to set virtual memory
function Set-VirtualMemory {
    param (
        [int]$InitialSizeMB,
        [int]$MaximumSizeMB
    )

    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    $value = "C:\pagefile.sys $InitialSizeMB $MaximumSizeMB"

    try {
        if (Test-Path $regPath) {
            Set-ItemProperty -Path $regPath -Name "PagingFiles" -Value $value
            Write-Output "Virtual memory has been set to Initial Size: $InitialSizeMB MB, Maximum Size: $MaximumSizeMB MB. A restart is required to apply changes."
        } else {
            Write-Output "Failed to set virtual memory. Registry path not found."
        }
    } catch {
        Write-Output "Failed to set virtual memory."
    }
}

# Set GPU preferences for browsers
Set-GpuPreference "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" 2
Set-GpuPreference "C:\Program Files\Google\Chrome\Application\chrome.exe" 2
Set-GpuPreference "C:\Program Files\Mozilla Firefox\firefox.exe" 2
Set-GpuPreference "C:\Program Files\DuckDuckGo\DuckDuckGo.exe" 2
Set-GpuPreference "C:\Program Files\Arc\Browser\Application\arc.exe" 2  # Arc Browser GPU preference

# Set GPU preference for Adobe Photoshop Elements 2023
Set-GpuPreference "C:\Program Files\Adobe\Photoshop Elements 2023\Elements Home\Adobe Photoshop Elements 2023.exe" 2

# Set GPU preferences for Microsoft Office products
Set-GpuPreference "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" 2
Set-GpuPreference "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE" 2
Set-GpuPreference "C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE" 2
Set-GpuPreference "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE" 2

# Set virtual memory to start with 16GB and grow up to 32GB
Set-VirtualMemory -InitialSizeMB 16384 -MaximumSizeMB 32768

Write-Output "GPU preferences have been set and virtual memory adjusted. Please restart your computer to apply changes."

# Keep the window open and log the result
Write-Host "`nExecution completed. Press any key to exit..." -ForegroundColor Yellow
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
