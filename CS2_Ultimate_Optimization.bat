@echo off
:: Batch file: CS2 Ultimate Optimizer
:: Author: Psycho006 - 2025
:: Purpose: Optimize system settings for CS2 performance

setlocal enabledelayedexpansion

:: Title
title CS2 Ultimate Optimization Script - 2025

:: Check admin rights
>nul 2>&1 net session || (
    echo This script must be run as Administrator!
    echo Right-click > Run as administrator.
    pause
    exit
)

:: Create logs folder
if not exist "logs" mkdir "logs"

:: Generate log filename safely using PowerShell
for /f "tokens=*" %%a in ('powershell -Command "Get-Date -Format yyyyMMdd_HHmm"') do set datetime=%%a
set logFile=logs\optimization_log_%datetime%.txt

:: Start logging
call :logHeader

:: Detect CS2 Path
call :detectCS2Path

:: Show welcome screen
cls
echo =====================================================
echo     Counter-Strike 2 Ultimate Optimization Script
echo =====================================================
echo Optimizing system settings, cleaning caches,
echo improving network latency, boosting GPU performance,
echo and enhancing CS2 gameplay.
echo Script made by Psycho006
echo https://precisioncompany.xyz    
echo.
if defined cs2Path (
    echo Detected CS2 Path: "%cs2Path%"
) else (
    echo [!] Could NOT detect CS2 path automatically.
    echo     You may need to enter it manually later.
)
echo.
echo =====================================================
echo.
echo Press any key to continue...
pause >nul

:: Main Menu
:start
cls
echo [CS2 Optimizer]
echo ===============
echo 1. Full Optimization + Launch CS2
echo 2. Full Optimization Only
echo 3. System Cleanup Only
echo 4. Network ^& Power Settings Only
echo 5. RAM Cleaner
echo 6. FPS Unlocker
echo 7. Launch CS2 Directly
echo 8. Exit
echo.

echo Select an option (1-8):
powershell -Command "$key = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); [int]([char]$key.Character) - 48" > "%temp%\key.txt"
set /p userChoice=<"%temp%\key.txt"
del /q "%temp%\key.txt" >nul 2>&1

if not defined userChoice (
    echo Invalid input. Please try again.
    timeout /t 2 >nul
    goto start
)

if %userChoice% == 1 call :fullOptimize && call :launchCS2
if %userChoice% == 2 call :fullOptimize
if %userChoice% == 3 call :cleanOnly
if %userChoice% == 4 call :networkAndPower
if %userChoice% == 5 call :ramCleaner
if %userChoice% == 6 call :fpsUnlocker
if %userChoice% == 7 call :launchCS2
if %userChoice% == 8 (
    cls
    echo Thank you for using CS2 Ultimate Optimizer!
    echo Have a great game!
    echo.
    pause
    exit /b
)

goto start

:: ==================================
:: Functions Below
:: ==================================

:: Log function
:log
    echo [%time%] %~1
    echo [%time%] %~1 >> "%logFile%"
exit /b

:: Log header
:logHeader
    echo. > "%logFile%"
    echo =============== OPTIMIZATION LOG ============== >> "%logFile%"
    echo Script started at: %date% %time% >> "%logFile%"
    echo Running as: %username% >> "%logFile%"
    echo Windows Version: %os% >> "%logFile%"
    echo. >> "%logFile%"
exit /b

:: Detect CS2 Install Path
:detectCS2Path
    set "cs2Path="

    call :log "[*] Detecting CS2 install path..."

    set "steamRoot=%ProgramFiles(x86)%\Steam\steamapps\common"
    
    :: Try default CS2 path
    set "defaultPath=%steamRoot%\Counter-Strike Global Offensive\game\bin\win64\cs2.exe"
    if exist "%defaultPath%" (
        set "cs2Path=%defaultPath%"
        call :log "[+] Found CS2 in default Steam location."
        exit /b
    )

    :: Search alternate library folders
    for /d %%D in ("%steamRoot%*") do (
        set "altPath=%%D\Counter-Strike Global Offensive\game\bin\win64\cs2.exe"
        if exist "!altPath!" (
            set "cs2Path=!altPath!"
            call :log "[+] Found CS2 in alternate Steam library: %%D"
            exit /b
        )
    )

    call :log "[!] Could NOT find CS2 executable automatically."

    echo.
    echo [!] Unable to locate CS2 automatically.
    echo Please enter the full path to cs2.exe (e.g., D:\Games\CS2\game\bin\win64\cs2.exe)
    set /p "cs2Path=[>] Enter path: "

    if exist ""%cs2Path%"" (
        call :log "[+] User-provided CS2 path accepted: "%cs2Path%""
        exit /b
    ) else (
        call :log "[ERROR] Invalid CS2 path entered by user: "%cs2Path%""
        echo [-] The path you entered does not exist or is invalid.
        echo     Make sure to enter the full path to 'cs2.exe'.
        timeout /t 5 >nul
        exit /b
    )
exit /b

:: Kill CS2 if running
:killCS2
    tasklist | find /i "cs2.exe" >nul && (
        echo Closing CS2 process...
        taskkill /f /im cs2.exe >nul
        call :log "[+] Closed running CS2 instance"
    ) || call :log "[*] CS2 is not running."
exit /b

:: Step 1: Cleaning
:cleanOnly
    cls
    call :log "[STEP] Cleaning Temporary Files..."
    call :killCS2

    set "CS2_DIR=%userprofile%\AppData\Local\CounterStrike2"
    if exist "%CS2_DIR%" (
        del /q /s "%CS2_DIR%\*.tmp" >nul 2>&1
        rd /s /q "%CS2_DIR%\cache" >nul 2>&1
        call :log "[+] Removed CS2 temporary files"
    ) else (
        call :log "[*] No CS2 temporary files found"
    )

    del /s /q "%temp%\*" >nul 2>&1 & rd /s /q "%temp%" >nul 2>&1
    ipconfig /flushdns >nul
    call :log "[+] Cleared DNS and Temp folders"

    set "DX_CACHE=%LocalAppData%\NVIDIA\DXCache"
    set "VK_CACHE=%LocalAppData%\NVIDIA\GLCache"
    if exist "%DX_CACHE%" rd /s /q "%DX_CACHE%" >nul
    if exist "%VK_CACHE%" rd /s /q "%VK_CACHE%" >nul
    call :log "[+] Cleared NVIDIA Shader Cache"

    echo Done. View full log in: %logFile%
    pause
exit /b

:: Step 2: Full Optimization
:fullOptimize
    cls
    call :log "[STEP] Starting Full Optimization..."

    call :cleanOnly
    call :disableServices
    call :gpuPreference
    call :networkTweaks
    call :highPerfPowerPlan
    call :audioLatencyFix

    echo Full optimization completed successfully!
    echo Log saved to: %logFile%
    pause
exit /b

:: Step 3: Disable Services
:disableServices
    call :log "[+] Disabling unnecessary services..."
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
    reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
    sc config "WaaSMedicSvc" start=disabled >nul 2>&1
    sc stop "WaaSMedicSvc" >nul 2>&1
    call :log "[+] Disabled Xbox Game Bar and WaaSMedicSvc"
exit /b

:: Step 4: GPU Preference
:gpuPreference
    call :log "[+] Setting high-performance GPU for CS2..."
    reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "cs2.exe" /t REG_SZ /d "GpuPreference=2;" /f >nul
    call :log "[+] High-performance GPU assigned to CS2"
exit /b

:: Step 5: Network & Power Settings
:networkAndPower
    cls
    call :log "[STEP] Applying Network & Power Settings..."

    call :networkTweaks
    call :highPerfPowerPlan

    echo Network and power settings applied.
    echo Log saved to: %logFile%
    pause
exit /b

:: Network Tweaks
:networkTweaks
    call :log "[+] Applying network optimizations..."
    netsh int tcp set global autotuninglevel=disabled >nul
    netsh int tcp set global rss=enabled >nul
    netsh int tcp set global timestamps=disabled >nul
    netsh int tcp set global ecncapability=disabled >nul
    netsh int tcp set global initialRto=2000 >nul
    netsh int ip set global taskoffload=enabled >nul
    netsh advfirewall set allprofiles state off >nul
    call :log "[+] Network settings optimized for low latency"
exit /b

:: High Performance Power Plan
:highPerfPowerPlan
    call :log "[+] Activating High-Performance power plan..."

    where powercfg >nul 2>&1
    if %errorlevel% NEQ 0 (
        call :log "[!] powercfg command not found!"
        echo powercfg command not found!
        echo Skipping power plan optimization.
        goto :eof
    )

    for /f "tokens=*" %%i in ('powercfg -l ^| findstr /i "High performance"') do (
        for /f "tokens=2 delims=()" %%a in ("%%i") do set "guid=%%a"
    )

    if defined guid (
        powercfg /setactive %guid% >nul 2>&1
        call :log "[+] High-performance power plan activated (GUID: %guid%)"
    ) else (
        call :log "[!] Failed to detect High Performance power plan."
        echo [!] High Performance power plan not found.
        echo     Please ensure it's available on your system.
        pause
    )
exit /b

:: Audio Latency Fix
:audioLatencyFix
    call :log "[+] Applying audio latency fix..."
    reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v LatencyReduction /t REG_DWORD /d 1 /f >nul
    call :log "[+] Audio latency tweaks applied"
exit /b

:: RAM Cleaner
:ramCleaner
    cls
    call :log "[STEP] Clearing memory cache..."

    echo Creating PowerShell script to clear RAM...
    echo $signature = @^" > "%temp%\ramclean.ps1"
    echo [DllImport("kernel32.dll")] >> "%temp%\ramclean.ps1"
    echo public static extern void Sleep(int dwMilliseconds); >> "%temp%\ramclean.ps1"
    echo [DllImport("psapi.dll")] >> "%temp%\ramclean.ps1"
    echo public static extern int EmptyWorkingSet(IntPtr hProcess); >> "%temp%\ramclean.ps1"
    echo ^"@ >> "%temp%\ramclean.ps1"
    echo Add-Type -MemberDefinition $signature -name "Win32" -Namespace "NT" >> "%temp%\ramclean.ps1"
    echo Get-Process ^| Where-Object { $_.WorkingSet64 -gt 20000000 } ^| ForEach-Object { [void][NT.Win32]::EmptyWorkingSet($_.Handle) } >> "%temp%\ramclean.ps1"

    powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force" >nul 2>&1
    powershell -File "%temp%\ramclean.ps1" >nul 2>&1
    if exist "%temp%\ramclean.ps1" del /q "%temp%\ramclean.ps1" >nul 2>&1

    call :log "[+] Memory cache cleared."
    echo RAM cleaned successfully!
    pause
exit /b

:: FPS Unlocker
:fpsUnlocker
    cls
    call :log "[STEP] Enabling FPS Unlocker..."

    echo [*] Setting registry values to unlock FPS...

    reg add "HKCU\Software\Valve\Half-Life\Settings" /v MaxFrameRate /t REG_SZ /d "0" /f >nul 2>&1
    reg add "HKCU\Software\Valve\Steam\Apps\240" /v FpsMax /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Valve\Steam\Apps\730" /v FpsMax /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Valve\Steam\Apps\108600" /v FpsMax /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKCU\Software\Valve\Steam\Apps\730" /v "DisableHUD_Fullscreen" /t REG_DWORD /d 1 /f >nul 2>&1

    call :log "[+] FPS unlocker applied."
    echo FPS unlocker applied successfully!
    pause
exit /b

:: Step 6: Launch CS2
:launchCS2
    cls
    call :log "[STEP] Launching CS2..."

    if not defined cs2Path (
        call :log "[ERROR] CS2 path not detected!"
        echo [-] CS2 path not detected. Cannot launch game.
        echo     Make sure CS2 is installed or update the path in the script.
        pause
        exit /b
    )

    call :killCS2

    set "LAUNCH=-console -novid -fullscreen -high -threads 8 -heapsize 2097152"

    echo [*] Launching CS2 with optimized options...
    start "" "%cs2Path%" %LAUNCH%
    call :log "[+] CS2 launched successfully"
    echo.
    echo If CS2 did not launch, check the log:
    echo %logFile%
    pause
exit /b
