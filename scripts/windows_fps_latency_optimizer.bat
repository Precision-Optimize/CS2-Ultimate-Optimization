@echo off
title CS2 Windows FPS & Latency Optimizer
color 0A

echo ============================================
echo  CS2 WINDOWS FPS & LATENCY OPTIMIZER
echo ============================================
echo.
echo This script applies safe performance tweaks.
echo Administrator privileges required.
echo.
pause

:: ------------------------------------------------
:: Enable Ultimate Performance Power Plan
:: ------------------------------------------------
echo Enabling Ultimate Performance power plan...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
echo Power plan set to Ultimate Performance.
echo.

:: ------------------------------------------------
:: Disable Xbox Game Bar & DVR
:: ------------------------------------------------
echo Disabling Xbox Game Bar and DVR...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
echo Xbox Game Bar disabled.
echo.

:: ------------------------------------------------
:: Disable Mouse Acceleration
:: ------------------------------------------------
echo Disabling mouse acceleration...
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f
echo Mouse acceleration disabled.
echo.

:: ------------------------------------------------
:: Network latency optimization
:: ------------------------------------------------
echo Applying network latency tweaks...
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global ecncapability=disabled >nul
netsh int tcp set global timestamps=disabled >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global chimney=enabled >nul
echo Network optimizations applied.
echo.

:: ------------------------------------------------
:: Timer resolution (Windows default reset)
:: ------------------------------------------------
echo Resetting system timer resolution...
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /deletevalue tscsyncpolicy >nul 2>&1
echo Timer configuration reset to optimal.
echo.

:: ------------------------------------------------
:: Final message
:: ------------------------------------------------
echo ============================================
echo Optimization complete!
echo.
echo Recommended:
echo - Restart your PC
echo - Use fullscreen exclusive in CS2
echo - Cap FPS for stability
echo ============================================
pause
exit
