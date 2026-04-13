@echo off
setlocal EnableExtensions

rem Deletes intermediate build output (CMake build/, .cache/). Keeps metamodule-plugins/.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0clean_metamodule.ps1"
if errorlevel 1 (
	echo [krono-mm-clean] Failed.
	pause
	exit /b 1
)

endlocal
exit /b 0
