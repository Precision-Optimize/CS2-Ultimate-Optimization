@echo off
:: CS2 Ultimate Optimizer — v1.3 (no auto-close, no PowerShell required)
:: Author: Psycho006 + ChatGPT — 2025

setlocal EnableExtensions EnableDelayedExpansion
title CS2 Ultimate Optimization Script - 2025 (v1.3)

:: ------------------------------------------------------------------
:: 0) UNIVERSAL NO-AUTO-CLOSE SAFETY
:: ------------------------------------------------------------------
:: Any unexpected path should end with a PAUSE instead of just closing.
set "HOLD_OPEN=1"

:: ------------------------------------------------------------------
:: 1) SELF-ELEVATE (no PowerShell)
::    - If not admin, relaunch this file with UAC prompt using mshta.
:: ------------------------------------------------------------------
if /i "%~1"=="ELEV" shift & goto :elevated

>nul 2>&1 net session
if not "%errorlevel%"=="0" (
  echo [!] Administrator privileges are required. Asking UAC...
  mshta "javascript:var sh=new ActiveXObject('Shell.Application');sh.ShellExecute('%~fnx0','ELEV','','runas',1);close();"
  echo If you didn't see a UAC prompt, right-click the .bat and choose "Run as administrator".
  if defined HOLD_OPEN pause
  exit /b
)

:elevated
:: We're now elevated (or already were).

:: ------------------------------------------------------------------
:: 2) BASIC ENV + LOGGING (no PowerShell used for timestamps)
:: ------------------------------------------------------------------
if not exist "logs" mkdir "logs" >nul 2>&1

:: Try WMIC timestamp (locale-proof). Fallback to %date%_%time%.
set "datetime="
for /f "tokens=2 delims==" %%A in ('wmic os get LocalDateTime /value 2^>nul') do set "ldt=%%A"
if defined ldt set "datetime=%ldt:~0,8%_%ldt:~8,6%"
if not defined datetime (
  set "d=%date%"
  set "t=%time%"
  set "d=%d:/=-%"
  set "t=%t::=-%"
  set "t=%t: =0%"
  set "datetime=%d%_%t:~0,8%"
)
set "logFile=logs\optimization_%datetime%.txt"

:: Log rotate: keep newest 3
set /a __count=0
for /f "delims=" %%L in ('dir /b /a:-d /o:-d logs\optimization_*.txt 2^>nul') do (
  set /a __count+=1
  if !__count! gtr 3 del /q "logs\%%L" >nul 2>&1
)

call :logHeader

:: ------------------------------------------------------------------
:: 3) DETECT CS2 PATH (no PowerShell; default + common Steam libs)
:: ------------------------------------------------------------------
set "cs2Path="
call :detectCS2Path

:: ------------------------------------------------------------------
:: 4) MAIN MENU LOOP (CHOICE only; no PS key reader)
:: ------------------------------------------------------------------
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
echo  A. Ping Test to Valve servers
echo  B. Restore Default Network Tweaks
echo  X. Exit
echo -----------------------------------------------------
choice /c 123456789ABX /n /m "Choose (1-9, A, B, X): "
set "sel=%errorlevel%"
:: Map CHOICE index to actions: 1..9, 10=A, 11=B, 12=X
if "%sel%"=="1"  call :fullOptimize & call :launchCS2 & goto :menu
if "%sel%"=="2"  call :fullOptimize & goto :menu
if "%sel%"=="3"  call :cleanOnly & goto :menu
if "%sel%"=="4"  call :networkAndPower & goto :menu
if "%sel%"=="5"  call :ramCleaner & goto :menu
if "%sel%"=="6"  call :fpsUnlocker & goto :menu
if "%sel%"=="7"  call :launchCS2 & goto :menu
if "%sel%"=="8"  call :createRestorePoint & goto :menu
if "%sel%"=="9"  call :integrityCheck & goto :menu
if "%sel%"=="10" call :pingTest & goto :menu
if "%sel%"=="11" call :restoreNetDefaults & goto :menu
if "%sel%"=="12" goto :exitOK

echo Invalid option. Press any key...
pause >nul
goto :menu

:: =====================================================
::                       FUNCTIONS
:: =====================================================

:log
  echo [!time!] %~1
  >>"%logFile%" echo [!time!] %~1
  exit /b

:logHeader
  >"%logFile%" echo ============ CS2 ULTIMATE OPTIMIZATION LOG ============
  >>"%logFile%" echo Start: %date% %time%
  >>"%logFile%" echo User: %USERNAME% ^| Host: %COMPUTERNAME%
  ver | >>"%logFile%" findstr /i "Microsoft"
  >>"%logFile%" echo ======================================================
  exit /b

:detectCS2Path
  call :log "[*] Detecting CS2 path..."
  set "default=%ProgramFiles(x86)%\Steam\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe"
  if exist "%default%" (
    set "cs2Path=%default%"
    call :log "[+] Found default CS2: %default%"
    exit /b
  )

  :: Try common alternate Steam libraries on drives D: E: F:
  for %%D in (D E F G H) do (
    set "try=%%D:\SteamLibrary\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe"
    if exist "!try!" (
      set "cs2Path=!try!"
      call :log "[+] Found CS2 in SteamLibrary: !try!"
      exit /b
    )
    set "try=%%D:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\bin\win64\cs2.exe"
    if exist "!try!" (
      set "cs2Path=!try!"
      call :log "[+] Found CS2 under Program Files on %%D:"
      exit /b
    )
  )

  call :log "[!] Auto-detection failed."
  echo.
  echo [!] Unable to auto-locate cs2.exe
  set /p "cs2Path=Enter FULL path to cs2.exe (or leave blank to skip): "
  if defined cs2Path (
    if exist "%cs2Path%" (
      call :log "[+] Path accepted: %cs2Path%"
    ) else (
      call :log "[ERROR] Invalid path entered: %cs2Path%"
      echo Invalid path. Steam fallback will be used when launching.
      set "cs2Path="
      timeout /t 2 >nul
    )
  )
  exit /b

:killCS2
  tasklist | find /i "cs2.exe" >nul && (
    call :log "[*] Closing cs2.exe"
    taskkill /f /im cs2.exe >nul 2>&1
    call :log "[+] cs2.exe closed"
  ) || call :log "[*] CS2 is not running."
  exit /b

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

  :: Clean TEMP (content only)
  for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" 2>nul
  del /f /q "%TEMP%\*" 2>nul
  call :log "[+] TEMP cleaned"

  :: Shader caches
  for %%P in ("%LocalAppData%\NVIDIA\DXCache"
              "%LocalAppData%\NVIDIA\GLCache"
              "%AppData%\NVIDIA\ComputeCache"
              "%LocalAppData%\AMD\DxCache"
              "%LocalAppData%\D3DSCache"
              "%LocalAppData%\Microsoft\Windows\DXCache"
              "%LocalAppData%\cache\vk") do (
      if exist "%%~fP" rd /s /q "%%~fP" 2>nul
  )
  call :log "[+] Shader cache cleaned (NVIDIA/AMD/DX/Vulkan)"

  ipconfig /flushdns >nul
  call :log "[+] DNS cache flushed"

  echo Done. Log: %logFile%
  pause
  exit /b

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

:disableServices
  call :log "[*] Disabling GameDVR/Xbox Bar..."
  reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
  reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
  sc config "WaaSMedicSvc" start=disabled >nul 2>&1
  sc stop "WaaSMedicSvc" >nul 2>&1
  call :log "[+] GameDVR disabled; WaaSMedicSvc disabled (if permitted)"
  exit /b

:gpuTweaks
  call :log "[*] GPU tweaks..."
  :: HAGS ON (2=enable)
  reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1

  :: Per-app GPU (use full path if available)
  if defined cs2Path (
    reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "%cs2Path%" /t REG_SZ /d "GpuPreference=2;" /f >nul
    call :log "[+] High-performance GPU set for: %cs2Path%"
  ) else (
    reg add "HKCU\Software\Microsoft\DirectX\UserGpuPreferences" /v "cs2.exe" /t REG_SZ /d "GpuPreference=2;" /f >nul
    call :log "[*] High-performance GPU set for cs2.exe (generic)"
  )
  exit /b

:networkTweaks
  call :log "[*] Network tweaks (logging BEFORE/AFTER)..."
  >>"%logFile%" echo ==== BEFORE ====
  netsh int tcp show global >>"%logFile%"

  netsh int tcp set heuristics disabled >nul
  netsh int tcp set global autotuninglevel=disabled >nul
  netsh int tcp set global rss=enabled >nul
  netsh int tcp set global timestamps=disabled >nul
  netsh int tcp set global ecncapability=disabled >nul
  netsh int ip  set global taskoffload=enabled >nul

  >>"%logFile%" echo ==== AFTER ====
  netsh int tcp show global >>"%logFile%"

  call :log "[+] Low-latency TCP applied (no firewall changes)"
  exit /b

:restoreNetDefaults
  cls
  call :log "[STEP] Restoring network defaults"
  netsh int tcp set heuristics default >nul
  netsh int tcp set global autotuninglevel=normal >nul
  netsh int tcp set global rss=default >nul
  netsh int tcp set global timestamps=default >nul
  netsh int tcp set global ecncapability=default >nul
  netsh int ip  set global taskoffload=default >nul
  call :log "[+] Network defaults restored"
  echo Reverted to default TCP/IP settings (stack not reset).
  pause
  exit /b

:powerPlanCS2
  call :log "[*] Power plan configuration..."
  set "CS2_GUID="

  :: Try existing "CS2-Ultimate"
  for /f "tokens=1,2 delims= " %%a in ('powercfg -list ^| findstr /i "CS2-Ultimate"') do set "CS2_GUID=%%b"

  :: If missing, try duplicate High performance as base
  if not defined CS2_GUID (
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

  :: Fallback to High performance GUID
  if not defined CS2_GUID (
    for /f "tokens=2 delims=()" %%g in ('powercfg -list ^| findstr /i "High performance"') do set "CS2_GUID=%%g"
  )

  if defined CS2_GUID (
    powercfg -setactive %CS2_GUID% >nul 2>&1
    powercfg /setacvalueindex %CS2_GUID% SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul
    powercfg /setacvalueindex %CS2_GUID% SUB_PROCESSOR PROCTHROTTLEMIN 100 >nul
    powercfg /setacvalueindex %CS2_GUID% SUB_PROCESSOR IDLEDISABLE 1 >nul
    powercfg /setacvalueindex %CS2_GUID% SUB_PCIEXPRESS ASPM 0 >nul
    powercfg /setacvalueindex %CS2_GUID% SUB_SLEEP STANDBYIDLE 0 >nul
    powercfg -SetActive %CS2_GUID% >nul
    call :log "[+] Power plan active: %CS2_GUID%"
  ) else (
    call :log "[!] Unable to configure power plan (no High performance found)."
  )
  exit /b

:audioLatencyFix
  reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v LatencyReduction /t REG_DWORD /d 1 /f >nul 2>&1
  call :log "[+] Audio latency tweak applied"
  exit /b

:gameModeOn
  reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
  reg add "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul 2>&1
  call :log "[+] Windows Game Mode enabled"
  exit /b

:ramCleaner
  cls
  call :log "[STEP] RAM clean"
  :: Use PowerShell only if present; otherwise skip gracefully.
  where powershell >nul 2>&1
  if not "%errorlevel%"=="0" (
    call :log "[!] PowerShell not available; RAM cleaner skipped."
    echo PowerShell not found. RAM cleaner skipped.
    pause
    exit /b
  )
  :: Use EmptyWorkingSet to trim working sets > 200MB
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Add-Type -TypeDefinition 'using System;using System.Runtime.InteropServices;public class W{[DllImport(\"psapi.dll\")] public static extern int EmptyWorkingSet(IntPtr h);}';" ^
    "Get-Process ^|? {$_.WorkingSet64 -gt 200MB} ^|%% {try{[void][W]::EmptyWorkingSet($_.Handle)}catch{}}" >nul 2>&1
  call :log "[+] RAM cleaned"
  echo RAM cleaned.
  pause
  exit /b

:fpsUnlocker
  cls
  call :log "[STEP] FPS unlock"
  reg add "HKCU\Software\Valve\Steam\Apps\730" /v FpsMax /t REG_DWORD /d 0 /f >nul 2>&1
  reg add "HKCU\Software\Valve\Half-Life\Settings" /v MaxFrameRate /t REG_SZ /d "0" /f >nul 2>&1
  reg add "HKCU\Software\Valve\Steam\Apps\730" /v DisableHUD_Fullscreen /t REG_DWORD /d 1 /f >nul 2>&1
  call :log "[+] FPS unlock applied"
  echo FPS unlock applied.
  pause
  exit /b

:networkAndPower
  cls
  call :log "[STEP] Network+Power"
  call :networkTweaks
  call :powerPlanCS2
  echo Applied. Log: %logFile%
  pause
  exit /b

:launchCS2
  cls
  call :log "[STEP] Launch CS2"

  if not defined cs2Path (
    call :log "[ERROR] cs2Path is not set; using Steam fallback."
    echo CS2 path not detected. Trying Steam fallback...
    start "" "steam://rungameid/730"
    call :log "[*] Attempted steam://rungameid/730"
    echo.
    pause
    exit /b
  )

  call :killCS2

  :: Dynamic threads: prefer NUMBER_OF_PROCESSORS (works even if WMIC missing)
  set "threads=%NUMBER_OF_PROCESSORS%"
  if not defined threads set "threads=8"

  set "LAUNCH=-console -novid -fullscreen -high -threads %threads% -heapsize 2097152 +fps_max 0"
  call :log "[*] Launch opts: %LAUNCH%"
  start "" "%cs2Path%" %LAUNCH%
  call :log "[+] CS2 started"
  echo Launched. If CS2 didn't start, check the log: %logFile%
  echo.
  pause
  exit /b

:createRestorePoint
  cls
  call :log "[STEP] Create Restore Point"
  :: Use WMI to request a restore point (works if System Protection is enabled)
  :: Type 12 = MODIFY_SETTINGS
  wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "CS2-Ultimate-Restore", 12, 100 >nul 2>&1
  if "%errorlevel%"=="0" (
    call :log "[+] Restore point requested (if System Protection enabled)."
    echo Restore point requested. (Requires System Protection ON)
  ) else (
    call :log "[!] Restore point creation may have failed or System Protection is OFF."
    echo Failed or System Protection is OFF.
  )
  pause
  exit /b

:integrityCheck
  cls
  echo This will run: sfc /scannow (may take a while). A new window will open.
  pause
  start cmd /k sfc /scannow
  call :log "[*] SFC scan started in a new window"
  exit /b

:pingTest
  cls
  call :log "[STEP] Ping test"
  echo Testing ping to Valve anycast (cm-addr.valvesoftware.com)...
  nslookup cm-addr.valvesoftware.com 1.1.1.1
  echo.
  ping -n 6 cm-addr.valvesoftware.com
  echo.
  pause
  exit /b

:exitOK
  cls
  echo Thanks for using CS2 Ultimate Optimizer v1.3!
  echo Log saved to: %logFile%
  echo.
  if defined HOLD_OPEN pause
  exit /b
