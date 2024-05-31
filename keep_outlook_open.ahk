#Requires AutoHotkey v2.0

; Set tray icon
TraySetIcon("./icons/mark_email_read.ico")

; Set tray icon tooltip
A_IconTip := "Keeping Outlook running..."

; -----------------------------------------------------------------------------
; Main

; Location of the (new) Outlook executable
outlookPath := EnvGet("LOCALAPPDATA") "\Microsoft\WindowsApps\olk.exe"

; Guard: executable can't be found (e.g. Outlook not installed)
if !FileExist(outlookPath)
{
  errorMessage := 
  (
    "No Outlook executable found in:
    " outlookPath "
    
    Check that (new) Outlook is installed, then try again."
  )

  MsgBox errorMessage, "Error", "Iconx"
  
  Exit
}

; Every minute, check if New Outlook is running and restart if not
loop
{
  if !ProcessExist("olk.exe")
  {
    ; Run Outlook in background (`Options: Hide`)
    Run outlookPath, , "Hide"
  }

  Sleep 60 * 1000
}