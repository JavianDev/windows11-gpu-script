<#
Temp File Cleaner By ionstorm
v1.3

Changes:
Added: systemprofile directory thanks to Allen
Added: Firefox temp file locations
Added: Java Temp file cache locations
Added: Opera Browser cache
Added: PersistentDataDisk C: Partition for Omega/VMware
Added: Flash Cookie folders & Cache folders
Added: Shockwave cache folder
Added: Remote Desktop Bitmap Cache

----------------------------------------------------
# Feel Free to Add lines to the $tempfolder variable
----------------------------------------------------
#>

$tempfolders = @( 
    "C:\Users\*\Appdata\Local\Microsoft\Windows\Temporary Internet Files\*",
    "C:\Users\*\Appdata\Microsoft\Feeds Cache\*",
    "C:\Users\*\Appdata\Local\Mozilla\Firefox\cache\*",
    "C:\Users\*\Appdata\Local\Mozilla\Firefox\Profiles\*\cache\*",
    "C:\Users\*\Appdata\Local\Mozilla\Firefox\Profiles\*\cache2\*",
    "C:\Users\*\Appdata\Roaming\Macromedia\Flashp~1\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Cache\*",
    "C:\Windows\System32\config\systemprofile\AppData\Local\Google\Chrome\User Data\Default\Cache\*",
    "C:\Windows\System32\config\systemprofile\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.IE5\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Media Cache\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Pepper Data\*",
    "C:\Users\*\Appdata\Roaming\Microsoft\Windows\Cookies\*",
    "C:\Users\*\Appdata\Local\Temp\*",
    "C:\Users\*\Appdata\Local\Microsoft\OneNote\14.0\OneNoteOfflineCache_Files\*",
    "C:\Users\*\Appdata\LocalLow\Google\GoogleEarth\*",
    "C:\Users\*\Chrome\User Data\Default\Cache\*",
    "C:\Users\*\Chrome\User Data\Default\Media Cache\*",
    "C:\Users\*\AppData\Local\Google\Chrome\User Data\Default\Local Storage\*",
    "C:\Users\*\AppData\Local\Google\Chrome\User Data\Default\Cache\*",
    "C:\Users\*\AppData\Local\Google\Chrome\User Data\Default\Nedia Cache\*",
    "C:\Users\*\Appdata\Chrome\User Data\Default\Pepper Data\*",
    "C:\Users\*\Appdata\LocalLow\Sun\Java\Deployment\cache\*",
    "C:\Users\*\Appdata\Local\Opera\Opera\cache\*"
    "C:\Users\*\Appdata\Roaming\Microsoft\Internet Explorer\UserData\Low\*",
    "C:\Users\*\Appdata\Roaming\Apple Computer\MobileSync\*",
    "C:\Users\*\Appdata\Roaming\Apple Computer\Logs\*",
    "C:\Users\*\Appdata\Roaming\Apple Computer\iTunes\iPhone Software Updates\*",
    "C:\Users\*\Appdata\Roaming\Macromedia\Flash Player\macromedia.com\support\flashplayer\sys\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Pepper Data\Shockwave Flash\CacheWritableAdobeRoot\AssetCache\*",
    "C:\Users\*\Appdata\Roaming\Macromedia\Flash Player\#SharedObjects\*",
    "C:\Users\*\Appdata\Roaming\Mozilla\Firefox\Crash Reports\*",
    "C:\Users\*\Appdata\Roaming\Adobe\Flash Player\AssetCache\*",
    "C:\Users\*\Appdata\Local\Microsoft\Windows\INetCache\Content.IE5\*",
    "C:\Users\*\Appdata\Local\Microsoft\Windows\INetCache\Low\Content.IE5*",
    "C:\Users\*\Appdata\Local\Microsoft\Terminal Server Client\Cache\*",
    "C:\Users\*\Appdata\Local\Microsoft\Windows\Temporary Internet Files\*",
    "C:\Users\*\Appdata\Microsoft\Feeds Cache\*",
    "C:\Users\*\Appdata\Local\Mozilla\Firefox\cache\*",
    "C:\Users\*\Appdata\Local\Mozilla\Firefox\Profiles\*\cache\*",
    "C:\Users\*\Appdata\Local\Mozilla\Firefox\Profiles\*\cache2\*",
    "C:\Users\*\Appdata\Roaming\Macromedia\Flashp~1\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Cache\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Media Cache\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Pepper Data\*",
    "C:\Users\*\Appdata\Roaming\Microsoft\Windows\Cookies\*",
    "C:\Users\*\Appdata\Local\Temp\*",
    "C:\Users\*\Appdata\Local\Microsoft\OneNote\14.0\OneNoteOfflineCache_Files\*",
    "C:\Users\*\Appdata\LocalLow\Google\GoogleEarth\*",
    "C:\Users\*\Chrome\User Data\Default\Cache\*",
    "C:\Users\*\Chrome\User Data\Default\Media Cache\*",
    "C:\Users\*\Chrome\User Data\Default\Pepper Data\*",
    "C:\Users\*\Appdata\LocalLow\Sun\Java\Deployment\cache\*",
    "C:\Users\*\Appdata\Local\Opera\Opera\cache\*"
    "C:\Users\*\Appdata\Roaming\Microsoft\Internet Explorer\UserData\Low\*",
    "C:\Users\*\Appdata\Roaming\Apple Computer\MobileSync\*",
    "C:\Users\*\Appdata\Roaming\Apple Computer\Logs\*",
    "C:\Users\*\Appdata\Roaming\Apple Computer\iTunes\iPhone Software Updates\*",
    "C:\Users\*\Appdata\Roaming\Macromedia\Flash Player\macromedia.com\support\flashplayer\sys\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Pepper Data\Shockwave Flash\CacheWritableAdobeRoot\AssetCache\*",
    "C:\Users\*\Appdata\Roaming\Macromedia\Flash Player\#SharedObjects\*",
    "C:\Users\*\Appdata\Roaming\Mozilla\Firefox\Crash Reports\*",
    "C:\Users\*\Appdata\Roaming\Adobe\Flash Player\AssetCache\*",
    "C:\Users\*\Appdata\Local\Microsoft\Windows\INetCache\Content.IE5\*",
    "C:\Users\*\Appdata\Local\Microsoft\Windows\INetCache\Low\Content.IE5*",
    "C:\Users\*\Appdata\Local\Microsoft\Terminal Server Client\Cache\*",
    "C:\Users\*\Appdata\Local\Microsoft\Windows\Temporary Internet Files\*",
    "C:\Users\*\Appdata\Microsoft\Feeds Cache\*",
    "C:\Users\*\Appdata\Local\Mozilla\Firefox\cache\*",
    "C:\Users\*\Appdata\Local\Mozilla\Firefox\Profiles\*\cache\*",
    "C:\Users\*\Appdata\Local\Mozilla\Firefox\Profiles\*\cache2\*",
    "C:\Users\*\Appdata\Roaming\Macromedia\Flashp~1\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Cache\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Media Cache\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Pepper Data\*",
    "C:\Users\*\Appdata\Roaming\Microsoft\Windows\Cookies\*",
    "C:\Users\*\Appdata\Local\Temp\*",
    "C:\Users\*\Appdata\Local\Microsoft\OneNote\14.0\OneNoteOfflineCache_Files\*",
    "C:\Users\*\Appdata\LocalLow\Google\GoogleEarth\*",
    "C:\Users\*\Chrome\User Data\Default\Cache\*",
    "C:\Users\*\Chrome\User Data\Default\Media Cache\*",
    "C:\Users\*\Chrome\User Data\Default\Pepper Data\*",
    "C:\Users\*\Appdata\LocalLow\Sun\Java\Deployment\cache\*",
    "C:\Users\*\Appdata\Local\Opera\Opera\cache\*"
    "C:\Users\*\Appdata\Roaming\Microsoft\Internet Explorer\UserData\Low\*",
    "C:\Users\*\Appdata\Roaming\Apple Computer\MobileSync\*",
    "C:\Users\*\Appdata\Roaming\Apple Computer\Logs\*",
    "C:\Users\*\Appdata\Roaming\Apple Computer\iTunes\iPhone Software Updates\*",
    "C:\Users\*\Appdata\Roaming\Macromedia\Flash Player\macromedia.com\support\flashplayer\sys\*",
    "C:\Users\*\Appdata\Local\Google\Chrome\User Data\Default\Pepper Data\Shockwave Flash\CacheWritableAdobeRoot\AssetCache\*",
    "C:\Users\*\Appdata\Roaming\Macromedia\Flash Player\#SharedObjects\*",
    "C:\Users\*\Appdata\Roaming\Mozilla\Firefox\Crash Reports\*",
    "C:\Users\*\Appdata\Roaming\Adobe\Flash Player\AssetCache\*",
    "C:\Users\*\Appdata\Local\Microsoft\Windows\INetCache\Content.IE5\*",
    "C:\Users\*\Appdata\Local\Microsoft\Windows\INetCache\Low\Content.IE5*",
    "C:\Users\*\Appdata\Local\Microsoft\Terminal Server Client\Cache\*")

$colItems = (Get-ChildItem $tempfolders -Recurse -Force -EA SilentlyContinue | Measure-Object -property length -sum)
$sizeoutput = "{0:N2}" -f ($colItems.sum / 1MB) + " MB"
$numfiles = (Get-ChildItem $tempfolders -Recurse -Force -EA SilentlyContinue).count;

Write-Host "[+] Located $numfiles files which is $sizeoutput "
Write-Host ""
Read-Host -Prompt "Press Enter to continue/Ctrl+C to exit"

Write-Host "[+] Cleaning Started"

Remove-Item $tempfolders -Recurse -Force -EV RemoveErrors -EA SilentlyContinue

Write-Host "[+] $numfiles temp files cleared!"
Write-Host "[+] $sizeoutput Freed!"
