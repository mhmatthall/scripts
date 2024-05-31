#Requires AutoHotkey v2.0

; Tomato-ise the tray icon
TraySetIcon("./icons/tomato.ico")

; -----------------------------------------------------------------------------
; Main

; Show session end time on hover over tray icon 
SessionEndTime := FormatTime(DateAdd(A_Now, 25, "minutes"), "Time")
A_IconTip := "Session ends at " . SessionEndTime

; The countdown
SendDesktopNotification("Your 25 minutes starts now", 300)
SendDesktopNotification("20 minutes left", 300)
SendDesktopNotification("15 minutes left", 300)
SendDesktopNotification("10 minutes left", 300)
SendDesktopNotification("5 minutes left", 270)
SendDesktopNotification("30 seconds left", 27)
SendDesktopNotification("Session ending...", 3)

; On countdown completion:
; Stop playing media
Send "{Media_Stop}"

; Lock the computer
DllCall("LockWorkStation")

; --------------------

; Send desktop notification
; - msg: the message to display
; - delay: the delay before the next pomo reminder
; - msgTimeout: the time the message is displayed (default: 4 seconds)
SendDesktopNotification(msg, delay, msgTimeout := 4) {
    TrayTip msg
    Sleep (msgTimeout * 1000)
    Sleep ((delay - msgTimeout) * 1000)
}