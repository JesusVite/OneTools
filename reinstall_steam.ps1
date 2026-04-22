# ============================================================
#  OneTools - Reinstalar Steam + Eliminar Millennium
# ============================================================

$STEAM_DIR           = "C:\Program Files (x86)\Steam"
$STEAM_UNINST        = "$STEAM_DIR\uninstall.exe"
$STEAM_INSTALLER_URL = "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe"
$TEMP                = "$env:TEMP\onetools_steam"

Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "   OneTools - Reinstalar Steam              " -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

New-Item -ItemType Directory -Path $TEMP -Force | Out-Null

# PASO 1: Cerrar Steam
Write-Host "[1/4] Cerrando Steam..." -ForegroundColor Cyan
Get-Process -Name "steam" -ErrorAction SilentlyContinue | Stop-Process -Force
Stop-Service -Name "SteamService" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
Write-Host "      Listo!" -ForegroundColor Green

# PASO 2: Eliminar Millennium
Write-Host ""
Write-Host "[2/4] Eliminando Millennium..." -ForegroundColor Cyan

$eliminados = 0
Get-ChildItem -Path $STEAM_DIR -Filter "*millennium*" -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notlike "*steamapps*" } |
    ForEach-Object {
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "      Eliminado: $($_.Name)" -ForegroundColor White
        $eliminados++
    }

if ($eliminados -eq 0) {
    Write-Host "      Millennium no encontrado o ya eliminado." -ForegroundColor Yellow
} else {
    Write-Host "      Millennium eliminado! ($eliminados archivos)" -ForegroundColor Green
}

# PASO 3: Desinstalar Steam (sin tocar steamapps ni userdata)
Write-Host ""
Write-Host "[3/4] Desinstalando Steam..." -ForegroundColor Cyan

if (Test-Path $STEAM_UNINST) {
    Start-Process -FilePath $STEAM_UNINST -ArgumentList "/S" -Wait
    Start-Sleep -Seconds 5
    Write-Host "      Steam desinstalado!" -ForegroundColor Green
} else {
    Write-Host "      Limpiando archivos de Steam manualmente..." -ForegroundColor Yellow
    Get-ChildItem -Path $STEAM_DIR -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notin @("steamapps", "userdata") } |
        ForEach-Object {
            Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
    Write-Host "      Listo!" -ForegroundColor Green
}

# PASO 4: Descargar e instalar Steam limpio
Write-Host ""
Write-Host "[4/4] Descargando Steam..." -ForegroundColor Cyan
$steamInstaller = "$TEMP\SteamSetup.exe"
(New-Object System.Net.WebClient).DownloadFile($STEAM_INSTALLER_URL, $steamInstaller)
Write-Host "      Instalando Steam..." -ForegroundColor Cyan
Start-Process -FilePath $steamInstaller -Wait
Start-Sleep -Seconds 3

Remove-Item $TEMP -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "   Steam reinstalado sin Millennium!" -ForegroundColor Green
Write-Host "   Tus juegos siguen intactos." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Yellow
Start-Sleep -Seconds 3
