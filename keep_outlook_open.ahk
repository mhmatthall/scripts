#Requires AutoHotkey v2.0

; Set tray icon
TraySetIcon("mailcheck.ico")

; Set tray icon tooltip
A_IconTip := "Keeping Outlook running..."

; Every minute, check if New Outlook is running. If not, restart it.
loop
{
  if (!ProcessExist("olk.exe"))
  {
    Run("C:\Users\mhmat\AppData\Local\Microsoft\WindowsApps\olk.exe", , "Hide")
  }

  Sleep 60 * 1000
}