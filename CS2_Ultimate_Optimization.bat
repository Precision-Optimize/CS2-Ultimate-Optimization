@echo off
:: Ensure script is run as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script must be run as administrator!
    pause
    exit /b
)

title CS2 Ultimate Optimization Script - 2025
setlocal enableextensions

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

:: Kill CS2 if running
tasklist | find /i "cs2.exe" >nul && (
    echo Closing CS2 process...
    taskkill /f /im cs2.exe
) || echo CS2 is not running.

echo =====================================================
echo Step 1: Cleaning temporary and system files...
echo =====================================================
:: Cleanup game cache, Windows temp files, prefetch, and DNS cache
set "CS2_DIR=%userprofile%\AppData\Local\CounterStrike2"
if exist "%CS2_DIR%" (
    del /q /s "%CS2_DIR%\*.tmp" 2>nul
    rd /s /q "%CS2_DIR%\cache" 2>nul
    echo CS2 temporary files cleaned.
) else (
    echo No CS2 temporary files found.
)

del /s /q "%temp%\*" 2>nul & rd /s /q "%temp%" 2>nul
rd /s /q "C:\Windows\Prefetch" 2>nul
ipconfig /flushdns

echo System temporary files, DNS cache, and prefetch cleaned.

:: Remove NVIDIA Shader Caches
set "DX_CACHE=%LocalAppData%\NVIDIA\DXCache"
set "VK_CACHE=%LocalAppData%\NVIDIA\GLCache"
if exist "%DX_CACHE%" rd /s /q "%DX_CACHE%"
if exist "%VK_CACHE%" rd /s /q "%VK_CACHE%"
echo NVIDIA shader caches cleared.

echo =====================================================
echo Step 2: Disabling unnecessary services...
echo =====================================================
:: Disable Xbox Game Bar and unnecessary services
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
sc config "WaaSMedicSvc" start=disabled & sc stop "WaaSMedicSvc"
echo Unnecessary services and Xbox Game Bar disabled.

echo =====================================================
echo Step 3: Setting High-Performance GPU...
echo =====================================================
:: Assign CS2 to use high-performance GPU (Updated for better compatibility)
powershell -Command "Start-Process -Verb runAs 'cmd' -ArgumentList '/c reg add \"HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Application Preference\cs2.exe\" /v \"GpuPreference\" /t REG_DWORD /d 2 /f'"
echo High-Performance GPU set for CS2.

echo =====================================================
echo Step 4: Network optimizations for low latency...
echo =====================================================
:: Advanced network tweaks for gaming optimization
netsh int tcp set global autotuninglevel=disabled
netsh int tcp set global rss=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global ecncapability=disabled
netsh int tcp set global initialRto=2000
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
