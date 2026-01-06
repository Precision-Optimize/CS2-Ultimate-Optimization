@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==========================================
:: NVIDIA OPTIMIZER (SAFE & COMPETITIVE)
:: For CS2 / esports usage
:: No UI, no pause, no exit
:: ==========================================

:: --- Enable Hardware Accelerated GPU Scheduling (HAGS) ---
:: 2 = enabled, 1 = disabled, 0 = default
reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" ^
 /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1

:: --- Prefer High Performance GPU for CS2 ---
:: Works for laptops with iGPU + dGPU
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" ^
 /v "cs2.exe" /t REG_SZ /d "GpuPreference=2;" /f >nul 2>&1

:: --- NVIDIA Low Latency (Windows-side hint) ---
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul 2>&1

:: --- Disable Fullscreen Optimizations for CS2 ---
reg add "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" ^
 /v "cs2.exe" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f >nul 2>&1

endlocal
exit /b
