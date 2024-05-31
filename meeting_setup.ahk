#Requires AutoHotkey v2.0

; Set tray icon
TraySetIcon("settings_suggest.ico")

; Set tray icon tooltip
A_IconTip := "You're all setup for meetings. 'Right-click → Exit' this script to go back to normal."

; Prevent more than one concurrent instance of the script running
#SingleInstance Ignore

; Prevent auto-exit to allow OnExit callback
Persistent

; Setup OnExit callback on script exit
OnExit ExitHandler

; -----------------------------------------------------------------------------
; Main

; Send desktop notification of script start
SendDesktopNotification("Setting you up for a meeting...")

; Launch Teams
Run "ms-teams"

Sleep 500

; Launch Zoom
Run EnvGet("APPDATA") "\Zoom\bin\Zoom.exe"

Sleep 500

; Launch DroidCam
Run EnvGet("ProgramFiles(x86)") "\DroidCam\DroidCamApp.exe"

Sleep 500

; Enable Focus Assist
EnableFocusAssist()

Sleep 200

; Stop media
Send "{Media_Stop}"

; -----------------------------------------------------------------------------
; On script exit

; Callback function which intercepts script exit
ExitHandler(ExitReason, ExitCode)
{
    ; Guard: only close apps if script is exiting due to user request (i.e. not due to an error or system shutdown)
    if ExitReason != "Menu"
    {
        Return
    }

    ; Disable Focus Assist
    DisableFocusAssist()

    Sleep 500

    ; Send desktop notification of script exit
    SendDesktopNotification("Closing meeting apps...")

    ; Close Teams
    ProcessClose "ms-teams.exe"

    Sleep 500

    ; Close Zoom
    ProcessClose "Zoom.exe"

    Sleep 500

    ; Close DroidCam
    ProcessClose "DroidCamApp.exe"
}

; -----------------------------------------------------------------------------

; Send desktop notification:
; - msg: the message to display
; - msgTimeout: the time the message is displayed (default: 4 seconds)
SendDesktopNotification(msg, msgTimeout := 4)
{
    TrayTip msg
    Sleep (msgTimeout * 1000)
    HideTrayTip()
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

; Enable Windows' Focus Assist
; from: https://superuser.com/a/1684988/1776603
EnableFocusAssist()
{
    ; Keys sequence: Win+B, Left, Menu, Down 2x, Enter, Down, Enter, Esc
    Send "#b"
    Sleep 500
    Send "{Left}{AppsKey}"
    Sleep 500
    Send "{Down 2}{Enter}{Down}{Enter}{Esc}"
    Sleep 200
    Send "{Esc}"
    Return
}

; Disable Windows' Focus Assist (TODO: unused in script)
; from: https://superuser.com/a/1684988/1776603
DisableFocusAssist()
{
    ; Keys sequence: Win+B, Left, Menu, Down 2x, Enter 2x, Esc
    Send "#b"
    Sleep 500
    Send "{Left}{AppsKey}"
    Sleep 500
    Send "{Down 2}{Enter 2}{Esc}"
    Sleep 200
    Send "{Esc}"
    Return
}