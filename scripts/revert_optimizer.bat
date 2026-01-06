@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==========================================
:: FULL REVERT OPTIMIZER
:: Restores Windows defaults
:: SAFE, SILENT, PORTABLE
:: ==========================================

:: --- Network revert ---
netsh int tcp set heuristics default >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=default >nul 2>&1
netsh int tcp set global ecncapability=default >nul 2>&1
netsh int tcp set global timestamps=default >nul 2>&1

:: --- Power plan revert to Balanced ---
%SystemRoot%\System32\powercfg.exe -setactive SCHEME_BALANCED >nul 2>&1

:: --- Restore GameDVR defaults ---
reg delete "HKCU\System\GameConfigStore" /v GameDVR_Enabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /f >nul 2>&1

:: --- Restore Multimedia defaults ---
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
 /v SystemResponsiveness /t REG_DWORD /d 20 /f >nul 2>&1

:: --- Remove CS2-specific GPU overrides ---
reg delete "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" ^
 /v "cs2.exe" /f >nul 2>&1

reg delete "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" ^
 /v "cs2.exe" /f >nul 2>&1

endlocal
exit /b
