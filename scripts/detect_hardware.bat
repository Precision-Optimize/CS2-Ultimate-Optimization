@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ---- CPU ----
for /f "skip=1 delims=" %%A in ('wmic cpu get Name ^| findstr /r /v "^$"') do (
  set "CPU_NAME=%%A"
  goto :cpu_done
)
:cpu_done

for /f "skip=1 delims=" %%A in ('wmic cpu get NumberOfCores ^| findstr /r /v "^$"') do (
  set "CPU_CORES=%%A"
  goto :cores_done
)
:cores_done

for /f "skip=1 delims=" %%A in ('wmic cpu get NumberOfLogicalProcessors ^| findstr /r /v "^$"') do (
  set "CPU_THREADS=%%A"
  goto :threads_done
)
:threads_done

:: ---- GPU (first adapter) ----
for /f "skip=1 delims=" %%A in ('wmic path win32_VideoController get Name ^| findstr /r /v "^$"') do (
  set "GPU_NAME=%%A"
  goto :gpu_done
)
:gpu_done

set "GPU_VENDOR=OTHER"
echo !GPU_NAME! | find /I "NVIDIA" >nul && set "GPU_VENDOR=NVIDIA"
echo !GPU_NAME! | find /I "AMD" >nul && set "GPU_VENDOR=AMD"
echo !GPU_NAME! | find /I "Radeon" >nul && set "GPU_VENDOR=AMD"
echo !GPU_NAME! | find /I "Intel" >nul && set "GPU_VENDOR=INTEL"

:: ---- RAM (GB) ----
for /f "skip=1 delims=" %%A in ('wmic computersystem get TotalPhysicalMemory ^| findstr /r /v "^$"') do (
  set "RAM_BYTES=%%A"
  goto :ram_done
)
:ram_done

:: Convert RAM to approx GB (integer)
set /a RAM_GB=!RAM_BYTES!/1024/1024/1024

:: ---- Export to environment for caller ----
endlocal & (
  set "CPU_NAME=%CPU_NAME%"
  set "CPU_CORES=%CPU_CORES%"
  set "CPU_THREADS=%CPU_THREADS%"
  set "GPU_NAME=%GPU_NAME%"
  set "GPU_VENDOR=%GPU_VENDOR%"
  set "RAM_GB=%RAM_GB%"
)
exit /b 0
