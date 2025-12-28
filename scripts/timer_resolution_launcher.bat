@echo off
title CS2 Timer Resolution Launcher
color 0B

echo ============================================
echo  CS2 TIMER RESOLUTION LAUNCHER
echo ============================================
echo.
echo This will temporarily improve input latency.
echo.

:: Launch TimerResolution if available
if exist TimerResolution.exe (
    start "" TimerResolution.exe --resolution 5000
) else (
    echo TimerResolution.exe not found!
)

:: Launch CS2
start steam://rungameid/730

echo.
echo Timer active while CS2 is running.
pause
exit
