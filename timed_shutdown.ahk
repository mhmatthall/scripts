#Requires AutoHotkey v2.0

; Set tray icon
TraySetIcon("./icons/settings_power.ico")

; Prevent more than one concurrent instance of the script running
#SingleInstance Ignore

; Keep around so the tray icon remains
Persistent

; -----------------------------------------------------------------------------
; Main

; Prompt the user for a time when the computer should shutdown, in the format "HH:MM"
prompt := InputBox(
    "Time to shutdown (HH:MM):",
    "Schedule a shutdown",
    "w190 h90",
    "23:00"
)

; Extract user input
timeString := prompt.Value

; Guard: user cancels out of prompt
if prompt.Result = "Cancel"
{
    ExitApp
}

; Guard: no value entered
if timeString = ""
{
    ; Reload the script to try again
    ReloadScript()
}

; Guard: invalid time format
if !RegExMatch(timeString, "^\d{1,2}:\d{2}$")
{
    MsgBox(
        "Invalid shutdown time.`n`nPlease enter a time in 24-hour format (HH:MM).",
        "Invalid Input",
        "OK Iconx T10"
    )
    ReloadScript()
}

; Schedule a shutdown at the requested time
Windows_ScheduleShutdown(
    CountdownSecondsUntilTime(timeString)
)

; Keep a tray icon around to remind user of shutdown, allow cancellation
A_IconTip := "Shutdown scheduled for " . timeString

; Remove default tray menu items
A_TrayMenu.Delete()

; Create 'Cancel...' menu item (discards default callback params)
A_TrayMenu.Add("Cancel...", (*) => ExitHandler())

; -----------------------------------------------------------------------------
; Helper functions

; Ensure the script reloads safely
ReloadScript()
{
    /*
      It turns out Reload is asynchronous, and so it doesn't cause an immediate
      restart of the script. Instead, it will happily blast through the rest of
      the script until it inevitably crashes.
    */
    Reload

    ; So, we sleep for a bit here to give the script time to reload
    Sleep(10 * 1000)
}

; Calculate the number of seconds until a given time
;   t: Time in the format "hh:mm"
CountdownSecondsUntilTime(t)
{
    ; Turn user input into a DateTime string in the format "YYYYMMDDHHmm"
    t := StrSplit(t, ":")
    shutdownTime := A_YYYY . A_MM . A_DD . t[1] . t[2]

    ; Add a day if the shutdown time has already passed
    if (t[1] < A_Hour) or (t[1] = A_Hour and t[2] < A_Min)
    {
        shutdownTime := DateAdd(shutdownTime, 1, "day")
    }

    ; Calculate seconds until shutdown time
    return DateDiff(shutdownTime, A_Now, "seconds")
}

; Schedule a shutdown to occur after a number of seconds (via hidden cmd.exe)
;   secondsUntilShutdown: Number of seconds until shutdown
Windows_ScheduleShutdown(secondsUntilShutdown)
{
    RunWait(A_ComSpec " /c shutdown /sg /t " . secondsUntilShutdown, , "Hide")
}

; Cancel a scheduled shutdown (via hidden cmd.exe)
Windows_CancelShutdown()
{
    RunWait(A_ComSpec " /c shutdown /a", , "Hide")
}

; -----------------------------------------------------------------------------
; Callback functions

; Handle cancel/exit request with a confirmation
ExitHandler()
{
    ; Compose dialog box message
    msg := "Are you sure you want to cancel the shutdown at " . timeString . "?"

    ; Prompt the user for a time when the computer should shutdown, in the format "HH:MM"
    prompt := MsgBox(
        msg,
        "Cancel Shutdown",
        "YesNo Icon! Default2"
    )

    if prompt = "Yes"
    {
        Windows_CancelShutdown()
        ExitApp
    }
}