@echo off

:: ====================================================
::               BLOQUE DE CONFIGURACION
:: ====================================================
:: Nombre de la etiqueta de volumen de tu NyxUSB
set "NOMBRE_USB=Nyx"

:: Parametro silencioso universal (Por defecto /S sirve para la mayoria)
:: Si el instalador requiere otro (ej. /VERYSILENT o /quiet), se cambia aqui:
set "PARAM_SILENCIOSO=/S"
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

:: Definir las rutas de origen basadas en la ubicacion dinamica de la USB
set "DESTINO=%DRIVE%:\"
set "CARPETA_PROGS=%DESTINO%programas"


:: ====================================================
::        DETECCION E INSTALACION DINAMICA
:: ====================================================

if exist "%CARPETA_PROGS%" (
    
    :: El bucle busca el primer archivo .exe dentro de la carpeta y lo ejecuta
    for %%F in ("%CARPETA_PROGS%\*.exe") do (
        start /wait "" "%%F" %PARAM_SILENCIOSO%
        
        :: Rompe el bucle inmediatamente para que solo instale un programa
        goto :final
    )

)

:final
exit