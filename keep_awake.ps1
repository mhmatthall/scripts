# 
# Stops the PC from going to screensaver/sleeping by simulating an 'F13' keypress every 60 seconds indefinitely
# version 0.1
# 
$sh = New-Object -com "Wscript.Shell"

Write-Output "Keeping the computer awake. Press Ctrl+C or close this window to stop."

while (1) {
    Start-Sleep -Seconds 60
    $sh.sendkeys("{F13}")
}