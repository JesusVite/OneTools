# ============================================================
#  OneTools - Pack 4
# ============================================================

$R2_BASE        = "https://pub-3969552ebd69440da9632dee8d18453b.r2.dev/pack4"
$INSTALLER_URL  = "https://raw.githubusercontent.com/JesusVite/OneTools/main/OneTools_Setup.exe"
$DESTINO        = "${env:ProgramFiles(x86)}\Steam\config\stplug-in"
$STEAMTOOLS_EXE = "C:\Program Files\SteamTools\SteamTools.exe"
$STEAM_EXE      = "${env:ProgramFiles(x86)}\Steam\steam.exe"
$TEMP           = "$env:TEMP\onetools_pack4"

$JUEGOS = @(
    "60 Second Strike.zip","60 Seconds!.zip","7 Days to Die.zip","911 Operator.zip",
    "A Plague Tale Requiem.zip","Absolum.zip","ACE COMBAT™7 SKIES UNKNOWN.zip","Afterimage.zip",
    "Age of Empires Definitive Edition.zip","Age of Empires II Definitive Edition.zip","AI Limit.zip","Aka Manto.zip",
    "Alan Wake's American Nightmare.zip","Alan Wake.zip","Aliens Dark Descent.zip","Alone in the Dark.zip",
    "American Truck Simulator.zip","Amnesia The Dark Descent.zip","Among the Sleep.zip","Ancestors The Humankind Odyssey.zip",
    "Animal Shelter.zip","Anno 1800.zip","Another Crab's Treasure.zip","ARK Survival Ascended.zip",
    "ARSLAN THE WARRIORS OF LEGEND.zip","Assetto Corsa.zip","Attack on Titan  A.O.T..zip","Automation - The Car Company Tycoon.zip",
    "Avowed.zip","Bad Parenting 1.zip","Bakery Simulator.zip","Baldur's Gate 3.zip",
    "Baldur's Gate Dark Alliance II.zip","Baldur's Gate Dark Alliance.zip","Baldur's Gate Enhanced Edition.zip","Baldur's Gate II Enhanced Edition.zip",
    "Barony.zip","Barotrauma.zip","Batman - The Telltale Series.zip","Batman Arkham Asylum GOTY Edition.zip",
    "Batman Arkham City GOTY.zip","Batman The Enemy Within.zip","Batman™ Arkham Knight.zip","Batman™ Arkham Origins.zip",
    "BeamNG.drive.zip","Bellwright.zip","Bendy and the Dark Revival.zip","Bendy and the Ink Machine.zip",
    "Beyond Two Souls.zip","BIOMUTANT.zip","BioShock 2 Remastered.zip","BioShock Infinite.zip",
    "BioShock Remastered.zip","Black Mesa.zip","Blade & Sorcery.zip","Blasphemous 2.zip",
    "Blasphemous.zip","BLEACH Rebirth of Souls.zip","Borderlands 3.zip","Borderlands GOTY Enhanced.zip",
    "Bright Memory.zip","Broforce.zip","Brothers - A Tale of Two Sons.zip","Brothers A Tale of Two Sons Remake.zip",
    "Bully Scholarship Edition.zip","Bus Simulator 18.zip","Bus Simulator 21 Next Stop.zip","Call of Duty 4 Modern Warfare (2007).zip",
    "Call of Juarez Gunslinger.zip","Call to Arms - Gates of Hell Ostfront.zip","Captain Tsubasa - Rise of New Champions.zip","Car Dealer Simulator.zip",
    "Car Mechanic Simulator 2015.zip","Car Mechanic Simulator 2018.zip","Car Mechanic Simulator 2021.zip","Castlevania Advance Collection.zip",
    "Cat Quest II.zip","Cat Quest III.zip","Cat Quest.zip","Catherine Classic.zip",
    "Celeste.zip","CHRONO TRIGGER.zip","Cities in Motion 2.zip","Cities Skylines II.zip",
    "Cities Skylines.zip","Clair Obscur Expedition 33.zip","Cloudpunk.zip","Constance.zip",
    "Contraband Police.zip","Control Ultimate Edition.zip","Crash Bandicoot™ 4.zip","Crash Bandicoot™ N. Sane Trilogy.zip",
    "Crashlands 2.zip","Crashlands.zip","Crime Scene Cleaner.zip","CRISIS CORE –FINAL FANTASY VII– REUNION.zip",
    "Cronos The New Dawn.zip","Cult of the Lamb.zip","CUPHEAD.zip","Danganronpa 2.zip",
    "Danganronpa Another Episode.zip","Danganronpa Trigger Happy Havoc.zip","DARK SOULS™ II.zip","DARK SOULS™ III.zip",
    "DARK SOULS™ REMASTERED.zip","Darkest Dungeon® II.zip","Darkest Dungeon®.zip","Darksiders Genesis.zip",
    "Darksiders II Deathinitive.zip","Darksiders III.zip","Darksiders Warmastered Edition.zip","Dawn of Man.zip",
    "Days Gone.zip","Dead by Daylight.zip","Dead Cells.zip","Dead Island Definitive Edition.zip",
    "Dead Island Riptide.zip","Dead Rising 2 Off the Record.zip","Dead Space (2008).zip","Dead Space.zip",
    "Death Stranding Director's Cut.zip","Deep Rock Galactic.zip","Deltarune.zip","Desolate.zip",
    "Desperados - Wanted Dead or Alive.zip","Desperados III.zip","Destroy All Humans!.zip","Detroit Become Human.zip",
    "Devil May Cry 4 Special Edition.zip","Devil May Cry 5.zip","Devil May Cry HD Collection.zip","Digimon Story Cyber Sleuth.zip",
    "Digimon Survive.zip","Digimon World Next Order.zip","Dishonored 2.zip","Dishonored.zip",
    "Dishonored® Death of the Outsider.zip","DRAGON BALL Sparking! ZERO.zip","ELDEN RING NIGHTREIGN.zip","ELDEN RING.zip",
    "Five Nights at Freddy's Security Breach.zip","FNAF 1.zip","FNAF 2.zip","FNAF 3.zip",
    "FNAF 4.zip","FNAF Sister Location.zip","Ghost of Tsushima DIRECTOR'S CUT.zip","God of War Ragnarok.zip",
    "God of War.zip","Golf It.zip","Hollow Knight Silksong.zip","Hollow Knight.zip",
    "Horizon Forbidden West™ Complete Edition.zip","Horizon Zero Dawn™ Complete Edition.zip","Lies of P.zip","Marvel's Spider-Man 2.zip",
    "Marvel's Spider-Man Remastered.zip","Mewgenics.zip","Nine sols.zip","Nioh 3.zip",
    "Nioh Complete Edition.zip","Overcooked.zip","Phasmophobia.zip","Poly Bridge.zip",
    "Project Zomboid.zip","Ratchet & Clank Rift Apart.zip","Remnant II.zip","Resident Evil 2.zip",
    "Resident Evil 7 Biohazard.zip","Sekiro™ Shadows Die Twice.zip","SILENT HILL 2.zip","SILENT HILL F.zip",
    "SPIDERMAN MILES MORALES.zip","Stray.zip","TEKKEN 7.zip","TEKKEN 8.zip",
    "Terraria.zip","The Binding of Isaac Rebirth.zip","The Forest.zip","THE KING OF FIGHTERS 2002 UNLIMITED MATCH.zip",
    "The Last of Us™ Part I.zip","The Last of Us™ Part II Remastered.zip","Tom Clancy's Ghost Recon® Wildlands.zip",
    "UNCHARTED™ Legacy of Thieves Collection.zip","Until Then.zip","Wo Long Fallen Dynasty.zip"
)

Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "        OneTools - Pack 4 Installer         " -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

New-Item -ItemType Directory -Path $TEMP -Force | Out-Null
if (-not (Test-Path $DESTINO)) { New-Item -ItemType Directory -Path $DESTINO -Force | Out-Null }

# PASO 1: Descargar e instalar OneTools Setup
Write-Host "[1/4] Descargando OneTools Setup..." -ForegroundColor Cyan
$installer = "$TEMP\setup.exe"
(New-Object System.Net.WebClient).DownloadFile($INSTALLER_URL, $installer)
Write-Host "      Instalando SteamTools..." -ForegroundColor Cyan
Start-Process -FilePath $installer -ArgumentList "/S" -Wait
Start-Sleep -Seconds 5
$intentos = 0
while (-not (Test-Path $STEAMTOOLS_EXE) -and $intentos -lt 10) {
    Start-Sleep -Seconds 2; $intentos++
}
Write-Host "      Listo!" -ForegroundColor Green

# PASO 2: Descargar zips desde Cloudflare R2
Write-Host ""
Write-Host "[2/4] Descargando $($JUEGOS.Count) juegos desde servidor..." -ForegroundColor Cyan

$jobs = @()
foreach ($nombre in $JUEGOS) {
    $zipPath = "$TEMP\$nombre"
    $encoded = [Uri]::EscapeDataString($nombre)
    $dlUrl   = "$R2_BASE/$encoded"
    $jobs += Start-Job -ScriptBlock {
        param($url, $path)
        (New-Object System.Net.WebClient).DownloadFile($url, $path)
    } -ArgumentList $dlUrl, $zipPath
}

$total = $jobs.Count
while ($jobs | Where-Object { $_.State -eq "Running" }) {
    $completados = ($jobs | Where-Object { $_.State -eq "Completed" }).Count
    $pct = [math]::Round(($completados / $total) * 100)
    Write-Host "`r      Progreso: $completados/$total ($pct%)   " -NoNewline -ForegroundColor White
    Start-Sleep -Seconds 1
}
$jobs | Wait-Job | Out-Null
$jobs | Remove-Job -Force
Write-Host "`r      Descarga completa! $total/$total (100%)   " -ForegroundColor Green

# PASO 3: Extraer y copiar a stplug-in
Write-Host ""
Write-Host "[3/4] Instalando juegos..." -ForegroundColor Cyan
$contador = 0
foreach ($nombre in $JUEGOS) {
    $zipPath = "$TEMP\$nombre"
    $extract = "$TEMP\ext_$contador"
    $contador++
    if (Test-Path $zipPath) {
        $nombreJuego = [System.IO.Path]::GetFileNameWithoutExtension($nombre)
        Write-Host "`r      [$contador/$($JUEGOS.Count)] $nombreJuego   " -NoNewline -ForegroundColor White
        New-Item -ItemType Directory -Path $extract -Force | Out-Null
        Expand-Archive -Path $zipPath -DestinationPath $extract -Force
        Get-ChildItem -Path $extract -Recurse -Include "*.lua","*.manifest" | ForEach-Object {
            Copy-Item $_.FullName "$DESTINO\$($_.Name)" -Force
        }
        Remove-Item $zipPath,$extract -Recurse -Force -ErrorAction SilentlyContinue
    }
}
Write-Host ""
Write-Host "      Juegos instalados!" -ForegroundColor Green

# PASO 4: Abrir Steam y SteamTools
Write-Host ""
Write-Host "[4/4] Iniciando Steam y SteamTools..." -ForegroundColor Cyan

if (Test-Path $STEAM_EXE) {
    Start-Process -FilePath $STEAM_EXE
    Start-Sleep -Seconds 5
}

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

Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "   Instalacion completada con exito!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Yellow
Start-Sleep -Seconds 3
