@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: ==========================================
:: CS2 FPS PARSER
:: Parses console.log and outputs AVG / MIN FPS
:: Silent engine script
:: ==========================================

:: --- Paths ---
set "BASE=%~dp0"
set "ROOT=%BASE%.."
set "LOGS=%ROOT%\logs"
set "CSLOG=%ROOT%\console.log"

if not exist "%LOGS%" mkdir "%LOGS%" >nul 2>&1

:: --- Check if console.log exists ---
if not exist "%CSLOG%" (
  echo No console.log found. > "%LOGS%\fps_parser_error.log"
  exit /b
)

:: --- Init counters ---
set /a FPS_SUM=0
set /a FPS_COUNT=0
set /a FPS_MIN=9999

:: --- Parse FPS lines ---
:: CS2 console.log contains lines like: "fps : 237"
for /f "tokens=2 delims=:" %%F in ('findstr /i "fps" "%CSLOG%"') do (
  set "VAL=%%F"
  set "VAL=!VAL: =!"
  set "VAL=!VAL:.=!"
  if "!VAL!" NEQ "" (
    if "!VAL!" GTR "0" (
      set /a FPS_SUM+=VAL
      set /a FPS_COUNT+=1
      if !VAL! LSS !FPS_MIN! set /a FPS_MIN=VAL
    )
  )
)

:: --- Calculate AVG ---
if %FPS_COUNT% GTR 0 (
  set /a FPS_AVG=FPS_SUM / FPS_COUNT
) else (
  set FPS_AVG=0
  set FPS_MIN=0
)

:: --- Save results ---
set "OUT=%LOGS%\fps_benchmark_result.txt"

(
  echo ===============================
  echo CS2 FPS BENCHMARK RESULT
  echo ===============================
  echo Samples: %FPS_COUNT%
  echo AVG FPS: %FPS_AVG%
  echo MIN FPS: %FPS_MIN%
  echo Timestamp: %date% %time%
  echo ===============================
)>>"%OUT%"

:: --- Export variables for frontend ---
endlocal & (
  set "FPS_AVG=%FPS_AVG%"
  set "FPS_MIN=%FPS_MIN%"
)

exit /b
