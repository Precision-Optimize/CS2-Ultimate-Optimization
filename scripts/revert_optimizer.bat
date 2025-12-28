@echo off
title CS2 Optimizer Revert
color 0C

echo ============================================
echo  CS2 WINDOWS OPTIMIZER - REVERT
echo ============================================
echo.
echo This will restore Windows default settings.
echo.
pause

:: Restore default power plan
echo Restoring default Balanced power plan...
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e

:: Re-enable Xbox Game Bar & DVR
echo Restoring Xbox Game Bar...
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f

:: Restore mouse acceleration
echo Restoring mouse acceleration...
reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 1 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 6 /f
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 10 /f

:: Restore network defaults
echo Restoring network settings...
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global chimney=disabled >nul
netsh int tcp set global timestamps=enabled >nul

:: Restore timer
echo Restoring system timer defaults...
bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /deletevalue tscsyncpolicy >nul 2>&1

echo.
echo Revert complete!
echo Restart PC recommended.
pause
exit
