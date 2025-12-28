@echo off
title AMD FPS Optimizer
color 0C

echo Applying AMD performance tweaks...
echo.

:: Disable AMD telemetry
sc stop AMD Crash Defender Service >nul 2>&1
sc config "AMD Crash Defender Service" start=disabled >nul 2>&1

sc stop AMDRSServ >nul 2>&1
sc config AMDRSServ start=disabled >nul 2>&1

echo AMD optimizations applied.
echo Restart PC recommended.
pause
exit
