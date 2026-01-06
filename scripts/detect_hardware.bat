@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==========================================
:: DETECT HARDWARE - FINAL ENGINE VERSION
:: Sets global vars:
::   GPU_VENDOR=NVIDIA | AMD | INTEL | UNKNOWN
::   CPU_CORES
::   RAM_MB
:: ==========================================

:: ---------- GPU DETECTION ----------
set "GPU_VENDOR=UNKNOWN"

for /f "delims=" %%G in ('wmic path win32_VideoController get name ^| findstr /i "NVIDIA"') do set "GPU_VENDOR=NVIDIA"
for /f "delims=" %%G in ('wmic path win32_VideoController get name ^| findstr /i "AMD Radeon"') do set "GPU_VENDOR=AMD"
for /f "delims=" %%G in ('wmic path win32_VideoController get name ^| findstr /i "Radeon"') do set "GPU_VENDOR=AMD"
for /f "delims=" %%G in ('wmic path win32_VideoController get name ^| findstr /i "Intel"') do (
  if "%GPU_VENDOR%"=="UNKNOWN" set "GPU_VENDOR=INTEL"
)

:: ---------- CPU CORES ----------
set "CPU_CORES=%NUMBER_OF_PROCESSORS%"
if not defined CPU_CORES set "CPU_CORES=4"

:: ---------- RAM DETECTION (MB) ----------
set "RAM_MB=0"
for /f "tokens=2 delims==" %%R in ('wmic computersystem get TotalPhysicalMemory /value') do (
  set /a RAM_MB=%%R/1024/1024
)

:: ---------- FALLBACKS ----------
if "%RAM_MB%"=="0" set "RAM_MB=8192"

:: ---------- EXPORT VARIABLES ----------
endlocal & (
  set "GPU_VENDOR=%GPU_VENDOR%"
  set "CPU_CORES=%CPU_CORES%"
  set "RAM_MB=%RAM_MB%"
)

exit /b
