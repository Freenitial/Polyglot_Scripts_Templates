- If you open this batch with arguments, they will be passed to powershell

- You can hide powershell window by setting at the begin of the script : set "Powershell_WindowStyle=Hidden"

- Ensure local running :
   - If you ENABLE this setting :
      - When script NOT launched from 'C' drive :
          - Script will be written into %temp% before executing
          - Auto-destroy from %temp% after execution
   - If you DISABLE this setting :
      - Lines begining with ';' will be ignored when script NOT launched from 'C' drive
