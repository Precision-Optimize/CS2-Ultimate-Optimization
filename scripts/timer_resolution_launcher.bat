@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==========================================
:: TIMER RESOLUTION LAUNCHER
:: Uses SetTimerResolution.exe if present
:: Silent, portable, safe
:: ==========================================

set "BASE=%~dp0"

:: Prefer external tool if available
if exist "%BASE%SetTimerResolution.exe" (
    start "" "%BASE%SetTimerResolution.exe" --resolution 0.5 --no-console
) else (
    :: Fallback: Windows multimedia profile (safe)
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
     /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
)

endlocal
exit /b
