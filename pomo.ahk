#Requires AutoHotkey v2.0

; Tomato-ise the tray icon
TraySetIcon("tomato.ico")

; Set tray hover tooltip to show session end time
SessionEndTime := FormatTime(DateAdd(A_Now, 25, "minutes"), "Time")
A_IconTip := "Session ends at " . SessionEndTime

; The countdown
SendPomoNotification("Your 25 minutes starts now", 300)
SendPomoNotification("20 minutes left", 300)
SendPomoNotification("15 minutes left", 300)
SendPomoNotification("10 minutes left", 300)
SendPomoNotification("5 minutes left", 270)
SendPomoNotification("30 seconds left", 27)
SendPomoNotification("Session ending...", 3)

; Pause media
Send "{Media_Stop}"

; Lock the computer
DllCall("LockWorkStation")

; --------------------

; Send desktop notification for pomo reminders:
; - msg: the message to display
; - delay: the delay before the next pomo reminder
; - msgTimeout: the time the message is displayed (default: 4 seconds)
SendPomoNotification(msg, delay, msgTimeout := 4) {
    TrayTip msg
    Sleep (msgTimeout * 1000)
    Sleep ((delay - msgTimeout) * 1000)
}