@echo off
setlocal EnableExtensions EnableDelayedExpansion
title CS2 One-Click Optimizer Installer
color 0E

echo ============================================
echo  CS2 + WINDOWS ONE-CLICK OPTIMIZER
echo ============================================
echo.

:: Detect hardware
call "%~dp0detect_hardware.bat"

echo Detected:
echo   CPU: !CPU_NAME!
echo   Cores/Threads: !CPU_CORES!/!CPU_THREADS!
echo   GPU: !GPU_NAME!  [Vendor: !GPU_VENDOR!]
echo   RAM: !RAM_GB! GB
echo.

pause

:: Core Windows optimizations
call "%~dp0windows_fps_latency_optimizer.bat"

:: GPU-specific (only safe service toggles)
if /I "!GPU_VENDOR!"=="NVIDIA" call "%~dp0nvidia_optimizer.bat"
if /I "!GPU_VENDOR!"=="AMD" call "%~dp0amd_optimizer.bat"

echo.
echo ============================================
echo Done. Restart PC recommended.
echo ============================================
pause
exit /b 0
