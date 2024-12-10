#Requires AutoHotkey v2.0

; Set tray icon
TraySetIcon("./icons/settings_suggest.ico")

; Allow new instances of the script to replace old ones to allow adding more meeting options
; without having to restart everything
#SingleInstance Force

; Prevent auto-exit to allow OnExit callback
Persistent

; -----------------------------------------------------------------------------
; Main

; Set initial tray icon tooltip
A_IconTip := "Setting you up for meetings..."

; Remove default tray menu items
A_TrayMenu.Delete()

; Create 'Cancel...' menu item (discards default callback params)
A_TrayMenu.Add("Exit", HandleExit)

; Ready the UI
Window := InitialiseGui()

; Prompt user
Window.Show()

; -----------------------------------------------------------------------------
; Initialise the user config window

InitialiseGui()
{
    Window := Gui(
        ; Any space-delimited number of these options: https://www.autohotkey.com/docs/v2/lib/Gui.htm#Opt_Parameters
        "AlwaysOnTop -MinimizeBox -MaximizeBox",
        ; Window title
        "Setup for a meeting"
    )

    Window.MarginY := 10

    ; Gui.Add has really crooked options: https://www.autohotkey.com/docs/v2/lib/Gui.htm#Add_Parameters
    ; SYNTAX:
    ;    TYPE        IDENTIFIER      LAYOUT PARAMS            LABEL TEXT
    ;                                1       2       3
    ; Let user select which apps to open
    Window.Add(
        "GroupBox", "vGrpApps        w100    h90",           "Apps to open"
    )
    Window.Add(
        "Checkbox", "vOptTeams       xp+10   yp+20",         "Teams"
    )
    Window.Add(
        "Checkbox", "vOptZoom        y+m",                   "Zoom"
    )
    Window.Add(
        "Checkbox", "vOptDroidcam    y+m",                   "DroidCam"
    )

    ; Toggl Track options
    Window.Add(
        "GroupBox", "vGrpToggl       ys      w160    h90",   "Toggl Track"
    )
    Window.Add(
        "Checkbox", "vOptTogglstart  xp+10   yp+20",         "Start new entry on launch"
    )
    Window.Add(
        "Checkbox", "vOptTogglstop   y+m",                   "Stop running entry on exit"
    )

    ; Let user select options to help them focus
    Window.Add(
        "GroupBox", "vGrpFocus       xs      w270    h70",   "Focus options"
    )
    Window.Add(
        "Checkbox", "vOptFocusassist xp+10   yp+20",         "Enable Windows 'Focus assist'"
    )
    Window.Add(
        "Checkbox", "vOptStopmedia   y+m",                   "Stop currently playing media"
    )

    ; Launch button
    Window.Add(
        "Button",   "vBtnLaunch      xs      w270",          "Make it so"
    )
    ; Do callback
    Window["BtnLaunch"].OnEvent("Click", HandleSubmit)

    ; Configure default selections
    Window["OptZoom"].Value := 1
    Window["OptFocusassist"].Value := 1
    Window["OptStopmedia"].Value := 1

    ; Force exit app if 'X' button clicked to avoid OnExit callback
    Window.OnEvent("Close", (*) => ExitApp())

    return Window
}

; -----------------------------------------------------------------------------
; On script exit

; Callback function to gracefully reset changes made
HandleExit(*)
{
    if (Config.OptFocusassist)
    {
        DisableFocusAssist()
        Sleep 500
    }

    ; Send desktop notification of script exit
    SendDesktopNotification("Putting you back to normal...")

    ; Close requested apps
    if (Config.OptTeams)
    {
        ProcessClose "ms-teams.exe"
        Sleep 500
    }

    if (Config.OptZoom)
    {
        ProcessClose "Zoom.exe"
        Sleep 500
    }

    if (Config.OptDroidcam)
    {
        ProcessClose "droidcam.exe"
        Sleep 500
    }

    ; Stop Toggl Track timer
    if (Config.OptTogglstop)
    {
        Run EnvGet("LocalAppData") "\TogglTrack\TogglTrack.exe stop"
        Sleep 500
    }

    ; Finally...
    ExitApp()
}

; -----------------------------------------------------------------------------
; On launch button click

HandleSubmit(*)
{
    ; Save control values globally
    global Config := Window.Submit()
    
    ; Guard: no config options selected
    IsAnythingSelected := false
    for k, v in Config.OwnProps()
        IsAnythingSelected := v || IsAnythingSelected

    ; Just quit
    if (IsAnythingSelected = false)
        ExitApp()

    ; Send desktop notification of script start
    SendDesktopNotification("Setting you up for a meeting...")

    ; Set tray icon tooltip
    A_IconTip := "You're all setup for meetings. 'Right-click → Exit' this script to go back to normal."

    ; Launch requested apps
    if (Config.OptTeams)
    {
        Run "ms-teams"
        Sleep 500
    }

    if (Config.OptZoom)
    {
        Run EnvGet("APPDATA") "\Zoom\bin\Zoom.exe"
        Sleep 500
    }

    if (Config.OptDroidcam)
    {
        Run EnvGet("ProgramFiles") "\DroidCam\Client\bin\64bit\droidcam.exe"
        Sleep 500
    }

    ; Do focus actions
    if (Config.OptFocusassist)
    {
        EnableFocusAssist()
        Sleep 200
    }

    if (Config.OptStopmedia)
    {
        Send "{Media_Stop}"
    }

    ; Start Toggl Track timer
    if (Config.OptTogglstart)
    {
        Run EnvGet("LocalAppData") "\TogglTrack\TogglTrack.exe start"
        Sleep 500
    }
}

; -----------------------------------------------------------------------------
; Helper functions

; Send desktop notification:
; - Msg: the message to display
; - MsgTimeout: the time the message is displayed (default: 4 seconds)
SendDesktopNotification(Msg, MsgTimeout := 4)
{
    TrayTip Msg
    Sleep (MsgTimeout * 1000)
    HideTrayTip()
}

; Windows-ambivalent function to hide a desktop notification
; (stolen from AHK docs)
HideTrayTip()
{
    TrayTip ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion, 1, 3) = "10."
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