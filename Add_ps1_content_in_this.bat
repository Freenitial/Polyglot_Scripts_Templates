<# :
    @echo off & chcp 65001 >nul & cd /d "%~dp0"

    ::========= SETTINGS =========
    set "Powershell_WindowStyle=Normal"  :: Normal, Hidden, Minimized, Maximized
    set "Show_Loading=true"              :: Show cmd while preparing powershell
    set "Ensure_Local_Running=true"      :: If not launched from disk 'C', Re-Write in %temp% then execute
        set "Show_Writing_Lines=true"    :: Show lines writing in %temp% while preparing powershell
        set "Debug_Writting_Lines=false" :: Pause between each line writing (press a key to see next line)
    ::============================
 
    if "%Show_Writing_Lines%"=="true" set "Show_Loading=true"
    if "%Debug_Writting_Lines%"=="true" set "Show_Loading=true" && set "Show_Writing_Lines=true"
    if "%Show_Loading%"=="false" (
        if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
        ) else (if "%Show_Writing_Lines%"=="false" if "%Powershell_WindowStyle%"=="Hidden" mode con: cols=55 lines=3)
    echo. & echo  Loading...
;   if "%Ensure_Local_Running%"=="true" if "%~d0" NEQ "C:" ((
;       REM EXECUTED ONLY IF NOT LAUNCHED FROM 'C', AND SETTING 'Ensure_Local_Running=true'
;       REM IF YOU NEED TO ECHO SOMETING IN THIS BLOCK, ADD '1>&2' , example : echo test 1>&2
;       REM OPTIONNAL BATCH COMMANDS BEFORE RE-WRITE IN %TEMP%
;       for /f "eol=; usebackq delims=" %%k in ("%~f0") do (
;           setlocal enabledelayedexpansion & set "line=%%k" & echo(!line!
;           if "%Show_Writing_Lines%"=="true" echo(!line! 1>&2
;           if "%Debug_Writting_Lines%"=="true" pause 1>&2 >nul
;           endlocal
;       REM OPTIONNAL BATCH COMMANDS AFTER RE-WRITE IN %TEMP%
;       )) > "%temp%\%~nx0" & start "" cmd.exe /c "%temp%\%~nx0" %* & exit)

    REM OPTIONNAL BATCH COMMANDS BEFORE POWERSHELL 
;   REM LINES STARTING WITH ';' WILL BE IGNORED IF NOT LAUNCHED FROM 'C' AND "Ensure_Local_Running=true"

    cls & echo. & echo  Launching PowerShell...
    powershell /nologo /noprofile /executionpolicy bypass /windowstyle %Powershell_WindowStyle% /command ^
        "&{[ScriptBlock]::Create((gc """%~f0""" -Raw)).Invoke(@(&{$args}%*))}"

    REM OPTIONNAL BATCH COMMANDS AFTER POWERSHELL
;   REM LINES STARTING WITH ';' WILL BE IGNORED IF NOT LAUNCHED FROM 'C' AND "Ensure_Local_Running=true"

    if "%~dp0" NEQ "%temp%\" (exit) else ((goto) 2>nul & del "%~f0")
#>



YOUR POWERSHELL CODE HERE
YOUR POWERSHELL CODE HERE
YOUR POWERSHELL CODE HERE
