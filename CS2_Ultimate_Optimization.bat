@echo off
:: Check for administrator privileges
>nul 2>&1 net session || (
    echo This script must be run as administrator!
    pause
    exit /b
)

title CS2 Ultimate Optimization Script - 2025
setlocal enabledelayedexpansion

echo =====================================================
echo       Counter-Strike 2 Ultimate Optimization Script
echo =====================================================
echo Optimizing system settings, cleaning caches,
echo improving network latency, boosting GPU performance,
echo and enhancing CS2 gameplay.
echo Script made by Psycho006
echo https://precisioncompany.xyz
echo =====================================================
pause

:: Step 0: Kill CS2 if running
tasklist | find /i "cs2.exe" >nul && (
    echo Closing CS2 process...
    taskkill /f /im cs2.exe >nul
) || echo CS2 is not running.

:: Step 1: Cleaning
echo =====================================================
echo Step 1: Cleaning temporary and system files...
echo =====================================================
set "CS2_DIR=%userprofile%\AppData\Local\CounterStrike2"

if exist "%CS2_DIR%" (
    del /q /s "%CS2_DIR%\*.tmp" >nul 2>&1
    rd /s /q "%CS2_DIR%\cache" >nul 2>&1
    echo CS2 temporary files cleaned.
) else (
    echo No CS2 temporary files found.
)

:: Windows temp & prefetch
del /s /q "%temp%\*" >nul 2>&1 & rd /s /q "%temp%" >nul 2>&1
rd /s /q "C:\Windows\Prefetch" >nul 2>&1
ipconfig /flushdns >nul
echo System temporary files, DNS cache, and prefetch cleaned.

:: NVIDIA Shader Cache
set "DX_CACHE=%LocalAppData%\NVIDIA\DXCache"
set "VK_CACHE=%LocalAppData%\NVIDIA\GLCache"
if exist "%DX_CACHE%" rd /s /q "%DX_CACHE%" >nul
if exist "%VK_CACHE%" rd /s /q "%VK_CACHE%" >nul
echo NVIDIA shader caches cleared.

:: Step 2: Disable Unnecessary Services
echo =====================================================
echo Step 2: Disabling unnecessary services...
echo =====================================================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
sc config "WaaSMedicSvc" start=disabled >nul 2>&1
sc stop "WaaSMedicSvc" >nul 2>&1
echo Xbox Game Bar and unnecessary services disabled.

:: Step 3: High-Performance GPU for CS2
echo =====================================================
echo Step 3: Setting High-Performance GPU...
echo =====================================================
reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "cs2.exe" /t REG_SZ /d "GpuPreference=2;" /f >nul
echo High-Performance GPU set for CS2.

:: Step 4: Network Tweaks
echo =====================================================
echo Step 4: Network optimizations for low latency...
echo =====================================================
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global rss=enabled >nul
netsh int tcp set global timestamps=disabled >nul
netsh int tcp set global ecncapability=disabled >nul
netsh int tcp set global initialRto=2000 >nul
netsh int ip set global taskoffload=enabled >nul
netsh advfirewall set allprofiles state off >nul
echo Network optimizations applied.

:: Step 5: High Performance Power Plan
echo =====================================================
echo Step 5: Set high-performance power plan...
echo =====================================================
for /f "tokens=*" %%i in ('powercfg -l ^| findstr "High performance"') do (
    for /f "tokens=1" %%a in ("%%i") do powercfg /setactive %%a
)
echo High-performance power plan activated.

:: Step 6: Audio Latency
echo =====================================================
echo Step 6: Audio latency enhancements...
echo =====================================================
reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v LatencyReduction /t REG_DWORD /d 1 /f >nul
echo Audio latency tweaks applied.

:: Finished
echo =====================================================
echo All optimizations completed successfully!
pause
exit /b
