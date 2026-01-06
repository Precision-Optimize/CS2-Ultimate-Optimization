@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==========================================
:: WINDOWS FPS & LATENCY OPTIMIZER
:: SAFE + PERFORMANCE BASE
:: No UI, no pause, no exit
:: ==========================================

:: --- Disable Game DVR / Xbox Capture ---
reg add "HKCU\System\GameConfigStore" ^
 /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" ^
 /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Network: Low latency (SAFE) ---
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set global autotuninglevel=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1

:: --- Power plan: High Performance ---
%SystemRoot%\System32\powercfg.exe -setactive SCHEME_MIN >nul 2>&1

:: --- Windows Multimedia Priority ---
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
 /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1

endlocal
exit /b
