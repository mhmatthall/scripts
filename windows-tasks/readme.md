# Windows task templates (temporary)

I'm going to replace the whole sketchy find-and-replace method with an automated PowerShell script (probably using [Register-ScheduledTask](https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/register-scheduledtask?view=windowsserver2022-ps))

## Kill bloatware that starts on boot

To use this template, you need to do a bit of manual editing to the XML file before it can be imported into Task Scheduler. Properties like file paths and Windows usernames have been redacted by substitution with a string like: ### FIELD TO CHANGE ###.

Filling in the blanks:

- The value for placeholder '`### DOMAIN\USERNAME ###`' can be found with:
    ```powershell
    whoami
    ```
- The value for placeholder '`### WINDOWS USER TOKEN ###`' can be found with:
    ```powershell
    [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    ```
- The value for placeholder '`### PATH TO process_killa.ps1 ###`' can be found with:
    ```powershell
    Get-ChildItem -Recurse -File process_killa.ps1 | % { $_.FullName }
    ```
