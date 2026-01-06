@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==========================================
:: INSTALL ALL / FIRST RUN SETUP
:: Prepares system for CS2 optimizer usage
:: Silent, safe, idempotent
:: ==========================================

:: --- Ensure logs folder exists ---
set "BASE=%~dp0"
set "ROOT=%BASE%.."
if not exist "%ROOT%\logs" mkdir "%ROOT%\logs" >nul 2>&1

:: --- Basic command availability check ---
where netsh >nul 2>&1 || exit /b
where powercfg >nul 2>&1 || exit /b
where reg >nul 2>&1 || exit /b

:: --- Enable Game Mode (recommended baseline) ---
reg add "HKCU\Software\Microsoft\GameBar" ^
 /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKCU\Software\Microsoft\GameBar" ^
 /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Disable background app throttling ---
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" ^
 /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Ensure High Performance power scheme exists ---
for /f "tokens=2 delims=()" %%G in ('powercfg -list ^| findstr /i "High performance"') do set "HPGUID=%%G"
if defined HPGUID (
  powercfg -setactive %HPGUID% >nul 2>&1
)

:: --- Optional: prepare Ultimate Performance (if supported) ---
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1

:: --- Final marker ---
echo First run setup completed. > "%ROOT%\logs\install_all.log"

endlocal
exit /b
