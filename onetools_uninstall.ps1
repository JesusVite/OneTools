# ============================================================
#  OneTools - Desinstalador completo
# ============================================================

$DESTINO        = "${env:ProgramFiles(x86)}\Steam\config\stplug-in"
$STEAMTOOLS_DIR = "C:\Program Files\SteamTools"
$STEAMTOOLS_EXE = "$STEAMTOOLS_DIR\SteamTools.exe"
$STEAM_EXE      = "${env:ProgramFiles(x86)}\Steam\steam.exe"
$TEMP           = "$env:TEMP\onetools_pack4"
$TEMP2          = "$env:TEMP\onetools_pedido"

Clear-Host
Write-Host "============================================" -ForegroundColor Red
Write-Host "      OneTools - Desinstalador              " -ForegroundColor Red
Write-Host "============================================" -ForegroundColor Red
Write-Host ""

# ============================================================
# PASO 1: Cerrar Steam y SteamTools
# ============================================================
Write-Host "[1/4] Cerrando Steam y SteamTools..." -ForegroundColor Cyan

Get-Process -Name "SteamTools" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name "steam" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 3
Write-Host "      Listo!" -ForegroundColor Green

# ============================================================
# PASO 2: Eliminar archivos .lua y .manifest de stplug-in
# ============================================================
Write-Host ""
Write-Host "[2/4] Eliminando archivos de juegos en stplug-in..." -ForegroundColor Cyan

if (Test-Path $DESTINO) {
    $archivos = Get-ChildItem -Path $DESTINO -Include "*.lua","*.manifest" -Recurse
    $total = $archivos.Count
    $contador = 0
    foreach ($archivo in $archivos) {
        $contador++
        Write-Host "`r      [$contador/$total] $($archivo.Name)   " -NoNewline -ForegroundColor White
        Remove-Item $archivo.FullName -Force -ErrorAction SilentlyContinue
    }
    Write-Host ""
    Write-Host "      $total archivos eliminados!" -ForegroundColor Green
} else {
    Write-Host "      Carpeta stplug-in no encontrada, omitiendo." -ForegroundColor Yellow
}

# ============================================================
# PASO 3: Desinstalar SteamTools
# ============================================================
Write-Host ""
Write-Host "[3/4] Desinstalando SteamTools..." -ForegroundColor Cyan

$uninstaller = "$STEAMTOOLS_DIR\Uninstall.exe"
if (Test-Path $uninstaller) {
    Start-Process -FilePath $uninstaller -ArgumentList "/S" -Wait
    Write-Host "      SteamTools desinstalado!" -ForegroundColor Green
} elseif (Test-Path $STEAMTOOLS_DIR) {
    Remove-Item $STEAMTOOLS_DIR -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "      Carpeta SteamTools eliminada!" -ForegroundColor Green
} else {
    Write-Host "      SteamTools no encontrado, omitiendo." -ForegroundColor Yellow
}

# ============================================================
# PASO 4: Limpiar temporales
# ============================================================
Write-Host ""
Write-Host "[4/4] Limpiando archivos temporales..." -ForegroundColor Cyan

Remove-Item $TEMP  -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $TEMP2 -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "      Listo!" -ForegroundColor Green

# ============================================================
# FIN
# ============================================================
Write-Host ""
Write-Host "============================================" -ForegroundColor Red
Write-Host "   Desinstalacion completada!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Red
Start-Sleep -Seconds 3
