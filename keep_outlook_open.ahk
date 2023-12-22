#Requires AutoHotkey v2.0

TraySetIcon("mailcheck.ico")
A_IconTip := "Keeping Outlook running..."

; Every minute, check if New Outlook is running. If not, start it.
loop {
    if (!ProcessExist("olk.exe")) {
      Run("C:\Users\mhmat\AppData\Local\Microsoft\WindowsApps\olk.exe", , "Hide")
    }
    Sleep 60 * 1000
}