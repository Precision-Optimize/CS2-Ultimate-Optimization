@echo off
:: Batch file: CS2 Ultimate Optimizer (Enhanced)
:: Author: Psycho006 — 2025
:: Purpose: Optimize system settings for CS2 performance (with safer defaults)

setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul

:: =============================
:: Banner & Admin check
:: =============================
title CS2 Ultimate Optimization Script - 2025 (Enhanced)

>nul 2>&1 net session || (
  echo [!] This script must be run as Administrator.
  echo     Right-click the .bat ^> Run as administrator.
  pause
  exit /b
)

:: =============================
:: Log setup (rotate: keep last 3 files)
:: =============================
if not exist "logs" mkdir "logs"
for /f "tokens=*" %%a in ('powershell -NoP -C "Get-Date -Format yyyyMMdd_HHmmss"') do set datetime=%%a
set "logFile=logs\optimization_%datetime%.txt"
for /f "skip=3 delims=" %%L in ('dir /b /a:-d /o:-d logs\optimization_*.txt 2^>nul') do del /q "logs\%%L" >nul 2>&1

call :logHeader

:: =============================
:: Detect CS2 path
:: =============================
call :detectCS2Path

:: =============================
:: Main menu
:: =============================
:menu
cls
echo =====================================================
echo          Counter-Strike 2 — Ultimate Optimization
echo =====================================================
if defined cs2Path (echo CS2 path: "%cs2Path%") else (echo CS2 path: [not detected])
echo Log: "%logFile%"
echo -----------------------------------------------------
echo  1. Full Optimization + Launch CS2
echo  2. Full Optimization Only
echo  3. System Cleanup Only (cache, temp, shaders)
echo  4. Network ^& Power Settings Only
echo  5. RAM Cleaner
echo  6. FPS Unlocker
echo  7. Launch CS2 (smart options)
echo -----------------------------------------------------
echo  8. Create System Restore Point
echo  9. Quick Integrity Check (SFC ScanNow)
echo 10. Ping Test to Valve servers
echo 11. Restore Default Network Tweaks
echo 12. Exit
echo -----------------------------------------------------
<nul set /p "=Choose (1-12): "

powershell -NoP -C "$k=$Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown'); [int]([char]$k.Character)" > "%temp%\key.txt"
set /p key=<"%temp%\key.txt"
del /q "%temp%\key.txt" >nul 2>&1

if "%key%"=="49" call :fullOptimize ^&^& call :launchCS2
if "%key%"=="50" call :fullOptimize
if "%key%"=="51" call :cleanOnly
if "%key%"=="52" call :networkAndPower
if "%key%"=="53" call :ramCleaner
if "%key%"=="54" call :fpsUnlocker
if "%key%"=="55" call :launchCS2
if "%key%"=="56" call :createRestorePoint
if "%key%"=="57" call :integrityCheck
if "%key%"=="58" call :pingTest
if "%key%"=="59" call :restoreNetDefaults
if "%key%"=="60" goto :exitOK

goto :menu

:: =============================
:: LOG helpers
:: =============================
:log
  echo [!TIME!] %~1
  >>"%logFile%" echo [!TIME!] %~1
  exit /b

:logHeader
  >"%logFile%" echo ============ CS2 ULTIMATE OPTIMIZATION LOG ============
  >>"%logFile%" echo Start: %DATE% %TIME%
  >>"%logFile%" echo User: %USERNAME% ^| Host: %COMPUTERNAME%
  >>"%logFile%" ver | >>"%logFile%" findstr /i "Microsoft"
  >>"%logFile%" echo ======================================================
  exit /b

:: =============================
:: Detect CS2 Install Path (robust via Steam vdf)
:: =============================
:detectCS2Path
  set "cs2Path="
  call :log "[*] Detecting CS2 path..."

  set "default=%ProgramFiles(x86)%\Steam\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe"
  if exist "%default%" (
    set "cs2Path=%default%"
    call :log "[+] Found default CS2: %default%"
    exit /b
  )

  :: Parse libraryfolders.vdf for all libraries and search CS2
  for /f "tokens=*" %%V in ('powershell -NoP -C ^
    "$v='$env:ProgramFiles(x86)\Steam\steamapps\libraryfolders.vdf'; ^
     if(Test-Path $v){ ^
       (Get-Content $v) -join \"`n\" ^| ^
       Select-String -Pattern '\"path\"\\s+\"([^\"]+)' -AllMatches ^| ^
       %%{ $_.Matches.Groups[1].Value } ^
     }"') do (
       set "try=%%V\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe"
       if exist "!try!" (
         set "cs2Path=!try!"
         call :log "[+] Found CS2 in library: !try!"
         exit /b
       )
  )

  call :log "[!] Auto-detection failed."
  echo.
  echo [!] Unable to auto-locate cs2.exe
  set /p "cs2Path=Enter FULL path to cs2.exe: "
  if exist "%cs2Path%" (
      call :log "[+] Path accepted: %cs2Path%"
  ) else (
      call :log "[ERROR] Invalid path: %cs2Path%"
      echo Invalid path. Skipping auto-launch.
      set "cs2Path="
  )
  exit /b

:: =============================
:: Kill CS2 if running
:: =============================
:killCS2
  tasklist | find /i "cs2.exe" >nul && (
    call :log "[*] Closing cs2.exe"
    taskkill /f /im cs2.exe >nul 2>&1
    call :log "[+] cs2.exe closed"
  ) || call :log "[*] CS2 is not running."
  exit /b

:: =============================
:: CLEAN ONLY (Temp, caches, shaders)
:: =============================
:cleanOnly
  cls
  call :log "[STEP] Cleaning..."
  call :killCS2

  set "CS2_LOCAL=%LocalAppData%\CounterStrike2"
  if exist "%CS2_LOCAL%" (
    del /q /s "%CS2_LOCAL%\*.tmp" >nul 2>&1
    for %%D in (cache cached shaders) do if exist "%CS2_LOCAL%\%%D" rd /s /q "%CS2_LOCAL%\%%D" >nul 2>&1
    call :log "[+] CS2 local cache cleaned"
  ) else (
    call :log "[*] CS2 local folder not found"
  )

  :: Windows TEMP: remove contents only (keep folder)
  for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" 2>nul
  del /f /q "%TEMP%\*" 2>nul
  call :log "[+] TEMP cleaned"

  :: Shader cache NVIDIA / AMD / DX / Vulkan
  for %%P in ("%LocalAppData%\NVIDIA\DXCache"
              "%LocalAppData%\NVIDIA\GLCache"
              "%LocalAppData%\AMD\DxCache"
              "%LocalAppData%\D3DSCache"
              "%LocalAppData%\Microsoft\Windows\DXCache"
              "%AppData%\NVIDIA\ComputeCache"
              "%LocalAppData%\cache\vk" ) do (
      if exist "%%~fP" rd /s /q "%%~fP" 2>nul
  )
  call :log "[+] Shader cache cleaned (NVIDIA/AMD/DX/Vulkan)"

  ipconfig /flushdns >nul
  call :log "[+] DNS cache flushed"

  echo Done. Log: %logFile%
  pause
  exit /b

:: =============================
:: FULL OPTIMIZE (safe defaults)
:: =============================
:fullOptimize
  cls
  call :log "[STEP] Full Optimization start"
  call :cleanOnly
  call :disableServices
  call :gpuTweaks
  call :networkTweaks
  call :powerPlanCS2
  call :audioLatencyFix
  call :gameModeOn
  call :log "[STEP] Full Optimization done"
  echo Completed. Log: %logFile%
  pause
  exit /b

:: =============================
:: Disable noisy services (Xbox DVR, WaaSMedicSvc best-effort)
:: =============================
:disableServices
  call :log "[*] Disabling GameDVR/Xbox Bar..."
  reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
  reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
  sc config "WaaSMedicSvc" start=disabled >nul 2>&1
  sc stop "WaaSMedicSvc" >nul 2>&1
  call :log "[+] GameDVR disabled; WaaSMedicSvc disabled (if permitted)"
  exit /b

:: =============================
:: GPU tweaks (HAGS, per-app GPU)
:: =============================
:gpuTweaks
  call :log "[*] GPU tweaks..."
  :: HAGS ON (2=enable, 1=disable, 0=default)
  reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1

  :: Per-app GPU preference — use full path if available
  if defined cs2Path (
    reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "%cs2Path%" /t REG_SZ /d "GpuPreference=2;" /f >nul
    call :log "[+] High-performance GPU set for: %cs2Path%"
  ) else (
    reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "cs2.exe" /t REG_SZ /d "GpuPreference=2;" /f >nul
    call :log "[*] High-performance GPU set for cs2.exe (generic)"
  )
  exit /b

:: =============================
:: Network tweaks (safe) + backup
:: =============================
:networkTweaks
  call :log "[*] Network tweaks (logging current settings)..."
  (
    echo ==== BEFORE ====
    netsh int tcp show global
  )>>"%logFile%"

  :: Soft optimizations (no firewall changes)
  netsh int tcp set heuristics disabled >nul
  netsh int tcp set global autotuninglevel=disabled >nul
  netsh int tcp set global rss=enabled >nul
  netsh int tcp set global timestamps=disabled >nul
  netsh int tcp set global ecncapability=disabled >nul
  netsh int ip set global taskoffload=enabled >nul

  (
    echo ==== AFTER ====
    netsh int tcp show global
  )>>"%logFile%"

  call :log "[+] Low-latency TCP applied (heuristics off, autotune off, RSS on; firewall unchanged)"
  exit /b

:: =============================
:: Restore “defaults” for network
:: =============================
:restoreNetDefaults
  cls
  call :log "[STEP] Restoring network defaults"
  netsh int tcp set heuristics default >nul
  netsh int tcp set global autotuninglevel=normal >nul
  netsh int tcp set global rss=default >nul
  netsh int tcp set global timestamps=default >nul
  netsh int tcp set global ecncapability=default >nul
  netsh int ip set global taskoffload=default >nul
  call :log "[+] Network defaults restored"
  echo Reverted to default TCP/IP settings (without resetting IP stack).
  pause
  exit /b

:: =============================
:: High-perf Power Plan (custom CS2 Ultimate)
:: =============================
:powerPlanCS2
  call :log "[*] Power plan configuration..."
  set "CS2_GUID="

  :: Find or create custom plan
  for /f "tokens=1,2 delims= " %%a in ('powercfg -list ^| findstr /i "CS2-Ultimate"') do set "CS2_GUID=%%b"
  if not defined CS2_GUID (
    powercfg -duplicatescheme SCHEME_MIN >nul 2>&1
    for /f "tokens=2 delims=()" %%g in ('powercfg -list ^| findstr /i "High performance"') do set "HP_GUID=%%g"
    if defined HP_GUID (
      powercfg -duplicatescheme %HP_GUID% >nul 2>&1
      for /f "tokens=2 delims=()" %%g in ('powercfg -list ^| findstr /i "Copy of"') do set "TMP_GUID=%%g"
      if defined TMP_GUID (
        powercfg -changename %TMP_GUID% "CS2-Ultimate" "CS2 Optimized Plan" >nul
        set "CS2_GUID=%TMP_GUID%"
      )
    )
  )

  if not defined CS2_GUID (
    call :log "[!] Plan was not created; trying to activate High performance"
    for /f "tokens=2 delims=()" %%g in ('powercfg -list ^| findstr /i "High performance"') do set "CS2_GUID=%%g"
  )

  if defined CS2_GUID (
    powercfg -setactive %CS2_GUID% >nul 2>&1

    :: Fine-tune (AC)
    powercfg /setacvalueindex %CS2_GUID% SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul
    powercfg /setacvalueindex %CS2_GUID% SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul
    powercfg /setacvalueindex %CS2_GUID% SUB_PROCESSOR IDLEDISABLE 1 >nul
    powercfg /setacvalueindex %CS2_GUID% SUB_PCIEXPRESS ASPM 0 >nul
    powercfg /setacvalueindex %CS2_GUID% SUB_SLEEP STANDBYIDLE 0 >nul
    powercfg -SetActive %CS2_GUID% >nul
    call :log "[+] Power plan active: %CS2_GUID%"
  ) else (
    call :log "[!] Unable to configure power plan."
  )
  exit /b

:: =============================
:: Audio latency tweak
:: =============================
:audioLatencyFix
  reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v LatencyReduction /t REG_DWORD /d 1 /f >nul 2>&1
  call :log "[+] Audio latency tweak applied"
  exit /b

:: =============================
:: Game Mode ON
:: =============================
:gameModeOn
  reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
  reg add "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul 2>&1
  call :log "[+] Windows Game Mode enabled"
  exit /b

:: =============================
:: RAM Cleaner (safer)
:: =============================
:ramCleaner
  cls
  call :log "[STEP] RAM clean"
  echo $sig=@"
  echo [DllImport("psapi.dll")] public static extern int EmptyWorkingSet(IntPtr hProcess);
  echo "@
  echo Add-Type -MemberDefinition $sig -Name A -Namespace B
  echo Get-Process ^|? {$_.WorkingSet64 -gt 200MB} ^|%% { [void][B.A]::EmptyWorkingSet($_.Handle) } > "%temp%\ramclean.ps1"

  powershell -NoP -ExecutionPolicy Bypass -File "%temp%\ramclean.ps1" >nul 2>&1
  del /q "%temp%\ramclean.ps1" >nul 2>&1
  call :log "[+] RAM cleaned"
  echo RAM cleaned.
  pause
  exit /b

:: =============================
:: FPS Unlocker
:: =============================
:fpsUnlocker
  cls
  call :log "[STEP] FPS unlock"
  reg add "HKCU\Software\Valve\Steam\Apps\730" /v FpsMax /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKCU\Software\Valve\Half-Life\Settings" /v MaxFrameRate /t REG_SZ /d "0" /f >nul 2>&1
  reg add "HKCU\Software\Valve\Steam\Apps\730" /v DisableHUD_Fullscreen /t REG_DWORD /d 1 /f >nul 2>&1
  call :log "[+] FPS unlock applied (Steam/HL keys)"
  echo FPS unlock applied.
  pause
  exit /b

:: =============================
:: Network + Power (menu item)
:: =============================
:networkAndPower
  cls
  call :log "[STEP] Network+Power"
  call :networkTweaks
  call :powerPlanCS2
  echo Applied. Log: %logFile%
  pause
  exit /b

:: =============================
:: Launch CS2 (smart launch opts)
:: =============================
:launchCS2
  cls
  call :log "[STEP] Launch CS2"
  if not defined cs2Path (
    call :log "[ERROR] cs2Path is not set."
    echo CS2 path not detected. Trying Steam fallback...
    start "" "steam://rungameid/730"
    call :log "[*] Attempted steam://rungameid/730"
    pause
    exit /b
  )

  call :killCS2

  :: Dynamic -threads
  for /f "tokens=*" %%c in ('wmic cpu get NumberOfLogicalProcessors /value ^| find "="') do set "%%c"
  set "threads=%NumberOfLogicalProcessors%"
  if not defined threads set "threads=8"

  :: Heapsize (2GB), -high, -novid
  set "LAUNCH=-console -novid -fullscreen -high -threads %threads% -heapsize 2097152 +fps_max 0"

  call :log "[*] Launch opts: %LAUNCH%"
  start "" "%cs2Path%" %LAUNCH%
  call :log "[+] CS2 started"
  echo Launched. If CS2 didn't start, check the log: %logFile%
  pause
  exit /b

:: =============================
:: Create System Restore Point
:: =============================
:createRestorePoint
  cls
  call :log "[STEP] Create Restore Point"
  powershell -NoP -C "Checkpoint-Computer -Description 'CS2-Ultimate-Restore' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
  if %ERRORLEVEL% EQU 0 (
    call :log "[+] Restore point created"
    echo System Restore Point created.
  ) else (
    call :log "[!] Failed (System Protection may be disabled)"
    echo Failed. Enable System Protection for your system drive.
  )
  pause
  exit /b

:: =============================
:: Quick Integrity Check
:: =============================
:integrityCheck
  cls
  echo This will run: sfc /scannow (may take a while).
  echo Close the new window to cancel.
  pause
  start cmd /k sfc /scannow
  call :log "[*] SFC scan started in a new window"
  exit /b

:: =============================
:: Ping test
:: =============================
:pingTest
  cls
  call :log "[STEP] Ping test"
  echo Testing ping to Steam/Valve anycast IP (cm-addr.valvesoftware.com)...
  nslookup cm-addr.valvesoftware.com 1.1.1.1
  echo.
  ping -n 6 cm-addr.valvesoftware.com
  echo.
  pause
  exit /b

:: =============================
:: EXIT
:: =============================
:exitOK
  cls
  echo Thanks for using CS2 Ultimate Optimizer!
  echo Have a great game! ^:^)
  echo.
  pause
  exit /b
