# ============================================================
#  OneTools - Instalador
# ============================================================

$INSTALLER_URL  = "https://raw.githubusercontent.com/JesusVite/OneTools/main/OneTools_Setup.exe"
$STEAMTOOLS_EXE = "C:\Program Files\SteamTools\SteamTools.exe"
$TEMP           = "$env:TEMP\onetools_setup"

Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "        OneTools - Instalador               " -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

New-Item -ItemType Directory -Path $TEMP -Force | Out-Null

Write-Host "Descargando instalador..." -ForegroundColor Cyan
$installer = "$TEMP\setup.exe"
(New-Object System.Net.WebClient).DownloadFile($INSTALLER_URL, $installer)

Write-Host "Instalando SteamTools..." -ForegroundColor Cyan
Start-Process -FilePath $installer -ArgumentList "/S" -Wait
Start-Sleep -Seconds 5

$intentos = 0
while (-not (Test-Path $STEAMTOOLS_EXE) -and $intentos -lt 10) {
    Start-Sleep -Seconds 2; $intentos++
}

Remove-Item $TEMP -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "   Instalacion completada con exito!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Yellow
Start-Sleep -Seconds 3
