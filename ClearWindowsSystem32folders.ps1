# Function to clear temporary files
function Clear-TempFiles {
    # Clear the temp folder
    $tempPaths = @(
        "$env:windir\Temp",
        "$env:localappdata\Temp"
    )
    
    foreach ($path in $tempPaths) {
        if (Test-Path $path) {
            try {
                Get-ChildItem -Path $path -Recurse | Remove-Item -Force -Recurse
                Write-Output "Cleared files in $path"
            } catch {
                Write-Output "Failed to clear files in $path"
            }
        }
    }
}

# Function to remove Windows.old folder (if exists)
function Remove-OldWindowsInstallation {
    $oldWindowsFolder = "$env:SystemDrive\Windows.old"
    if (Test-Path $oldWindowsFolder) {
        try {
            Remove-Item -Path $oldWindowsFolder -Recurse -Force
            Write-Output "Removed Windows.old folder"
        } catch {
            Write-Output "Failed to remove Windows.old folder"
        }
    } else {
        Write-Output "Windows.old folder not found."
    }
}

# Function to clean Windows Update cache
function Clear-WindowsUpdateCache {
    # Stop Windows Update service to clear the update cache
    Stop-Service -Name "wuauserv" -Force

    # Clear the SoftwareDistribution download folder
    $updateCache = "$env:windir\SoftwareDistribution\Download"
    if (Test-Path $updateCache) {
        try {
            Get-ChildItem -Path $updateCache -Recurse | Remove-Item -Force -Recurse
            Write-Output "Windows Update cache cleared."
        } catch {
            Write-Output "Failed to clear Windows Update cache."
        }
    }

    # Start Windows Update service again
    Start-Service -Name "wuauserv"
}

# Function to clear log files
function Clear-LogFiles {
    # Log file paths to clean up
    $logPaths = @(
        "$env:windir\System32\LogFiles",
        "$env:windir\Logs\CBS",
        "$env:windir\Temp"
    )

    foreach ($logPath in $logPaths) {
        if (Test-Path $logPath) {
            try {
                Get-ChildItem -Path $logPath -Recurse | Remove-Item -Force -Recurse
                Write-Output "Log files in $logPath have been cleared."
            } catch {
                Write-Output "Failed to clear log files in $logPath."
            }
        }
    }
}

# Function to clear Prefetch folder
function Clear-PrefetchFiles {
    $prefetchFolder = "$env:windir\Prefetch"
    if (Test-Path $prefetchFolder) {
        try {
            Get-ChildItem -Path $prefetchFolder | Remove-Item -Force
            Write-Output "Prefetch files cleared."
        } catch {
            Write-Output "Failed to clear Prefetch folder."
        }
    }
}

# Function to clear Memory Dumps
function Clear-MemoryDumps {
    # Clear Minidump files
    $minidumpFolder = "$env:windir\Minidump"
    if (Test-Path $minidumpFolder) {
        try {
            Get-ChildItem -Path $minidumpFolder | Remove-Item -Force
            Write-Output "Minidump files cleared."
        } catch {
            Write-Output "Failed to clear Minidump folder."
        }
    }

    # Remove main memory dump
    $memoryDumpFile = "$env:windir\MEMORY.DMP"
    if (Test-Path $memoryDumpFile) {
        try {
            Remove-Item -Path $memoryDumpFile -Force
            Write-Output "Memory dump cleared."
        } catch {
            Write-Output "Failed to clear MEMORY.DMP file."
        }
    }
}

# Function to disable hibernation and remove hiberfil.sys
function Disable-Hibernation {
    powercfg -h off
    Write-Output "Hibernation has been disabled and hiberfil.sys removed."
}

# Function to reduce System Restore points storage size and remove old ones
function Manage-SystemRestore {
    # Reduce the maximum storage for System Restore Points to 5%
    vssadmin Resize ShadowStorage /On=C: /For=C: /MaxSize=5%

    # Clear all restore points except the most recent one
    vssadmin delete shadows /for=c: /oldest
}

# Function to run Disk Cleanup for system files
function Run-DiskCleanup {
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait
    Write-Output "Disk cleanup has been completed."
}

# Function to clear Windows Event Logs
function Clear-EventLogs {
    wevtutil el | Foreach-Object { wevtutil cl $_ }
    Write-Output "All event logs cleared."
}

# Main Cleanup Function
function Clean-WindowsSystem {
    Write-Output "Starting full system cleanup..."

    # Clear temporary files
    Clear-TempFiles

    # Remove old Windows installation
    Remove-OldWindowsInstallation

    # Clear Windows Update cache
    Clear-WindowsUpdateCache

    # Clear log files
    Clear-LogFiles

    # Clear Prefetch files
    Clear-PrefetchFiles

    # Clear memory dumps
    Clear-MemoryDumps

    # Disable hibernation
    Disable-Hibernation

    # Manage system restore points
    Manage-SystemRestore

    # Run Disk Cleanup
    Run-DiskCleanup

    # Clear event logs
    Clear-EventLogs

    Write-Output "System cleanup completed."
}

# Start the cleanup process
Clean-WindowsSystem

# Keep the PowerShell window open and show results
Write-Host "`nExecution completed. Review the results above. Press any key to exit..." -ForegroundColor Yellow
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
