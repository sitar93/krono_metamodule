@echo off
setlocal EnableExtensions

rem Build plugin MetaModule (CMake + toolchain ARM), non il make VCV Rack.
rem Per il plugin Rack usa: ..\BUILD_AND_RUN_KRONO.cmd oppure scripts\build_windows.ps1 dalla root del repo.

set "MSYS_ROOT=C:\msys64"

rem Opzionale: cartella ...\bin della toolchain (se non è sul PATH e non viene trovata sotto Program Files)
rem set "TOOLCHAIN_BASE_DIR=D:\Arm\arm-gnu-toolchain-12.3.rel1-mingw-w64-i686-arm-none-eabi\bin"
rem Build pulita da zero (lenta): decommenta la riga seguente prima di avviare
rem set "KRONO_MM_BUILD_ARGS=fresh"

if not exist "%~dp0run_metamodule_cmake.ps1" (
  echo [krono-mm] File mancante: %~dp0run_metamodule_cmake.ps1
  pause
  exit /b 1
)

echo [krono-mm] Avvio CMake...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0run_metamodule_cmake.ps1" -MsysRoot "%MSYS_ROOT%"
if errorlevel 1 (
  echo [krono-mm] Build fallita.
  pause
  exit /b 1
)

echo [krono-mm] OK.
endlocal
exit /b 0
