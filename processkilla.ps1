# 
# Kills processes bloatware processes that start on boot, but can't be disabled
# version 0.2
# 

# Processes to close
$processNames = "WavesSvc64", "clicksharelauncher", "compattelrunner", "AdobeCollabSync", "armsvc", "SelfService", "Receiver"

Write-Output "=== PROCESS KILLA ==="

ForEach ($name in $processNames) {
    Write-Output "Terminating '$($name)'..."

    try {
        Stop-Process -Name $name -Force -ErrorAction Stop
    }
    catch {
        Write-Output "  Failed! $($_.Exception.Message)"
    }

    Write-Output "`n"
}

Write-Output "Done! Closing in 10 seconds..."
Start-Sleep -Seconds 10
