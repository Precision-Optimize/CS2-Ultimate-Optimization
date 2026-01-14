@echo off
setlocal EnableExtensions EnableDelayedExpansion
title CS2 Ultimate Optimizer
color 0A
mode con cols=100 lines=30

:: ======================================================
:: BASE PATHS
:: ======================================================
set "BASE=%~dp0"
set "SCRIPTS=%BASE%scripts"
set "LOGS=%BASE%logs"
set "CONFIG=%BASE%config.txt"

if not exist "%LOGS%" mkdir "%LOGS%"

:: ======================================================
:: TIMESTAMP
:: ======================================================
for /f "tokens=2 delims==" %%A in ('wmic os get LocalDateTime /value 2^>nul') do set "ldt=%%A"
set "STAMP=%ldt:~0,8%_%ldt:~8,6%"

:: ======================================================
:: LOGGING
:: ======================================================
set "LOG=%LOGS%\run_%STAMP%.log"
:log
echo [%time%] %~1
>>"%LOG%" echo [%time%] %~1
exit /b

:: ======================================================
:: ADMIN CHECK
:: ======================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo [!] Please run this program as Administrator.
  pause
  exit /b
)

:: ======================================================
:: LOAD CONFIG
:: ======================================================
if exist "%CONFIG%" (
  for /f "tokens=1,* delims==" %%A in ("%CONFIG%") do (
    if /i "%%A"=="cs2Path" set "cs2Path=%%B"
  )
)

:: ======================================================
:: HARDWARE DETECTION (ENGINE)
:: ======================================================
if exist "%SCRIPTS%\detect_hardware.bat" (
  call "%SCRIPTS%\detect_hardware.bat"
  call :log "Hardware detected: GPU=%GPU_VENDOR% CPU=%CPU_CORES% RAM=%RAM_MB%MB"
) else (
  set "GPU_VENDOR=UNKNOWN"
)

:: ======================================================
:: MAIN MENU
:: ======================================================
:menu
cls
echo =========================================================
echo            CS2 ULTIMATE OPTIMIZER (ENGINE EDITION)
echo =========================================================
echo CS2 Ultimate Optimizer v2.0.1
echo GPU: %GPU_VENDOR%  ^|  CPU Cores: %CPU_CORES%  ^|  RAM: %RAM_MB% MB
if defined cs2Path (
  echo CS2 Path: %cs2Path%
) else (
  echo CS2 Path: NOT SET
)
echo ---------------------------------------------------------
echo 1. Set / Change CS2 Path
echo 2. SAFE Optimize
echo 3. PERFORMANCE Optimize
echo 4. BENCHMARK Optimize
echo 5. Run FPS Benchmark
echo 6. Launch CS2 (Optimized)
echo 7. Revert ALL Tweaks
echo S. System Status
echo X. Exit
echo ---------------------------------------------------------
choice /c 1234567X /n /m "Choose option: "
set "sel=%errorlevel%"

if "%sel%"=="1" goto setCS2
if "%sel%"=="2" goto optSafe
if "%sel%"=="3" goto optPerf
if "%sel%"=="4" goto optBench
if "%sel%"=="5" goto fpsBench
if "%sel%"=="6" goto launch
if "%sel%"=="7" goto revert
if "%sel%"=="8" exit /b
goto menu

:: ======================================================
:: SET CS2 PATH
:: ======================================================
:setCS2
cls
set /p "cs2Path=Enter FULL path to cs2.exe: "
if exist "%cs2Path%" (
  echo cs2Path=%cs2Path%>"%CONFIG%"
  call :log "CS2 path set"
  echo Path saved.
) else (
  echo Invalid path.
)
pause
goto menu

:: ======================================================
:: SAFE MODE
:: ======================================================
:optSafe
cls
call :log "Applying SAFE mode"
call "%SCRIPTS%\windows_fps_latency_optimizer.bat"
call "%SCRIPTS%\timer_resolution_launcher.bat"
echo SAFE optimization applied.
pause
goto menu

:: ======================================================
:: PERFORMANCE MODE
:: ======================================================
:optPerf
cls
call :log "Applying PERFORMANCE mode"
call "%SCRIPTS%\windows_fps_latency_optimizer.bat"

if /i "%GPU_VENDOR%"=="NVIDIA" call "%SCRIPTS%\nvidia_optimizer.bat"
if /i "%GPU_VENDOR%"=="AMD"    call "%SCRIPTS%\amd_optimizer.bat"

call "%SCRIPTS%\timer_resolution_launcher.bat"
echo PERFORMANCE optimization applied.
pause
goto menu

:: ======================================================
:: BENCHMARK MODE
:: ======================================================
:optBench
cls
call :log "Applying BENCHMARK mode"
call "%SCRIPTS%\windows_fps_latency_optimizer.bat"

if /i "%GPU_VENDOR%"=="NVIDIA" call "%SCRIPTS%\nvidia_optimizer.bat"
if /i "%GPU_VENDOR%"=="AMD"    call "%SCRIPTS%\amd_optimizer.bat"

call "%SCRIPTS%\timer_resolution_launcher.bat"
echo BENCHMARK optimization applied.
echo Revert recommended after benchmark.
pause
goto menu

:: ======================================================
:: FPS BENCHMARK (HOOK)
:: ======================================================
:fpsBench
cls
if not defined cs2Path (
  echo CS2 path not set.
  pause
  goto menu
)

call :log "Starting FPS benchmark"

:: Clean old console log
if exist "%BASE%console.log" del "%BASE%console.log" >nul 2>&1

:: Start timer resolution
call "%SCRIPTS%\timer_resolution_launcher.bat"

:: Launch CS2 in benchmark mode
start "" "%cs2Path%" -novid -fullscreen -high -condebug -benchmark +fps_max 0

echo.
echo ==========================================
echo CS2 FPS BENCHMARK
echo ------------------------------------------
echo REQUIREMENTS:
echo - Developer Console MUST be ENABLED in CS2
echo   (Settings ^> Game ^> Enable Developer Console)
echo.
echo HOW TO RUN:
echo 1. Join any match or offline game
echo 2. Play for at least 30–60 seconds
echo 3. CLOSE CS2 when finished
echo.
echo No console commands are required.
echo ==========================================
echo.


:: Parse FPS after CS2 closes
if exist "%SCRIPTS%\fps_parser.bat" (
  call "%SCRIPTS%\fps_parser.bat"

  echo.
  echo ===============================
  echo FPS BENCHMARK RESULT
  echo ===============================
  echo AVG FPS: %FPS_AVG%
  echo MIN FPS: %FPS_MIN%
  echo ===============================

  call :log "Benchmark result: AVG=%FPS_AVG% MIN=%FPS_MIN%"
) else (
  echo FPS parser not found!
  call :log "ERROR: fps_parser.bat missing"
)

pause
goto menu


:: ======================================================
:: LAUNCH CS2
:: ======================================================
:launch
cls
if not defined cs2Path (
  echo CS2 path not set.
  pause
  goto menu
)

call "%SCRIPTS%\timer_resolution_launcher.bat"
call :log "Launching CS2"
start "" "%cs2Path%" -novid -fullscreen -high +fps_max 0
exit /b

:: ======================================================
:: STATUS
:: ======================================================
:status
cls
echo ===============================
echo SYSTEM STATUS
echo ===============================
echo GPU: %GPU_VENDOR%
echo CPU Cores: %CPU_CORES%
echo RAM: %RAM_MB% MB
if defined cs2Path (
  echo CS2 Path: %cs2Path%
) else (
  echo CS2 Path: NOT SET
)
if exist "%LOGS%\fps_benchmark_result.txt" (
  echo Last Benchmark:
  type "%LOGS%\fps_benchmark_result.txt"
)
pause
goto menu
:: ======================================================
:: REVERT
:: ======================================================
:revert
cls
call :log "Reverting all optimizations"
call "%SCRIPTS%\revert_optimizer.bat"
echo System reverted to defaults.
pause
goto menu
