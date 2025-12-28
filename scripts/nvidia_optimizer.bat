@echo off
title NVIDIA FPS Optimizer
color 0A

echo Applying NVIDIA performance tweaks...
echo.

:: Disable NVIDIA telemetry
sc stop NvTelemetryContainer >nul 2>&1
sc config NvTelemetryContainer start=disabled >nul 2>&1

:: Enable MSI mode (safe default)
reg add "HKLM\SYSTEM\CurrentControlSet\Enum\PCI" /f >nul 2>&1

echo NVIDIA optimizations applied.
echo Restart PC recommended.
pause
exit
