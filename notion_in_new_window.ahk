; -----------------------------------------------------------------------------
; Opens a page in Notion desktop in a new window (Windows-only)
;
; INSTRUCTIONS
; You need to specify which Notion page to open by providing it as a command-
; line argument.

; Create a shortcut with the following target syntax:
;   <path to AutoHotKey.exe> <path to notion_in_new_window.ahk> <notion:// link>
;
; e.g.
;   %ProgramFiles%\AutoHotkey\v2\AutoHotkey.exe %USERPROFILE%\Repos\scripts\notion_in_new_window.ahk notion://www.notion.so/xxx/xxxxx
;
; -----------------------------------------------------------------------------
#Requires AutoHotkey v2.0

; Notion deep link to open in new window; uses the first command-line argument
global DeepLink := A_Args[1]

; -----------------------------------------------------------------------------
; Main

; Open/switch to Notion
Run EnvGet("LocalAppData") '\Programs\Notion\Notion.exe'

; Wait for Notion to become active window
WinWaitActive 'ahk_exe Notion.exe'

; Open new Notion window
Send '^+N'

; Wait for the window to load slightly
Sleep 1 * 1000

; Navigate to the deep linked page
Run DeepLink