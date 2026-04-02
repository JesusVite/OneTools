# ============================================================
#  OneTools - Pack 3
# ============================================================

$GITHUB_API    = "https://api.github.com/repos/JesusVite/OneTools/contents/packs/pack3"
$INSTALLER_URL = "https://raw.githubusercontent.com/JesusVite/OneTools/main/OneTools_Setup.exe"
$DESTINO       = "${env:ProgramFiles(x86)}\Steam\config\stplug-in"
$STEAMTOOLS_EXE = "C:\Program Files\SteamTools\SteamTools.exe"
$STEAM_EXE     = "${env:ProgramFiles(x86)}\Steam\steam.exe"
$TEMP          = "$env:TEMP\onetools_pack3"

New-Item -ItemType Directory -Path $TEMP -Force | Out-Null
if (-not (Test-Path $DESTINO)) { New-Item -ItemType Directory -Path $DESTINO -Force | Out-Null }

# Obtener lista con URLs directas
$zips = (Invoke-RestMethod -Uri $GITHUB_API -UseBasicParsing) | Where-Object { $_.name -like "*.zip" }

# Descargar todo en paralelo
$jobs = @()
$installer = "$TEMP\setup.exe"
$jobs += Start-Job -ScriptBlock {
    param($url, $path)
    (New-Object System.Net.WebClient).DownloadFile($url, $path)
} -ArgumentList $INSTALLER_URL, $installer

foreach ($zip in $zips) {
    $zipPath = "$TEMP\$($zip.name)"
    $dlUrl   = $zip.download_url
    $jobs += Start-Job -ScriptBlock {
        param($url, $path)
        (New-Object System.Net.WebClient).DownloadFile($url, $path)
    } -ArgumentList $dlUrl, $zipPath
}

$jobs | Wait-Job | Out-Null
$jobs | Remove-Job -Force

# Instalar OneTools y esperar que termine completamente
Start-Process -FilePath $installer -ArgumentList "/S" -Wait
Start-Sleep -Seconds 5

# Esperar hasta que SteamTools.exe exista
$intentos = 0
while (-not (Test-Path $STEAMTOOLS_EXE) -and $intentos -lt 10) {
    Start-Sleep -Seconds 2
    $intentos++
}

# Extraer y copiar a stplug-in
foreach ($zip in $zips) {
    $zipPath = "$TEMP\$($zip.name)"
    $extract = "$TEMP\ext"
    if (Test-Path $zipPath) {
        New-Item -ItemType Directory -Path $extract -Force | Out-Null
        Expand-Archive -Path $zipPath -DestinationPath $extract -Force
        Get-ChildItem -Path $extract -Recurse -Include "*.lua","*.manifest" | ForEach-Object {
            Copy-Item $_.FullName "$DESTINO\$($_.Name)" -Force
        }
        Remove-Item $zipPath,$extract -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Abrir Steam
if (Test-Path $STEAM_EXE) {
    Start-Process -FilePath $STEAM_EXE
    Start-Sleep -Seconds 5
}

# Abrir SteamTools
if (Test-Path $STEAMTOOLS_EXE) {
    Start-Process -FilePath $STEAMTOOLS_EXE
    Start-Sleep -Seconds 5

    Add-Type @"
using System; using System.Runtime.InteropServices;
public class MC {
    [DllImport("user32.dll")] public static extern void mouse_event(int f,int x,int y,int c,int e);
    [DllImport("user32.dll")] public static extern bool SetCursorPos(int x,int y);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h,out RECT r);
    public struct RECT{public int Left,Top,Right,Bottom;}
    public static void RC(int x,int y){SetCursorPos(x,y);System.Threading.Thread.Sleep(300);mouse_event(8,x,y,0,0);System.Threading.Thread.Sleep(150);mouse_event(16,x,y,0,0);}
}
"@

    $st = Get-Process -Name "SteamTools" -ErrorAction SilentlyContinue
    if ($st -and $st.MainWindowHandle -ne 0) {
        $r = New-Object MC+RECT
        [MC]::GetWindowRect($st.MainWindowHandle,[ref]$r) | Out-Null
        $x = [int](($r.Left+$r.Right)/2); $y = [int](($r.Top+$r.Bottom)/2)
        $w = New-Object -ComObject wscript.shell
        [MC]::RC($x,$y); Start-Sleep -Seconds 1
        $w.SendKeys("{DOWN}"); Start-Sleep -Milliseconds 300
        $w.SendKeys("{DOWN}"); Start-Sleep -Milliseconds 300
        $w.SendKeys("{ENTER}"); Start-Sleep -Seconds 15
        [MC]::RC($x,$y); Start-Sleep -Seconds 1
        1..10 | ForEach-Object { $w.SendKeys("{DOWN}"); Start-Sleep -Milliseconds 150 }
        $w.SendKeys("{ENTER}")
    }
}

Remove-Item $TEMP -Recurse -Force -ErrorAction SilentlyContinue
exit
