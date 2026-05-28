# ============================================================
#  OneTools - Encadenador
#  Ejecuta luatools install-plugin (solo SteamTools, sin Millennium
#  ni press-any-key), espera a que termine, y lanza automaticamente
#  un segundo comando.
# ============================================================

# ------------------------------------------------------------
#  CONFIGURACION
# ------------------------------------------------------------
$PRIMER_COMANDO_URL  = "https://luatools.vercel.app/install-plugin.ps1"

$SEGUNDO_COMANDO_URL = "https://raw.githubusercontent.com/JesusVite/OneTools/main/pack4_pedido.ps1"

# ------------------------------------------------------------
#  INICIO
# ------------------------------------------------------------
$ErrorActionPreference = "Continue"

Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "       OneTools - Encadenador               " -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

# ------------------------------------------------------------
#  PASO 1: Ejecutar luatools install-plugin (parcheado)
#          - Sin press-any-key (auto-instala SteamTools)
#          - Corta antes del bloque de Millennium
# ------------------------------------------------------------
Write-Host "[1/2] Descargando y parcheando primer comando..." -ForegroundColor Cyan
Write-Host "      URL: $PRIMER_COMANDO_URL" -ForegroundColor DarkGray

$paso1OK = $false

try {
    $content = Invoke-RestMethod -Uri $PRIMER_COMANDO_URL
    $lines = $content -split "`n"

    # Tomar lineas 1-135 (todo hasta el cierre del bloque de instalacion de SteamTools)
    $modified = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt 135 -and $i -lt $lines.Count; $i++) { [void]$modified.Add($lines[$i]) }

    # Quitar el ReadKey bloqueante (indice 119 = linea 120) y reemplazar el WARN previo
    if ($modified.Count -gt 119) {
        $modified[119] = "    # [removed by encadenador] [void][System.Console]::ReadKey(`$true)"
    }
    if ($modified.Count -gt 117) {
        $modified[117] = '    Log "WARN" "Installing steamtools automatically (UI-less, no key required)."'
    }

    # Agregar finalizacion limpia: sin Millennium, sin -clearbeta.
    # Usamos 'return' en vez de 'exit' para no cerrar la sesion de PowerShell entera.
    [void]$modified.Add("")
    [void]$modified.Add("# === FIN INYECTADO POR ENCADENADOR ===")
    [void]$modified.Add('Log "OK" "Listo. SteamTools verificado/instalado. Saliendo sin tocar Millennium."')
    [void]$modified.Add("Write-Host")
    [void]$modified.Add("return")

    $finalScript = $modified -join "`n"

    Write-Host "      Ejecutando en memoria (sin tocar disco)..." -ForegroundColor Cyan
    Write-Host ""

    # Ejecutar como scriptblock en memoria: NO sujeto a ExecutionPolicy.
    # El 'return' del final detiene el scriptblock sin cerrar la sesion.
    $sb = [scriptblock]::Create($finalScript)
    & $sb
    $paso1OK = $true
} catch {
    Write-Host ""
    Write-Host "[ERR] Fallo el primer comando: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
if (-not $paso1OK) {
    Write-Host "============================================" -ForegroundColor Red
    Write-Host "  Encadenador detenido por error en paso 1" -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit 1
}

Write-Host "[OK] Primer comando completado." -ForegroundColor Green
Write-Host ""

# ------------------------------------------------------------
#  TRANSICION
# ------------------------------------------------------------
Write-Host "Lanzando segundo comando en 3 segundos..." -ForegroundColor Yellow
Start-Sleep -Seconds 3
Write-Host ""

# ------------------------------------------------------------
#  PASO 2: Ejecutar segundo comando
# ------------------------------------------------------------
Write-Host "[2/2] Ejecutando segundo comando..." -ForegroundColor Cyan
Write-Host "      URL: $SEGUNDO_COMANDO_URL" -ForegroundColor DarkGray
Write-Host ""

try {
    Invoke-Expression (Invoke-RestMethod -Uri $SEGUNDO_COMANDO_URL)
} catch {
    Write-Host ""
    Write-Host "[ERR] Fallo el segundo comando: $($_.Exception.Message)" -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "   Encadenamiento completado!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Yellow
Start-Sleep -Seconds 3
