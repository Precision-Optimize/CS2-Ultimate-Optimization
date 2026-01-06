@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==========================================
:: AMD OPTIMIZER (SAFE & COMPETITIVE)
:: For CS2 / esports usage
:: No UI, no pause, no exit
:: ==========================================

:: --- Enable Hardware Accelerated GPU Scheduling (HAGS) ---
:: Supported on newer AMD GPUs / Windows 11
reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" ^
 /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1

:: --- Prefer High Performance GPU for CS2 ---
:: Important for laptops with hybrid graphics
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" ^
 /v "cs2.exe" /t REG_SZ /d "GpuPreference=2;" /f >nul 2>&1

:: --- Windows Game Scheduling Priority ---
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1

:: --- Disable Fullscreen Optimizations for CS2 ---
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" ^
 /v "cs2.exe" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f >nul 2>&1

endlocal
exit /b
