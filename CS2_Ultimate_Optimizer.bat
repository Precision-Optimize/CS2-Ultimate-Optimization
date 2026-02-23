@echo off
title CS2 Optimizer v2.1 PRO
color 0A
setlocal EnableDelayedExpansion

:: =============================
:: AUTO ADMIN (STABLE)
:: =============================
>nul 2>&1 net session
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

:: =============================
:: LOG SETUP
:: =============================
set LOGDIR=%LOCALAPPDATA%\CS2Optimizer
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
set LOG=%LOGDIR%\optimizer.log

goto main

:: =============================
:: FUNCTIONS
:: =============================

:log
echo [%date% %time%] %~1 >> "%LOG%"
exit /b

:: ---------- CORE SAFE ----------
:network
call :log Network started
ipconfig /flushdns >nul
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global ecncapability=disabled >nul
exit /b

:gpu
call :log GPU started
powercfg -setactive SCHEME_MIN >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
exit /b

:xbox
call :log Xbox disabled
sc stop XblGameSave >nul 2>&1
sc config XblGameSave start= disabled >nul 2>&1
sc stop XboxGipSvc >nul 2>&1
sc config XboxGipSvc start= disabled >nul 2>&1
exit /b

:priority
call :log Priority attempt
powershell -Command "Get-Process cs2 -ErrorAction SilentlyContinue | %% { $_.PriorityClass='High' }" >nul 2>&1
exit /b

:: ---------- AGGRESSIVE ADDONS ----------
:timer
call :log Timer tweak
bcdedit /set useplatformtick yes >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
exit /b

:netboost
call :log Advanced network tweak
netsh int tcp set global rss=enabled >nul
netsh int tcp set global chimney=disabled >nul
netsh int tcp set global dca=enabled >nul
exit /b

:services
call :log Service trim
sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
exit /b

:mem
call :log Memory cleanup
del /s /q "%temp%\*" >nul 2>&1
exit /b

:nvidia
call :log NVIDIA tweak
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v EnableLowLatencyMode /t REG_DWORD /d 1 /f >nul 2>&1
exit /b

:: ---------- MODES ----------
:stable
echo Applying STABLE Gaming Mode...
call :network
call :gpu
call :xbox
call :priority
echo Stable mode complete.
exit /b

:aggressive
echo Applying AGGRESSIVE FPS Mode...
call :network
call :gpu
call :xbox
call :priority
call :timer
call :netboost
call :services
call :mem
call :nvidia
echo Aggressive mode complete.
echo Restart recommended.
exit /b

:revert
echo Reverting all changes...
call :log Revert started
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global ecncapability=default >nul
sc config XblGameSave start= demand >nul 2>&1
sc config XboxGipSvc start= demand >nul 2>&1
sc config SysMain start= auto >nul 2>&1
sc config DiagTrack start= auto >nul 2>&1
bcdedit /deletevalue useplatformtick >nul 2>&1
bcdedit /deletevalue disabledynamictick >nul 2>&1
echo Revert complete.
exit /b

:: =============================
:: MENU
:: =============================
:main
cls
echo ======================================
echo         CS2 Optimizer v2.1 PRO
echo ======================================
echo 1. Stable Gaming Mode  (Safe)
echo 2. Aggressive FPS Mode (Max Performance)
echo 3. Revert Everything
echo X. Exit
echo ======================================
echo.

set /p choice=Select option: 

if /i "%choice%"=="1" call :stable
if /i "%choice%"=="2" call :aggressive
if /i "%choice%"=="3" call :revert
if /i "%choice%"=="X" exit

echo.
echo Press any key to return to menu...
pause >nul
goto main