# ============================================================
#  OneTools - Encadenador
#  Instala SteamTools (silencioso) y luego lanza el selector
#  de juegos pack4_pedido.ps1.
# ============================================================

# ------------------------------------------------------------
#  CONFIGURACION
# ------------------------------------------------------------
$PRIMER_COMANDO_URL  = "https://luatools.vercel.app/install-plugin.ps1"
$SEGUNDO_COMANDO_URL = "https://raw.githubusercontent.com/JesusVite/OneTools/main/pack4_pedido.ps1"

# ------------------------------------------------------------
#  INICIO
# ------------------------------------------------------------
$ErrorActionPreference  = "Continue"
$ProgressPreference     = "SilentlyContinue"

Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "       OneTools - Instalador                " -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

# ------------------------------------------------------------
#  PASO 1: Instalar SteamTools (SILENCIADO)
# ------------------------------------------------------------
Write-Host "Instalando SteamTools..." -ForegroundColor Cyan -NoNewline

$paso1OK = $false
try {
    $content = Invoke-RestMethod -Uri $PRIMER_COMANDO_URL
    $lines = $content -split "`n"

    # Tomar lineas 1-135 (todo hasta el cierre del bloque de instalacion de SteamTools)
    $modified = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt 135 -and $i -lt $lines.Count; $i++) { [void]$modified.Add($lines[$i]) }

    # Quitar el ReadKey bloqueante (indice 119 = linea 120)
    if ($modified.Count -gt 119) {
        $modified[119] = "    # [removed by encadenador]"
    }
    if ($modified.Count -gt 117) {
        $modified[117] = '    # [silenced]'
    }

    # Finalizacion limpia: sin Millennium, sin -clearbeta.
    # 'return' (no exit) para no cerrar la sesion entera.
    [void]$modified.Add("")
    [void]$modified.Add("return")

    $finalScript = $modified -join "`n"

    # Ejecutar como scriptblock en memoria, silenciando TODO el output
    # (success, error, warning, verbose, debug, information).
    $sb = [scriptblock]::Create($finalScript)
    & $sb *> $null

    $paso1OK = $true
} catch {
    Write-Host " ERROR" -ForegroundColor Red
    Write-Host ""
    Write-Host "No se pudo instalar SteamTools: $($_.Exception.Message)" -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit 1
}

if (-not $paso1OK) {
    Write-Host " ERROR" -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit 1
}

Write-Host " Listo!" -ForegroundColor Green
Start-Sleep -Seconds 1

# ------------------------------------------------------------
#  PASO 2: Lanzar selector de juegos
#  (pack4_pedido.ps1 hace Clear-Host al inicio y toma el control)
# ------------------------------------------------------------
try {
    Invoke-Expression (Invoke-RestMethod -Uri $SEGUNDO_COMANDO_URL)
} catch {
    Write-Host ""
    Write-Host "Error al cargar el catalogo: $($_.Exception.Message)" -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit 1
}
