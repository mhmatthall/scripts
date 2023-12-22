prompt := InputBox("Minutes until lock:", "Timed screen lock")

if prompt.Result = "Cancel"
    Exit
else
    t := prompt.Value

    SendPomoNotification("Locking the screen in " . t . " minutes", (t * 60))

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
    HideTrayTip()
    Sleep ((delay - msgTimeout) * 1000)
}

; Windows-ambivalent function to hide a desktop notification
; (stolen from AHK docs)
HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        A_IconHidden := true
        Sleep 200  ; It may be necessary to adjust this sleep.
        A_IconHidden := false
    }
}