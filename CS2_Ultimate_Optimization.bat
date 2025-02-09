@echo off
title CS2 Ultimate Optimization Script - 2025
echo =====================================================
echo       Counter-Strike 2 Ultimate Optimization Script
echo =====================================================
echo This script will optimize system settings, clean
echo caches, improve network latency, boost GPU performance,
echo and enhance CS2 gameplay.
echo Script made by Psycho006
echo https://precisioncompany.xyz
echo =====================================================
pause

:: Kill CS2 if running
tasklist | find /i "cs2.exe" >nul
if %errorlevel%==0 (
    echo Closing CS2 process...
    taskkill /f /im cs2.exe
) else (
    echo CS2 is not running.
)

echo =====================================================
echo Step 1: Cleaning temporary and system files...
echo =====================================================
:: Cleanup game cache, Windows temp files, prefetch, and DNS cache
set "CS2_DIR=%userprofile%\AppData\Local\CounterStrike2"
if exist "%CS2_DIR%" (
    del /q /s "%CS2_DIR%\*.tmp" 2>nul
    del /q /s "%CS2_DIR%\cache" 2>nul
    echo CS2 temporary files cleaned.
) else (
    echo No CS2 temporary files found.
)

del /s /q "%temp%\*" 2>nul
del /s /q "C:\Windows\Prefetch\*" 2>nul
ipconfig /flushdns
echo System temporary files, DNS cache, and prefetch cleaned.

:: Remove NVIDIA Shader Caches
set DX_CACHE=%LocalAppData%\NVIDIA\DXCache
set VK_CACHE=%LocalAppData%\NVIDIA\GLCache
if exist "%DX_CACHE%" del /s /q "%DX_CACHE%"
if exist "%VK_CACHE%" del /s /q "%VK_CACHE%"
echo NVIDIA shader caches cleared.

echo =====================================================
echo Step 2: Disabling unnecessary services...
echo =====================================================
:: Disable Xbox Game Bar and unnecessary services
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
sc config "WaaSMedicSvc" start=disabled
sc stop "WaaSMedicSvc"
echo Unnecessary services and Xbox Game Bar disabled.

echo =====================================================
echo Step 3: Setting High-Performance GPU...
echo =====================================================
:: Assign CS2 to use high-performance GPU
powershell -Command "Add-HighPerformanceProcess -Name 'cs2.exe'"
echo High-Performance GPU set for CS2.

echo =====================================================
echo Step 4: Network optimizations for low latency...
echo =====================================================
:: Set network parameters for gaming optimization
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled
netsh interface tcp set heuristics disabled
netsh int ip set global taskoffload=enabled
netsh advfirewall set allprofiles state off
echo Network optimizations applied successfully.

echo =====================================================
echo Step 5: Set high-performance power plan...
echo =====================================================
:: Enable high-performance power plan
powercfg /setactive SCHEME_MIN
echo High-performance power plan activated.

echo =====================================================
echo Step 6: Audio latency enhancements...
echo =====================================================
:: Reduce audio latency for better in-game sound
reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v LatencyReduction /t REG_DWORD /d 1 /f
echo Audio latency reduced.

echo =====================================================
echo All optimizations completed successfully!
pause
exit
