#Requires AutoHotkey v2.0

; Keep around so the tray icon remains
Persistent

; -----------------------------------------------------------------------------
; Main

; State variable for enabled/disabled toggle
global IsEnabled := true

; Setup the tray icon & menu
InitialiseMenu()

; Indefinite!
Loop
{
  ; Sleep until next hour
  TimeTilTimer := CalculateMsUntilNextHour()
  Sleep(TimeTilTimer)

  ; After sleep timer
  HandlePlay()
}

; -----------------------------------------------------------------------------
; Play the chime

HandlePlay(*)
{
  if (IsEnabled)
    SoundPlay(A_WorkingDir "\sfx\hourly-smw_pause.wav", "Wait")
}

; -----------------------------------------------------------------------------
; Toggle silent mode on/off

HandleToggle(*)
{
  if (IsEnabled)
  {
    DisableChime()
  }
  else
  {
    EnableChime()
  }
}

; -----------------------------------------------------------------------------
; Exit handler

HandleQuit(*)
{
  ExitApp()
}

; -----------------------------------------------------------------------------
; Initialise the tray menu

InitialiseMenu(*)
{
  ; Remove default tray menu items
  A_TrayMenu.Delete()

  ; Create enable/disable toggle item
  A_TrayMenu.Add("Silent mode", HandleToggle)

  ; Give it a checkbox
  A_TrayMenu.ToggleCheck("Silent mode")

  ; Create 'Quit' menu item (discards default callback params)
  A_TrayMenu.Add("Quit", HandleQuit)

  EnableChime()
}

; -----------------------------------------------------------------------------
; Enables the chime sound and updates UI

EnableChime(*)
{
  global IsEnabled := true
  TraySetIcon("./icons/notifications_active.ico")
  A_IconTip := "Hourly chimes enabled"
  A_TrayMenu.Uncheck("Silent mode")
}

; -----------------------------------------------------------------------------
; Disables the chime sound and updates UI

DisableChime(*)
{
  global IsEnabled := false
  TraySetIcon("./icons/notifications_off.ico")
  A_IconTip := "Hourly chimes disabled"
  A_TrayMenu.Check("Silent mode")
}

; -----------------------------------------------------------------------------
; Calculate the number of milliseconds until the next hour (XX:00:00)

CalculateMsUntilNextHour()
{
  NextHourTimestamp := A_Year . A_Mon . A_MDay . (A_Hour + 1) . "0000"

  return DateDiff(NextHourTimestamp, A_Now, "Seconds") * 1000
}