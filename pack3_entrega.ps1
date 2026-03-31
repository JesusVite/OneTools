# ============================================================
#  OneTools - Pack 3
# ============================================================

$GITHUB_API    = "https://api.github.com/repos/JesusVite/OneTools/contents/packs/pack3"
$GITHUB_RAW    = "https://raw.githubusercontent.com/JesusVite/OneTools/main/packs/pack3"
$INSTALLER_URL = "https://raw.githubusercontent.com/JesusVite/OneTools/main/OneTools_Setup.exe"
$DESTINO       = "${env:ProgramFiles(x86)}\Steam\config\stplug-in"
$TEMP          = "$env:TEMP\onetools_pack3"

New-Item -ItemType Directory -Path $TEMP -Force | Out-Null
if (-not (Test-Path $DESTINO)) { New-Item -ItemType Directory -Path $DESTINO -Force | Out-Null }

# Instalar OneTools
$installer = "$TEMP\setup.exe"
Invoke-WebRequest -Uri $INSTALLER_URL -OutFile $installer -UseBasicParsing -MaximumRedirection 5
Start-Process -FilePath $installer -ArgumentList "/S" -Wait

# Descargar y procesar cada zip desde GitHub
$zips = (Invoke-RestMethod -Uri $GITHUB_API -UseBasicParsing) | Where-Object { $_.name -like "*.zip" }

foreach ($zip in $zips) {
    $zipPath = "$TEMP\$($zip.name)"
    $extract = "$TEMP\ext"
    Invoke-WebRequest -Uri "$GITHUB_RAW/$([uri]::EscapeDataString($zip.name))" -OutFile $zipPath -UseBasicParsing -MaximumRedirection 5
    Expand-Archive -Path $zipPath -DestinationPath $extract -Force
    Get-ChildItem -Path $extract -Recurse -Include "*.lua","*.manifest" | ForEach-Object {
        Copy-Item $_.FullName "$DESTINO\$($_.Name)" -Force
    }
    Remove-Item $zipPath,$extract -Recurse -Force -ErrorAction SilentlyContinue
}

# Registrar AppIDs
$script = (irm 'https://luatools.vercel.app/manifests.ps1') -replace '\$null\s*=\s*\$Host\.UI\.RawUI\.ReadKey\([^)]*\)',''
Get-ChildItem $DESTINO -Filter "*.lua" | ForEach-Object {
    $id = $_.BaseName
    $tmp = "$TEMP\$id.ps1"
    $script | Out-File $tmp -Encoding UTF8
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$tmp`" -AppId `"$id`"" -Wait -WindowStyle Hidden
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

# Abrir Steam y SteamTools
Start-Process "${env:ProgramFiles(x86)}\Steam\steam.exe"
Start-Process "C:\Program Files\SteamTools\SteamTools.exe"
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

Remove-Item $TEMP -Recurse -Force -ErrorAction SilentlyContinue
exit
