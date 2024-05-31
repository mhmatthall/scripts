#Requires AutoHotkey v2.0

; Set tray icon
TraySetIcon("timer.ico")

; Prevent auto-exit to allow OnExit callback
Persistent

; Setup OnExit callback on script exit
OnExit ExitHandler

; -----------------------------------------------------------------------------
; Main

; Prompt user for desired time until lock
prompt := InputBox("Minutes until lock:", "Timed screen lock")

; Guard: user cancels out of prompt
if prompt.Result = "Cancel"
{
    Exit
}

t := prompt.Value

; Guard: no value entered
if t = ""
{
    ; Reload the script to try again
    Reload
}

; Show session end time on hover over tray icon 
SessionEndTime := FormatTime(DateAdd(A_Now, t, "minutes"), "Time")
A_IconTip := "Session ends at " . SessionEndTime

; Start timer for `t` minutes and sleep
SendDesktopNotification("Locking the screen in " . t . " minutes", (t * 60))

; On timer completion:
; Stop playing media
Send "{Media_Stop}"

; Lock the computer
DllCall("LockWorkStation")

; -----------------------------------------------------------------------------
; On script exit

; Callback function which intercepts script exit
ExitHandler(ExitReason, ExitCode)
{
    ; Send desktop notification of script exit
    SendDesktopNotification("Timed lock cancelled", 0)
}
; -----------------------------------------------------------------------------

; Send desktop notification
; - msg: the message to display
; - delay: delay script for `delay` seconds
; - msgTimeout: the time the message is displayed (default: 4 seconds)
SendDesktopNotification(msg, delay, msgTimeout := 4)
{
    TrayTip msg
    Sleep (msgTimeout * 1000)
    HideTrayTip()
    Sleep ((delay - msgTimeout) * 1000)
}

; Windows-ambivalent function to hide a desktop notification
; (stolen from AHK docs)
HideTrayTip()
{
    TrayTip ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10."
    {
        A_IconHidden := true
        Sleep 200 ; It may be necessary to adjust this sleep.
        A_IconHidden := false
    }
}