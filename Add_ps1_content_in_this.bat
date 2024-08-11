<# :
    @echo off & chcp 65001 >nul & cd /d "%~dp0" & echo. & echo  Loading...

; ::========= SETTINGS =========
    set "Show_Loading=true"
;   set "Ensure_Local_Running=true"
;       set "Show_Writting_Lines=false"
;       set "Debug_Writting_Lines=false" :: Pause between each line writing (press a key to see next line)
; ::============================

;   if "%Show_Writting_Lines%"=="true" set "Show_Loading=true"
;   if "%Debug_Writting_Lines%"=="true" set "Show_Loading=true" && set "Show_Writting_Lines=true"
    if "%Show_Loading%"=="false" (
        if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit
        ) else (if "%Show_Writting_Lines%"=="false" mode con: cols=55 lines=3)
;   if "%Ensure_Local_Running%"=="true" if "%~d0" NEQ "C:" ((
;       for /f "eol=; usebackq delims=" %%a in ("%~f0") do (
;           setlocal enabledelayedexpansion & set "line=%%a" & echo !line!
;           if "%Show_Writting_Lines%"=="true" echo !line! 1>&2
;           if "%Debug_Writting_Lines%"=="true" pause 1>&2 >nul
;           endlocal
;       )) > "%temp%\%~nx0" & start cmd.exe /c "%temp%\%~nx0" %* & exit)

    setlocal & echo. & echo  Launching PowerShell...
    powershell /nologo /noprofile /executionpolicy bypass /windowstyle hidden /command ^
        "&{[ScriptBlock]::Create((gc """%~f0""" -Raw)).Invoke(@(&{$args}%*))}"
    if "%~dp0" NEQ "%temp%\" (exit) else ((goto) 2>nul & del "%~f0")
#>



YOUR POWERSHELL CODE HERE
YOUR POWERSHELL CODE HERE
YOUR POWERSHELL CODE HERE
