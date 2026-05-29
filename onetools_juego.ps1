# ============================================================
#  OneTools - Entrega de juego individual (1 codigo = 1 juego)
#  Modo segun $env:ONETOOLS_MODO: "install" (1 uso) o "reinstall".
#  El juego lo define el codigo en Supabase (el cliente no elige).
# ============================================================

$DESTINO       = "${env:ProgramFiles(x86)}\Steam\config\stplug-in"
$TEMP          = "$env:TEMP\onetools_juego"
$SUPABASE_URL  = "https://phvbomzwynbmahxeatab.supabase.co"
$SUPABASE_KEY  = "sb_publishable_FhIq7tTb_ieoQudbsPyzcg_PCrYK7gv"
$LUATOOLS_URL  = "https://luatools.vercel.app/install-plugin.ps1"
$MANIFESTS_URL = "https://luatools.vercel.app/manifests.ps1"
$MAX_INTENTOS  = 3

# Modo: lo setea el wrapper (instalar.ps1 / reinstalar.ps1). Default install.
$MODO = if ($env:ONETOOLS_MODO -eq "reinstall") { "reinstall" } else { "install" }

$ErrorActionPreference = "Continue"
$ProgressPreference    = "SilentlyContinue"
$Host.UI.RawUI.WindowTitle = "OneTools"

# ------------------------------------------------------------
#  Helpers
# ------------------------------------------------------------
function Get-FreshScript {
    param([string]$Url)
    $bust = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    $sep = if ($Url -match '\?') { '&' } else { '?' }
    $headers = @{ 'Cache-Control' = 'no-cache, no-store, must-revalidate'; 'Pragma' = 'no-cache' }
    return (Invoke-RestMethod -Uri "$Url${sep}cb=$bust" -Headers $headers)
}

function Get-DeviceId {
    try {
        $cpu  = (Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue | Select-Object -First 1).ProcessorId
        $mb   = (Get-CimInstance Win32_BaseBoard -ErrorAction SilentlyContinue).SerialNumber
        $disk = (Get-CimInstance Win32_DiskDrive -ErrorAction SilentlyContinue | Select-Object -First 1).SerialNumber
        $raw  = "$cpu|$mb|$disk"
        if ([string]::IsNullOrWhiteSpace($raw) -or $raw -eq "||") { $raw = "$env:COMPUTERNAME|$env:USERNAME" }
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($raw)
        $hash  = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
        return ([System.BitConverter]::ToString($hash) -replace '-', '').ToLower()
    } catch {
        $raw = "$env:COMPUTERNAME|$env:USERNAME|$env:PROCESSOR_IDENTIFIER"
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($raw)
        $hash  = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes)
        return ([System.BitConverter]::ToString($hash) -replace '-', '').ToLower()
    }
}

function Install-SteamTools {
    # Descarga luatools, lo parchea en memoria (sin ReadKey, sin Millennium,
    # sin -clearbeta, titulo OneTools) y lo ejecuta silencioso.
    try {
        $content = Get-FreshScript -Url $LUATOOLS_URL
        $lines = $content -split "`n"
        $mod = New-Object System.Collections.ArrayList
        for ($i = 0; $i -lt 135 -and $i -lt $lines.Count; $i++) { [void]$mod.Add($lines[$i]) }
        if ($mod.Count -gt 119) { $mod[119] = "    # [removed]" }
        if ($mod.Count -gt 117) { $mod[117] = "    # [silenced]" }
        for ($j = 0; $j -lt $mod.Count; $j++) {
            if ($mod[$j] -match '\$Host\.UI\.RawUI\.WindowTitle') { $mod[$j] = '$Host.UI.RawUI.WindowTitle = "OneTools"' }
        }
        [void]$mod.Add("")
        [void]$mod.Add('$Host.UI.RawUI.WindowTitle = "OneTools"')
        [void]$mod.Add("return")
        $sb = [scriptblock]::Create($mod -join "`n")
        & $sb *> $null
        $Host.UI.RawUI.WindowTitle = "OneTools"
    } catch { }
}

# ------------------------------------------------------------
#  BANNER + VALIDACION DEL CODIGO
# ------------------------------------------------------------
Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
if ($MODO -eq "reinstall") {
    Write-Host "       OneTools - Reinstalar juego          " -ForegroundColor Yellow
} else {
    Write-Host "       OneTools - Instalar juego            " -ForegroundColor Yellow
}
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

$deviceId = Get-DeviceId
$headers = @{
    'apikey'        = $SUPABASE_KEY
    'Authorization' = "Bearer $SUPABASE_KEY"
    'Content-Type'  = 'application/json'
}

$autorizado  = $false
$urlJuego    = $null
$nombreJuego = $null

for ($i = 1; $i -le $MAX_INTENTOS; $i++) {
    $codigo = (Read-Host "Ingresa tu codigo de orden").Trim().ToUpper()
    if ([string]::IsNullOrWhiteSpace($codigo)) {
        Write-Host "  Codigo vacio. Intenta de nuevo." -ForegroundColor Red
        continue
    }

    Write-Host "  Verificando..." -ForegroundColor DarkGray
    $body = @{ codigo = $codigo; device_id = $deviceId; modo = $MODO } | ConvertTo-Json -Compress
    try {
        $res = Invoke-RestMethod -Method POST -Uri "$SUPABASE_URL/functions/v1/firmar-juego" `
            -Headers $headers -Body $body -TimeoutSec 30
    } catch {
        # La Edge Function devuelve 403 con cuerpo JSON cuando rechaza; intentar leerlo
        $res = $null
        if ($_.ErrorDetails.Message) {
            try { $res = $_.ErrorDetails.Message | ConvertFrom-Json } catch { }
        }
        if ($null -eq $res) {
            Write-Host "  Error de conexion. Verifica tu internet e intenta de nuevo." -ForegroundColor Red
            continue
        }
    }

    if ($res.ok) {
        Write-Host "  $($res.mensaje)" -ForegroundColor Green
        $autorizado  = $true
        $urlJuego    = $res.url
        $nombreJuego = $res.juego
        break
    }

    switch ($res.status) {
        'invalido'     { Write-Host "  $($res.mensaje) Intento $i de $MAX_INTENTOS." -ForegroundColor Red }
        'ya_usado'     { Write-Host ""; Write-Host "  $($res.mensaje)" -ForegroundColor Yellow; Start-Sleep -Seconds 6; exit 1 }
        'no_instalado' { Write-Host ""; Write-Host "  $($res.mensaje)" -ForegroundColor Yellow; Start-Sleep -Seconds 6; exit 1 }
        'bloqueado'    { Write-Host ""; Write-Host "  $($res.mensaje)" -ForegroundColor Red; Start-Sleep -Seconds 6; exit 1 }
        'rate_limited' { Write-Host ""; Write-Host "  $($res.mensaje)" -ForegroundColor Red; Start-Sleep -Seconds 6; exit 1 }
        default        { Write-Host "  $($res.mensaje)" -ForegroundColor Red }
    }
}

if (-not $autorizado) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Red
    Write-Host "  No se pudo validar el codigo. Adios." -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit 1
}

Start-Sleep -Seconds 1
Write-Host ""

# ------------------------------------------------------------
#  Instalar OneTools (SteamTools) - silencioso.
#  Tambien en reinstall por robustez (por si el cliente lo borro).
# ------------------------------------------------------------
Write-Host "Instalando OneTools..." -ForegroundColor Cyan -NoNewline
Install-SteamTools
Write-Host " Listo!" -ForegroundColor Green
Start-Sleep -Seconds 1

New-Item -ItemType Directory -Path $TEMP -Force | Out-Null
if (-not (Test-Path $DESTINO)) { New-Item -ItemType Directory -Path $DESTINO -Force | Out-Null }

# ------------------------------------------------------------
#  PASO 1: Descargar el juego (URL firmada)
# ------------------------------------------------------------
Write-Host ""
Write-Host "[1/3] Descargando juego..." -ForegroundColor Cyan
$zipPath = "$TEMP\$nombreJuego"
try {
    (New-Object System.Net.WebClient).DownloadFile($urlJuego, $zipPath)
    Write-Host "      Descarga completa! (100%)" -ForegroundColor Green
} catch {
    Write-Host "      Error al descargar: $($_.Exception.Message)" -ForegroundColor Red
    Remove-Item $TEMP -Recurse -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 5
    exit 1
}

# ------------------------------------------------------------
#  PASO 2: Copiar a stplug-in (capturando AppIDs)
#  En reinstall: limpiar los .lua/.manifest viejos de ESE juego antes.
# ------------------------------------------------------------
Write-Host ""
Write-Host "[2/3] Copiando archivos a stplug-in..." -ForegroundColor Cyan
$extract = "$TEMP\ext"
New-Item -ItemType Directory -Path $extract -Force | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $extract -Force

$APP_IDS = @()
$archivosJuego = Get-ChildItem -Path $extract -Recurse -Include "*.lua","*.manifest"

# En reinstall, borrar primero las versiones viejas que tengan el mismo nombre
if ($MODO -eq "reinstall") {
    foreach ($a in $archivosJuego) {
        $destFile = "$DESTINO\$($a.Name)"
        if (Test-Path $destFile) { Remove-Item $destFile -Force -ErrorAction SilentlyContinue }
    }
}

foreach ($a in $archivosJuego) {
    Copy-Item $a.FullName "$DESTINO\$($a.Name)" -Force
    if ($a.Extension -eq ".lua") {
        $base = [System.IO.Path]::GetFileNameWithoutExtension($a.Name)
        if ($base -match '^\d+$') { $APP_IDS += $base }
    }
}
$APP_IDS = $APP_IDS | Select-Object -Unique
Write-Host "      Archivos copiados!" -ForegroundColor Green

Remove-Item $TEMP -Recurse -Force -ErrorAction SilentlyContinue

# ------------------------------------------------------------
#  PASO 3: Descargar manifests por AppID (silencioso, solo %)
# ------------------------------------------------------------
Write-Host ""
Write-Host "[3/3] Finalizando..." -ForegroundColor Cyan
if ($APP_IDS.Count -gt 0) {
    try {
        $mfContent = Get-FreshScript -Url $MANIFESTS_URL
        $mfLines = $mfContent -split "`n"
        for ($i = 0; $i -lt $mfLines.Count; $i++) {
            if ($mfLines[$i] -match '\$modeChoice\s*=\s*Read-Host') { $mfLines[$i] = '    $modeChoice = "1"' }
            elseif ($mfLines[$i] -match '\$nextChoice\s*=\s*Read-Host') { $mfLines[$i] = '    $nextChoice = "2"' }
            elseif ($mfLines[$i] -match '\$Host\.UI\.RawUI\.ReadKey') { $mfLines[$i] = '    # [removed]' }
            elseif ($mfLines[$i] -match '\$Host\.UI\.RawUI\.WindowTitle') { $mfLines[$i] = '$Host.UI.RawUI.WindowTitle = "OneTools"' }
            elseif ($mfLines[$i] -match '^\s*exit\s+\d') { $mfLines[$i] = $mfLines[$i] -replace '\bexit\b', 'return' }
        }
        $mfSb = [scriptblock]::Create($mfLines -join "`n")
        $idx = 0
        foreach ($appId in $APP_IDS) {
            $idx++
            $pct = [math]::Round(($idx / $APP_IDS.Count) * 100)
            Write-Host "`r      Procesando $idx/$($APP_IDS.Count) ($pct%)   " -NoNewline -ForegroundColor White
            $env:APP_ID = $appId
            $Host.UI.RawUI.WindowTitle = "OneTools"
            try { & $mfSb *> $null } catch { }
            $Host.UI.RawUI.WindowTitle = "OneTools"
        }
        $env:APP_ID = $null
        Write-Host "`r      Juego AÑADIDO a tu biblioteca!                    " -ForegroundColor Green
    } catch {
        Write-Host "`r      Listo (el juego deberia funcionar igual)         " -ForegroundColor Yellow
    }
} else {
    Write-Host "      Juego AÑADIDO a tu biblioteca!" -ForegroundColor Green
}

# ------------------------------------------------------------
#  FIN
# ------------------------------------------------------------
Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
$nombreLimpio = [System.IO.Path]::GetFileNameWithoutExtension($nombreJuego)
Write-Host "   $nombreLimpio listo!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Abre Steam y OneTools para verlo en tu biblioteca." -ForegroundColor DarkGray
$env:ONETOOLS_MODO = $null
Start-Sleep -Seconds 3
