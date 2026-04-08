# ============================================================
#  OneTools - Pack 4 - Pedido personalizado
# ============================================================

$R2_BASE        = "https://pub-3969552ebd69440da9632dee8d18453b.r2.dev/pack4"
$INSTALLER_URL  = "https://raw.githubusercontent.com/JesusVite/OneTools/main/OneTools_Setup.exe"
$DESTINO        = "${env:ProgramFiles(x86)}\Steam\config\stplug-in"
$STEAMTOOLS_EXE = "C:\Program Files\SteamTools\SteamTools.exe"
$STEAM_EXE      = "${env:ProgramFiles(x86)}\Steam\steam.exe"
$TEMP           = "$env:TEMP\onetools_pedido"

$TODOS = @(
    "60 Second Strike.zip",
    "60 Seconds!.zip",
    "7 Days to Die.zip",
    "911 Operator.zip",
    "A Plague Tale Requiem.zip",
    "Absolum.zip",
    "ACE COMBAT™7 SKIES UNKNOWN.zip",
    "Afterimage.zip",
    "Age of Empires Definitive Edition.zip",
    "Age of Empires II Definitive Edition.zip",
    "AI Limit.zip",
    "Aka Manto.zip",
    "Alan Wake's American Nightmare.zip",
    "Alan Wake.zip",
    "Aliens Dark Descent.zip",
    "Alone in the Dark.zip",
    "American Truck Simulator.zip",
    "Amnesia The Dark Descent.zip",
    "Among the Sleep.zip",
    "Ancestors The Humankind Odyssey.zip",
    "Animal Shelter.zip",
    "Anno 1800.zip",
    "Another Crab's Treasure.zip",
    "ARK Survival Ascended.zip",
    "ARSLAN THE WARRIORS OF LEGEND.zip",
    "Assetto Corsa.zip",
    "Attack on Titan  A.O.T..zip",
    "Automation - The Car Company Tycoon.zip",
    "Avowed.zip",
    "Bad Parenting 1.zip",
    "Bakery Simulator.zip",
    "Baldur's Gate 3.zip",
    "Baldur's Gate Dark Alliance II.zip",
    "Baldur's Gate Dark Alliance.zip",
    "Baldur's Gate Enhanced Edition.zip",
    "Baldur's Gate II Enhanced Edition.zip",
    "Barony.zip",
    "Barotrauma.zip",
    "Batman - The Telltale Series.zip",
    "Batman Arkham Asylum GOTY Edition.zip",
    "Batman Arkham City GOTY.zip",
    "Batman The Enemy Within.zip",
    "Batman™ Arkham Knight.zip",
    "Batman™ Arkham Origins.zip",
    "BeamNG.drive.zip",
    "Bellwright.zip",
    "Bendy and the Dark Revival.zip",
    "Bendy and the Ink Machine.zip",
    "Beyond Two Souls.zip",
    "BIOMUTANT.zip",
    "BioShock 2 Remastered.zip",
    "BioShock Infinite.zip",
    "BioShock Remastered.zip",
    "Black Mesa.zip",
    "Blade & Sorcery.zip",
    "Blasphemous 2.zip",
    "Blasphemous.zip",
    "BLEACH Rebirth of Souls.zip",
    "Borderlands 3.zip",
    "Borderlands GOTY Enhanced.zip",
    "Bright Memory.zip",
    "Broforce.zip",
    "Brothers - A Tale of Two Sons.zip",
    "Brothers A Tale of Two Sons Remake.zip",
    "Bully Scholarship Edition.zip",
    "Bus Simulator 18.zip",
    "Bus Simulator 21 Next Stop.zip",
    "Call of Duty 4 Modern Warfare (2007).zip",
    "Call of Juarez Gunslinger.zip",
    "Call to Arms - Gates of Hell Ostfront.zip",
    "Captain Tsubasa - Rise of New Champions.zip",
    "Car Dealer Simulator.zip",
    "Car Mechanic Simulator 2015.zip",
    "Car Mechanic Simulator 2018.zip",
    "Car Mechanic Simulator 2021.zip",
    "Castlevania Advance Collection.zip",
    "Cat Quest II.zip",
    "Cat Quest III.zip",
    "Cat Quest.zip",
    "Catherine Classic.zip",
    "Celeste.zip",
    "CHRONO TRIGGER.zip",
    "Cities in Motion 2.zip",
    "Cities Skylines II.zip",
    "Cities Skylines.zip",
    "Clair Obscur Expedition 33.zip",
    "Cloudpunk.zip",
    "Constance.zip",
    "Contraband Police.zip",
    "Control Ultimate Edition.zip",
    "Crash Bandicoot™ 4.zip",
    "Crash Bandicoot™ N. Sane Trilogy.zip",
    "Crashlands 2.zip",
    "Crashlands.zip",
    "Crime Scene Cleaner.zip",
    "CRISIS CORE –FINAL FANTASY VII– REUNION.zip",
    "Cronos The New Dawn.zip",
    "Cult of the Lamb.zip",
    "CUPHEAD.zip",
    "Danganronpa 2.zip",
    "Danganronpa Another Episode.zip",
    "Danganronpa Trigger Happy Havoc.zip",
    "DARK SOULS™ II.zip",
    "DARK SOULS™ III.zip",
    "DARK SOULS™ REMASTERED.zip",
    "Darkest Dungeon® II.zip",
    "Darkest Dungeon®.zip",
    "Darksiders Genesis.zip",
    "Darksiders II Deathinitive.zip",
    "Darksiders III.zip",
    "Darksiders Warmastered Edition.zip",
    "Dawn of Man.zip",
    "Days Gone.zip",
    "Dead by Daylight.zip",
    "Dead Cells.zip",
    "Dead Island Definitive Edition.zip",
    "Dead Island Riptide.zip",
    "Dead Rising 2 Off the Record.zip",
    "Dead Space (2008).zip",
    "Dead Space.zip",
    "Death Stranding Director's Cut.zip",
    "Deep Rock Galactic.zip",
    "Deltarune.zip",
    "Desolate.zip",
    "Desperados - Wanted Dead or Alive.zip",
    "Desperados III.zip",
    "Destroy All Humans!.zip",
    "Detroit Become Human.zip",
    "Devil May Cry 4 Special Edition.zip",
    "Devil May Cry 5.zip",
    "Devil May Cry HD Collection.zip",
    "Digimon Story Cyber Sleuth.zip",
    "Digimon Survive.zip",
    "Digimon World Next Order.zip",
    "Dishonored 2.zip",
    "Dishonored.zip",
    "Dishonored® Death of the Outsider.zip",
    "DRAGON BALL Sparking! ZERO.zip",
    "ELDEN RING NIGHTREIGN.zip",
    "ELDEN RING.zip",
    "Five Nights at Freddy's Security Breach.zip",
    "FNAF 1.zip",
    "FNAF 2.zip",
    "FNAF 3.zip",
    "FNAF 4.zip",
    "FNAF Sister Location.zip",
    "Ghost of Tsushima DIRECTOR'S CUT.zip",
    "God of War Ragnarok.zip",
    "God of War.zip",
    "Golf It.zip",
    "Hollow Knight Silksong.zip",
    "Hollow Knight.zip",
    "Horizon Forbidden West™ Complete Edition.zip",
    "Horizon Zero Dawn™ Complete Edition.zip",
    "Lies of P.zip",
    "Marvel's Spider-Man 2.zip",
    "Marvel's Spider-Man Remastered.zip",
    "Mewgenics.zip",
    "Nine sols.zip",
    "Nioh 3.zip",
    "Nioh Complete Edition.zip",
    "Overcooked.zip",
    "Phasmophobia.zip",
    "Poly Bridge.zip",
    "Project Zomboid.zip",
    "Ratchet & Clank Rift Apart.zip",
    "Remnant II.zip",
    "Resident Evil 2.zip",
    "Resident Evil 7 Biohazard.zip",
    "Sekiro™ Shadows Die Twice.zip",
    "SILENT HILL 2.zip",
    "SILENT HILL F.zip",
    "SPIDERMAN MILES MORALES.zip",
    "Stray.zip",
    "TEKKEN 7.zip",
    "TEKKEN 8.zip",
    "Terraria.zip",
    "The Binding of Isaac Rebirth.zip",
    "The Forest.zip",
    "THE KING OF FIGHTERS 2002 UNLIMITED MATCH.zip",
    "The Last of Us™ Part I.zip",
    "The Last of Us™ Part II Remastered.zip",
    "Tom Clancy's Ghost Recon® Wildlands.zip",
    "UNCHARTED™ Legacy of Thieves Collection.zip",
    "Until Then.zip",
    "Wo Long Fallen Dynasty.zip",
    "Disneyland Adventures.zip",
    "Dispatch.zip",
    "DOOM + DOOM II.zip",
    "DOOM Eternal.zip",
    "Door Kickers 2.zip",
    "DRAGON BALL XENOVERSE 2.zip",
    "DRAGON BALL XENOVERSE.zip",
    "DRAGON QUEST BUILDERS™ 2.zip",
    "Dragon's Dogma Dark Arisen.zip",
    "DreadOut 2.zip",
    "DreadOut Keepers of The Dark.zip",
    "DreadOut Remastered Collection.zip",
    "DreadOut.zip",
    "Dune Imperium.zip",
    "Dying Light 2 Reloaded Edition.zip",
    "Dying Light The Beast.zip",
    "Dying Light.zip",
    "DYSMANTLE.zip",
    "ENDER LILIES Quietus of the Knights.zip",
    "ENDER MAGNOLIA.zip",
    "Enshrouded.zip",
    "Erica.zip",
    "Escape from Duckov.zip",
    "Euro Truck Simulator 2.zip",
    "Europa Universalis IV.zip",
    "EVERSPACE™ 2.zip",
    "EVERSPACE™.zip",
    "Evil West.zip",
    "Exit the Gungeon.zip",
    "Fable Anniversary.zip",
    "Factorio.zip",
    "FAIRY TAIL.zip",
    "Fallout 2.zip",
    "Fallout 4.zip",
    "Fallout.zip",
    "FAR Lone Sails.zip",
    "Farming Simulator 19.zip",
    "Farming Simulator 22.zip",
    "Farming Simulator 25.zip",
    "FINAL FANTASY II.zip",
    "FINAL FANTASY III.zip",
    "FINAL FANTASY IV (3D Remake).zip",
    "FINAL FANTASY IV THE AFTER YEARS.zip",
    "FINAL FANTASY IV.zip",
    "FINAL FANTASY IX.zip",
    "FINAL FANTASY V.zip",
    "FINAL FANTASY VI.zip",
    "FINAL FANTASY VII REMAKE INTERGRADE.zip",
    "FINAL FANTASY XIII.zip",
    "FINAL FANTASY.zip",
    "Firefight.zip",
    "Firewatch.zip",
    "Fireworks Mania.zip",
    "Flashing Lights.zip",
    "FlatOut 2.zip",
    "Forager.zip",
    "Forza Horizon 5.zip",
    "Frostpunk.zip",
    "Game Dev Tycoon.zip",
    "Garfield Kart.zip",
    "Garry's Mod.zip",
    "Gears of War Reloaded.zip",
    "Geometry Dash.zip",
    "Getting Over It.zip",
    "Ghost of a Tale.zip",
    "Ghostrunner.zip",
    "Goat Simulator 3.zip",
    "Goat Simulator.zip",
    "Granny.zip",
    "GreedFall.zip",
    "Grounded.zip",
    "Gunsmith Simulator.zip",
    "Guts and Glory.zip",
    "GYLT.zip",
    "Hades.zip",
    "Hades II.zip",
    "Half-Life 2.zip",
    "Half-Life Alyx.zip",
    "Half-Life Blue Shift.zip",
    "Half-Life Opposing Force.zip",
    "Half-Life Source.zip",
    "Halo Wars Definitive Edition.zip",
    "Hearts of Iron IV.zip",
    "Hellblade Senua's Sacrifice.zip",
    "HELLDIVERS™.zip",
    "Hello Neighbor Hide and Seek.zip",
    "Hi-Fi RUSH.zip",
    "Hidden Deep.zip",
    "High On Life.zip",
    "Home Sweet Home.zip",
    "Horizon Zero Dawn™ Remastered.zip",
    "Hotline Miami 2.zip",
    "Hotline Miami.zip",
    "House Flipper.zip",
    "HumanitZ.zip",
    "Hunting Simulator 2.zip",
    "INAZUMA ELEVEN Victory Road.zip",
    "Indiana Jones and the Fate of Atlantis.zip",
    "Indiana Jones and the Great Circle.zip",
    "Injustice 2.zip",
    "Injustice Gods Among Us.zip",
    "INSIDE.zip",
    "Is This Seat Taken.zip",
    "It Takes Two.zip",
    "Jotun.zip",
    "Journey.zip",
    "Just Cause 3.zip",
    "Just Cause.zip",
    "Kaku Ancient Seal.zip",
    "Katana ZERO.zip",
    "Kena Bridge of Spirits.zip",
    "Kenshi.zip",
    "Kerbal Space Program 2.zip",
    "Kerbal Space Program.zip",
    "Kingdom Come Deliverance II.zip",
    "Kingdom Come Deliverance.zip",
    "Kingdom Rush 5.zip",
    "Kingdom Rush.zip",
    "Kingdoms of Amalur.zip",
    "Klonoa Phantasy Reverie.zip",
    "Left 4 Dead 2.zip",
    "LEGO Batman 2.zip",
    "LEGO Batman 3.zip",
    "LEGO Batman The Videogame.zip",
    "LEGO City Undercover.zip",
    "#DRIVE Rally.zip",
    "10 Miles To Safety.zip",
    "100% Orange Juice.zip",
    "1000xRESIST.zip",
    "11-11 Memories Retold.zip",
    "123 Slaughter Me Street.zip",
    "9 Days.zip",
    "9 Monkeys of Shaolin.zip",
    "9 Years of Shadows.zip",
    "A Bird Story.zip",
    "A Dance of Fire and Ice.zip",
    "A Day Out.zip",
    "A Game About Digging A Hole.zip",
    "A Hat in Time.zip",
    "A Juggler's Tale.zip",
    "A Plague Tale Innocence.zip",
    "A Quiet Place The Road Ahead.zip",
    "A Short Hike.zip",
    "A Space for the Unbound.zip",
    "A Story About My Uncle.zip",
    "A Tale of Paper Refolded.zip",
    "A Total War Saga THRONES OF BRITANNIA.zip",
    "Abiotic Factor.zip",
    "Tony Hawk's™ Pro Skater™ 1 + 2.zip",
    "Tormented Souls 2.zip",
    "Tormented Souls.zip",
    "Train Sim World 5.zip",
    "Twelve Minutes.zip",
    "ULTRAKILL.zip",
    "Undertale.zip",
    "UNPUNISHED.zip",
    "Until Dawn™.zip",
    "Valheim.zip",
    "Vampire Survivors.zip",
    "Visage.zip",
    "Wartales.zip",
    "Windblown.zip",
    "World Box - God Simulator.zip",
    "World War Z.zip",
    "Yakuza 0 Director's Cut.zip",
    "Yakuza 3 Remastered.zip",
    "Yakuza 4 Remastered.zip",
    "Yakuza 5 Remastered.zip",
    "Yakuza Kiwami 2.zip",
    "Yakuza Kiwami.zip",
    "Yooka-Laylee and the Impossible Lair.zip",
    "Yooka-Laylee.zip",
    "Yooka-Replaylee.zip"
)

# ============================================================
# MOSTRAR LISTA DE JUEGOS
# ============================================================
Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "     OneTools - Selector de Pedido          " -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

for ($i = 0; $i -lt $TODOS.Count; $i++) {
    $num = ($i + 1).ToString().PadLeft(3)
    $nombre = [System.IO.Path]::GetFileNameWithoutExtension($TODOS[$i])
    Write-Host "  $num. $nombre" -ForegroundColor White
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  Maximo 10 juegos por pedido" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

# ============================================================
# SELECCION
# ============================================================
do {
    $input = Read-Host "Ingresa los numeros separados por coma (ej: 1,45,87)"
    $seleccion = $input -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -match "^\d+$" } | ForEach-Object { [int]$_ }
    $seleccion = $seleccion | Where-Object { $_ -ge 1 -and $_ -le $TODOS.Count } | Select-Object -Unique

    if ($seleccion.Count -eq 0) {
        Write-Host "  No seleccionaste numeros validos. Intenta de nuevo." -ForegroundColor Red
    } elseif ($seleccion.Count -gt 10) {
        Write-Host "  Maximo 10 juegos. Seleccionaste $($seleccion.Count). Intenta de nuevo." -ForegroundColor Red
        $seleccion = $null
    }
} while (-not $seleccion)

$JUEGOS = $seleccion | ForEach-Object { $TODOS[$_ - 1] }

Write-Host ""
Write-Host "Juegos seleccionados:" -ForegroundColor Cyan
$JUEGOS | ForEach-Object { Write-Host "  - $([System.IO.Path]::GetFileNameWithoutExtension($_))" -ForegroundColor White }
Write-Host ""

$confirmar = Read-Host "Confirmar e instalar? (s/n)"
if ($confirmar -ne "s") {
    Write-Host "Cancelado." -ForegroundColor Red
    exit
}

# ============================================================
# INSTALACION
# ============================================================
Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "     OneTools - Instalando pedido           " -ForegroundColor Yellow
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

# PASO 2: Descargar zips seleccionados
Write-Host ""
Write-Host "[2/4] Descargando $($JUEGOS.Count) juego(s)..." -ForegroundColor Cyan

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
        Write-Host "      [$contador/$($JUEGOS.Count)] $nombreJuego" -ForegroundColor White
        New-Item -ItemType Directory -Path $extract -Force | Out-Null
        Expand-Archive -Path $zipPath -DestinationPath $extract -Force
        Get-ChildItem -Path $extract -Recurse -Include "*.lua","*.manifest" | ForEach-Object {
            Copy-Item $_.FullName "$DESTINO\$($_.Name)" -Force
        }
        Remove-Item $zipPath,$extract -Recurse -Force -ErrorAction SilentlyContinue
    }
}
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
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern IntPtr SetFocus(IntPtr h);
    public struct RECT{public int Left,Top,Right,Bottom;}
    public static void RC(int x,int y){SetCursorPos(x,y);System.Threading.Thread.Sleep(300);mouse_event(8,x,y,0,0);System.Threading.Thread.Sleep(150);mouse_event(16,x,y,0,0);}
}
"@
    $intentosST = 0
    do {
        Start-Sleep -Seconds 2
        $st = Get-Process -Name "SteamTools" -ErrorAction SilentlyContinue
        $intentosST++
    } while ((-not $st -or $st.MainWindowHandle -eq 0) -and $intentosST -lt 15)

    if ($st -and $st.MainWindowHandle -ne 0) {
        [MC]::SetForegroundWindow($st.MainWindowHandle) | Out-Null
        [MC]::SetFocus($st.MainWindowHandle) | Out-Null
        Start-Sleep -Seconds 1

        $r = New-Object MC+RECT
        [MC]::GetWindowRect($st.MainWindowHandle,[ref]$r) | Out-Null
        $x = [int](($r.Left+$r.Right)/2); $y = [int](($r.Top+$r.Bottom)/2)

        [MC]::RC($x,$y); Start-Sleep -Seconds 1

        $w = New-Object -ComObject wscript.shell
        $w.AppActivate($st.Id) | Out-Null
        Start-Sleep -Milliseconds 500

        $w.SendKeys("{DOWN}"); Start-Sleep -Milliseconds 300
        $w.SendKeys("{DOWN}"); Start-Sleep -Milliseconds 300
        $w.SendKeys("{ENTER}"); Start-Sleep -Seconds 20

        # Steam se reinicio - SteamTools sigue flotando, hacer click directo en el overlay
        [MC]::RC($x,$y); Start-Sleep -Seconds 1
        $w.AppActivate($st.Id) | Out-Null
        Start-Sleep -Milliseconds 500
        1..10 | ForEach-Object { $w.SendKeys("{DOWN}"); Start-Sleep -Milliseconds 150 }
        $w.SendKeys("{ENTER}")
    }
}

Remove-Item $TEMP -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "   Pedido completado con exito!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Yellow
Start-Sleep -Seconds 3
