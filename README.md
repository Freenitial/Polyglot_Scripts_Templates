- If you open this batch with arguments, they will be passed to powershell

- You can hide powershell window by ajust this setting at the begin of the script : **Powershell_WindowStyle=Hidden**

- Ensure local running -
  If you enable this setting AND script NOT launched from '**C**' drive:
  - Script will be written into _%temp%_ before re-executing from there
  - Lines begining with '**;**' will be ignored when re-executing
  - Auto-destroy from _%temp%_ after execution
