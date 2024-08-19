- If you open this batch with arguments, they will be passed to powershell

- You can hide powershell window by setting at the begin of the script : set "Powershell_WindowStyle=Hidden"

- Ensure local running -
  If you enable this setting AND script NOT launched from 'C' drive:
  - Script will be written into %temp% before re-executing from there
  - Lines begining with ';' will be ignored when re-executing
  - Auto-destroy from %temp% after execution
