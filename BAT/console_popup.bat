<# : Set console always on top + Disable drag-to-select that causes freeze, aka QuickEdit + Disable close. On Win10+ CMD window remains closeable from right click on taskbar.
::   Solution v1.0 by Freenitial on GitHub, adapted from http://stackoverflow.com/a/37912693/1683264 and https://stackoverflow.com/a/21805713/30968347
@echo off & setlocal
if exist "%TEMP%\consoleSettingsBackup.reg" regedit /S "%TEMP%\consoleSettingsBackup.reg"&del /F /Q "%TEMP%\consoleSettingsBackup.reg"&goto restarted &:: 2nd launch= Restore QuickEdit reg for future
regedit /S /E "%TEMP%\consoleSettingsBackup.reg" HKEY_CURRENT_USER\Console&reg add "HKEY_CURRENT_USER\Console" /V QuickEdit /T REG_DWORD /D 0 /F >nul &:: 1st launch= Disable QuickEdit reg backup
start "" /wait cmd /c ""%~dpnx0" %*" & echo %CMDCMDLINE% | findstr /I /C:" /k " | findstr /I /C:"%~nx0" >nul && (exit) || (exit /b)                   &:: Restart, Wait, and Exit properly
:restarted          &:: '/wait' above -line 6- make CMD instance that launched this script wait the end. This 1st lancher instance is hidden by 1st powershell call.
for /f "delims=" %%S in ('                                                                                                                                       
   powershell -nologo -noprofile -ex bypass -command  "&{[ScriptBlock]::Create([System.IO.File]::ReadAllText('%~f0',[System.Text.Encoding]::Default)).Invoke()}"
') do set "BackupWindowState=%%S"              &:: 1st PowerShell call = Disable close button + set always on top + hide 1st CMD. In a loop to store first CMD window handle returned by Powershell
:: powershell -nologo -noprofile -ex bypass -command "&{[ScriptBlock]::Create([System.IO.File]::ReadAllText('%~f0',[System.Text.Encoding]::Default)).Invoke(@(&{$args}%*))}" :: Pass args but ()"@ crash
:: ==================== Main batch begins here. ====================





:: YOUR BATCH CODE HERE.
:: YOUR BATCH CODE HERE.





if defined BackupWindowState (
  echo %BackupWindowState% | findstr /r "^HANDLE:[0-9]*" >nul && (
    powershell -nologo -noprofile -ex bypass -command "&{[ScriptBlock]::Create([System.IO.File]::ReadAllText('%~f0',[System.Text.Encoding]::Default)).Invoke(@('%BackupWindowState%'))}"  
  )
)   &:: 2nd PowerShell call to restore state of 1st CMD window -the launcher that got hidden during the script-. No effect from batch double click, but useful if batch opened from other cmd.
endlocal & exit /b
:: ===================== Main batch ends here. =====================
#>
$csCode = @"
using System;
using System.Runtime.InteropServices;
public static class Win32 {
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
#if !SECOND_POWERSHELL_CALL
    [StructLayout(LayoutKind.Sequential)]public struct POINT { public int X, Y; }
    [StructLayout(LayoutKind.Sequential)]public struct RECT { public int Left, Top, Right, Bottom; }
    [StructLayout(LayoutKind.Sequential)]public struct WINDOWPLACEMENT {
                                             public int length, flags, showCmd;
                                             public POINT ptMinPosition, ptMaxPosition;
                                             public RECT rcNormalPosition; }
    [DllImport("kernel32.dll")]public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")]public static extern IntPtr GetSystemMenu(IntPtr hWnd, bool bRevert);
    [DllImport("user32.dll")]public static extern bool DeleteMenu(IntPtr hMenu, uint uPosition, uint uFlags);
    [DllImport("user32.dll")]public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    [DllImport("user32.dll")]public static extern bool GetWindowPlacement(IntPtr hWnd, ref WINDOWPLACEMENT lpwndpl);
    public static WINDOWPLACEMENT GetPlacement(IntPtr hWnd) {
        WINDOWPLACEMENT wp = new WINDOWPLACEMENT(); wp.length = Marshal.SizeOf(wp); GetWindowPlacement(hWnd, ref wp);
        return wp;
    }
#endif
}
"@
$cp = New-Object System.CodeDom.Compiler.CompilerParameters
$cp.GenerateInMemory = $true
if ($restoreCMD = ($args -and $args[0] -match '^HANDLE:(\d+);STATE:(\d+)$')) {$cp.CompilerOptions = '/define:SECOND_POWERSHELL_CALL'}
Add-Type -TypeDefinition $csCode -CompilerParameters $cp -ErrorAction SilentlyContinue   # Compilation depends of 1st or 2nd powershell call

# ================== 2nd PowerShell call commands ==================
if ($restoreCMD) {                                                                                            
    $parentHandle  = [IntPtr]::new([int]$matches[1])                                                          # Extract 1st CMD window handle
    $originalState = [int]$matches[2]                                                                         # Extract 1st CMD window state
    [Win32]::ShowWindow($parentHandle, $originalState) | Out-Null                                             # Restore 1st CMD window state
    return                                                                                                    # 2nd PowerShell call stops here
}
# ================== 1st PowerShell call commands ==================
$consoleHwnd = [Win32]::GetConsoleWindow()                                                                    
if ($consoleHwnd -ne [IntPtr]::Zero) {                                                                        # Excludes modern Terminal
    [Win32]::DeleteMenu([Win32]::GetSystemMenu($consoleHwnd, $false), 0xF060, 0)                  |Out-Null   # Disable 2nd CMD close button
    [Win32]::SetWindowPos($consoleHwnd, [IntPtr]::op_Explicit(-1), 0, 0, 0, 0, 0x0003 -bor 0x0020)|Out-Null   # Set     2nd CMD always on top
    $PID_to_Walk = $PID                                                                                       # Current PowerShell PID
    1..3 | ForEach-Object { $parent = Get-CimInstance Win32_Process -Filter "ProcessId=$PID_to_Walk"; $PID_to_Walk= $parent.ParentProcessId }
    $ConsoleToHide = (Get-Process -Id $PID_to_Walk -ErrorAction SilentlyContinue).MainWindowHandle            # Get     1st CMD handle
    $originalStateFirst = [Win32]::GetPlacement($ConsoleToHide).showCmd                                       # Get     1st CMD window state
    [Win32]::ShowWindow($ConsoleToHide, 0) | Out-Null                                                         # Hides   1st CMD window
    Write-Output "HANDLE:$($ConsoleToHide.ToInt32());STATE:$originalStateFirst"                               # Return  1st CMD window ID
}
