@echo off
setlocal EnableDelayedExpansion
title CS2 Ultimate Optimizer

:: ======================================================
:: INIT
:: ======================================================
set BASEDIR=%~dp0
set LOGS=%BASEDIR%logs
if not exist "%LOGS%" mkdir "%LOGS%"

for /f "tokens=1-3 delims=/: " %%a in ("%date%") do (
    set DD=%%a
    set MM=%%b
    set YYYY=%%c
)
for /f "tokens=1-3 delims=:." %%a in ("%time%") do (
    set HH=%%a
    set MN=%%b
    set SS=%%c
)

set STAMP=%YYYY%%MM%%DD%_%HH%%MN%%SS%
set LOG=%LOGS%\run_%STAMP%.log

call :log "Optimizer started"

:: ======================================================
:: MENU
:: ======================================================
:menu
cls
echo ======================================
echo   CS2 ULTIMATE OPTIMIZER
echo ======================================
echo 1. Network tweaks
echo 2. CPU priority
echo 3. GPU optimizations
echo 4. Disable Xbox services
echo 5. Clear temp
echo 6. Full optimize
echo 7. Revert changes
echo S. System status
echo X. Exit
echo ======================================

choice /c 1234567SX /n /m "Choose option: "
set sel=%errorlevel%

if "%sel%"=="1" goto network
if "%sel%"=="2" goto cpu
if "%sel%"=="3" goto gpu
if "%sel%"=="4" goto xbox
if "%sel%"=="5" goto temp
if "%sel%"=="6" goto full
if "%sel%"=="7" goto revert
if "%sel%"=="8" goto status
if "%sel%"=="9" exit /b

goto menu

:: ======================================================
:: OPTIMIZATIONS
:: ======================================================
:network
call :log "Applying network tweaks"
ipconfig /flushdns >nul
netsh int tcp set global autotuninglevel=disabled >nul
pause
goto menu

:cpu
call :log "Setting CS2 CPU priority"
wmic process where name="cs2.exe" CALL setpriority "high priority" >nul 2>&1
pause
goto menu

:gpu
call :log "Applying GPU optimizations"
powercfg -setactive SCHEME_MIN >nul
pause
goto menu

:xbox
call :log "Disabling Xbox services"
sc stop XblGameSave >nul 2>&1
sc config XblGameSave start= disabled >nul 2>&1
pause
goto menu

:temp
call :log "Cleaning temp files"
del /s /q "%temp%\*" >nul 2>&1
pause
goto menu

:full
call :log "Running full optimization"
call :network
call :cpu
call :gpu
call :xbox
call :temp
pause
goto menu

:revert
call :log "Reverting system changes"
netsh int tcp set global autotuninglevel=normal >nul
sc config XblGameSave start= demand >nul 2>&1
pause
goto menu

:status
cls
echo ===== SYSTEM STATUS =====
powercfg /getactivescheme
netsh int tcp show global | find "Auto-Tuning"
pause
goto menu

:: ======================================================
:: FUNCTIONS (MUST BE AT END)
:: ======================================================
:log
echo [%time%] %~1
>>"%LOG%" echo [%time%] %~1
exit /b
