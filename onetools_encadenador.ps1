# ============================================================
#  OneTools - Encadenador
#  1. Pide codigo de orden y lo valida contra Supabase (device lock).
#  2. Instala OneTools (silencioso).
#  3. Lanza selector de juegos pack4_pedido.ps1.
# ============================================================

# ------------------------------------------------------------
#  CONFIGURACION
# ------------------------------------------------------------
$PRIMER_COMANDO_URL  = "https://luatools.vercel.app/install-plugin.ps1"
$SEGUNDO_COMANDO_URL = "https://raw.githubusercontent.com/JesusVite/OneTools/main/pack4_pedido.ps1"

$SUPABASE_URL  = "https://phvbomzwynbmahxeatab.supabase.co"
$SUPABASE_KEY  = "sb_publishable_FhIq7tTb_ieoQudbsPyzcg_PCrYK7gv"
$MAX_INTENTOS  = 3

# ------------------------------------------------------------
#  INICIO
# ------------------------------------------------------------
$ErrorActionPreference  = "Continue"
$ProgressPreference     = "SilentlyContinue"

# ---------- Helpers ----------

# Fetch sin cache (cache-bust + headers no-cache).
function Get-FreshScript {
    param([string]$Url)
    $bust = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    $sep = if ($Url -match '\?') { '&' } else { '?' }
    $finalUrl = "$Url${sep}cb=$bust"
    $headers = @{
        'Cache-Control' = 'no-cache, no-store, must-revalidate'
        'Pragma'        = 'no-cache'
    }
    return (Invoke-RestMethod -Uri $finalUrl -Headers $headers)
}

# Hash SHA-256 del hardware (CPU + motherboard + disco).
# Es estable entre reinicios pero cambia si reemplazas componentes.
function Get-DeviceId {
    try {
        $cpu  = (Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1).ProcessorId
        $mb   = (Get-CimInstance Win32_BaseBoard -ErrorAction SilentlyContinue).SerialNumber
        $disk = (Get-CimInstance Win32_DiskDrive -ErrorAction SilentlyContinue | Select-Object -First 1).SerialNumber
        $raw  = "$cpu|$mb|$disk"
        if ([string]::IsNullOrWhiteSpace($raw) -or $raw -eq "||") {
            # Fallback: usar nombre de maquina + usuario
            $raw = "$env:COMPUTERNAME|$env:USERNAME"
        }
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($raw)
        $hash  = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
        return ([System.BitConverter]::ToString($hash) -replace '-', '').ToLower()
    } catch {
        # Ultimo recurso
        $raw = "$env:COMPUTERNAME|$env:USERNAME|$env:PROCESSOR_IDENTIFIER"
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($raw)
        $hash  = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
        return ([System.BitConverter]::ToString($hash) -replace '-', '').ToLower()
    }
}

# Llama a la funcion usar_codigo en Supabase.
# Devuelve un PSCustomObject con .status y .mensaje, o $null si hubo error de red.
function Test-Codigo {
    param([string]$Codigo, [string]$DeviceId)
    $headers = @{
        'apikey'        = $SUPABASE_KEY
        'Authorization' = "Bearer $SUPABASE_KEY"
        'Content-Type'  = 'application/json'
    }
    $body = @{ p_codigo = $Codigo; p_device_id = $DeviceId } | ConvertTo-Json
    try {
        return (Invoke-RestMethod -Method POST `
            -Uri "$SUPABASE_URL/rest/v1/rpc/usar_codigo" `
            -Headers $headers -Body $body -TimeoutSec 20)
    } catch {
        return $null
    }
}

# ------------------------------------------------------------
#  BANNER + VALIDACION DEL CODIGO
# ------------------------------------------------------------
# Forzar el titulo de la ventana a "OneTools" desde el inicio.
# Los scripts externos (luatools install-plugin, manifests) lo cambian
# a "Luatools plugin installer" / "Steam Manifest Downloader" y eso
# se ve aunque silenciemos su output con *> $null.
$tituloOriginal = $Host.UI.RawUI.WindowTitle
$Host.UI.RawUI.WindowTitle = "OneTools"

Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "       OneTools - Instalador                " -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

$deviceId    = Get-DeviceId
$autorizado  = $false
$codigoUsado = $null

for ($i = 1; $i -le $MAX_INTENTOS; $i++) {
    $codigo = (Read-Host "Ingresa tu codigo de orden").Trim().ToUpper()
    if ([string]::IsNullOrWhiteSpace($codigo)) {
        Write-Host "  Codigo vacio. Intenta de nuevo." -ForegroundColor Red
        continue
    }

    Write-Host "  Verificando..." -ForegroundColor DarkGray -NoNewline
    $res = Test-Codigo -Codigo $codigo -DeviceId $deviceId
    Write-Host ""

    if ($null -eq $res) {
        Write-Host "  Error de conexion. Verifica tu internet e intenta de nuevo." -ForegroundColor Red
        continue
    }

    switch ($res.status) {
        'activado' {
            Write-Host "  $($res.mensaje)" -ForegroundColor Green
            $autorizado  = $true
            $codigoUsado = $codigo
        }
        'ok' {
            Write-Host "  $($res.mensaje)" -ForegroundColor Green
            $autorizado  = $true
            $codigoUsado = $codigo
        }
        'invalido' {
            Write-Host "  $($res.mensaje) Intento $i de $MAX_INTENTOS." -ForegroundColor Red
        }
        'bloqueado' {
            Write-Host ""
            Write-Host "============================================" -ForegroundColor Red
            Write-Host "  $($res.mensaje)" -ForegroundColor Red
            Write-Host "  Contacta al soporte para reactivar." -ForegroundColor Red
            Write-Host "============================================" -ForegroundColor Red
            $env:ONETOOLS_SESSION = $null
            Start-Sleep -Seconds 5
            exit 1
        }
        default {
            Write-Host "  Respuesta inesperada: $($res | ConvertTo-Json -Compress)" -ForegroundColor Red
        }
    }

    if ($autorizado) { break }
}

if (-not $autorizado) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Red
    Write-Host "  Maximo de intentos alcanzado. Adios." -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor Red
    $env:ONETOOLS_SESSION = $null
    Start-Sleep -Seconds 5
    exit 1
}

# Exportar sesion para que pack4_pedido.ps1 la reuse sin pedir codigo otra vez.
# Formato: "<codigo>|<device_id>". pack4_pedido valida que el device coincida
# y revalida el codigo contra Supabase (defensa en profundidad).
$env:ONETOOLS_SESSION = "$codigoUsado|$deviceId"

Start-Sleep -Seconds 1
Write-Host ""

# ------------------------------------------------------------
#  PASO 1: Instalar OneTools (SILENCIADO)
# ------------------------------------------------------------
Write-Host "Instalando OneTools..." -ForegroundColor Cyan -NoNewline

$paso1OK = $false
try {
    $content = Get-FreshScript -Url $PRIMER_COMANDO_URL
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

    # Re-branding: reemplazar cualquier WindowTitle por "OneTools" para que
    # el cliente no vea menciones a la competencia en la barra de la ventana.
    for ($j = 0; $j -lt $modified.Count; $j++) {
        if ($modified[$j] -match '\$Host\.UI\.RawUI\.WindowTitle') {
            $modified[$j] = '$Host.UI.RawUI.WindowTitle = "OneTools"'
        }
    }

    # Finalizacion limpia: sin Millennium, sin -clearbeta.
    [void]$modified.Add("")
    [void]$modified.Add('$Host.UI.RawUI.WindowTitle = "OneTools"')
    [void]$modified.Add("return")

    $finalScript = $modified -join "`n"

    # Ejecutar como scriptblock en memoria (sin tocar disco, sin ExecutionPolicy).
    $sb = [scriptblock]::Create($finalScript)
    & $sb *> $null

    # Re-forzar el titulo por si algun strand del script lo cambio antes del re-brand inyectado.
    $Host.UI.RawUI.WindowTitle = "OneTools"

    $paso1OK = $true
} catch {
    Write-Host " ERROR" -ForegroundColor Red
    Write-Host ""
    Write-Host "No se pudo instalar OneTools: $($_.Exception.Message)" -ForegroundColor Red
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
    Invoke-Expression (Get-FreshScript -Url $SEGUNDO_COMANDO_URL)
} catch {
    Write-Host ""
    Write-Host "Error al cargar el catalogo: $($_.Exception.Message)" -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit 1
}
