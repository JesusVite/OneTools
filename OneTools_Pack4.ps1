# ============================================================
#  OneTools - Pack 4 Installer
#  Descarga e instala todos los juegos del Pack 4
# ============================================================

$BASE_URL = "https://pub-3969552ebd69440da9632dee8d18453b.r2.dev/pack4"
$INSTALL_DIR = "C:\OneTools\Pack4"
$LOG_FILE = "$INSTALL_DIR\pack4_log.txt"
$TEMP_DIR = "$env:TEMP\OneTools_Pack4"

# Lista de juegos del Pack 4
$JUEGOS = @(
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
    "Wo Long Fallen Dynasty.zip"
)

# ============================================================
#  FUNCIONES
# ============================================================

function Write-Log {
    param([string]$Mensaje, [string]$Tipo = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $linea = "[$timestamp] [$Tipo] $Mensaje"
    Write-Host $linea
    Add-Content -Path $LOG_FILE -Value $linea
}

function Encode-URL {
    param([string]$Texto)
    return [Uri]::EscapeDataString($Texto)
}

function Descargar-Zip {
    param([string]$NombreArchivo)
    $nombreEncoded = Encode-URL $NombreArchivo
    $url = "$BASE_URL/$nombreEncoded"
    $destino = "$TEMP_DIR\$NombreArchivo"

    try {
        Write-Log "Descargando: $NombreArchivo"
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($url, $destino)
        Write-Log "OK: $NombreArchivo" "OK"
        return $true
    } catch {
        Write-Log "ERROR descargando $NombreArchivo : $_" "ERROR"
        return $false
    }
}

function Instalar-Zip {
    param([string]$NombreArchivo)
    $zipPath = "$TEMP_DIR\$NombreArchivo"
    $nombreJuego = [System.IO.Path]::GetFileNameWithoutExtension($NombreArchivo)
    $destino = "$INSTALL_DIR\$nombreJuego"

    try {
        Write-Log "Extrayendo: $nombreJuego"
        Expand-Archive -Path $zipPath -DestinationPath $destino -Force
        Remove-Item $zipPath -Force
        Write-Log "Instalado: $nombreJuego" "OK"
        return $true
    } catch {
        Write-Log "ERROR instalando $nombreJuego : $_" "ERROR"
        return $false
    }
}

# ============================================================
#  INICIO
# ============================================================

Clear-Host
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "   OneTools - Pack 4 Installer" -ForegroundColor Yellow
Write-Host "   $($JUEGOS.Count) juegos incluidos" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""

# Crear directorios
New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $TEMP_DIR | Out-Null

Write-Log "Iniciando instalacion de Pack 4 - $($JUEGOS.Count) juegos"

$exitosos = 0
$fallidos = 0
$contador = 0

foreach ($juego in $JUEGOS) {
    $contador++
    $porcentaje = [math]::Round(($contador / $JUEGOS.Count) * 100)
    Write-Host ""
    Write-Host "[$contador/$($JUEGOS.Count)] ($porcentaje%) " -NoNewline -ForegroundColor Cyan
    Write-Host $juego -ForegroundColor White

    $descargaOK = Descargar-Zip $juego
    if ($descargaOK) {
        $instalacionOK = Instalar-Zip $juego
        if ($instalacionOK) { $exitosos++ } else { $fallidos++ }
    } else {
        $fallidos++
    }
}

# ============================================================
#  RESUMEN
# ============================================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "   INSTALACION COMPLETADA" -ForegroundColor Green
Write-Host "   Exitosos : $exitosos" -ForegroundColor Green
Write-Host "   Fallidos : $fallidos" -ForegroundColor Red
Write-Host "   Log      : $LOG_FILE" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Log "Instalacion finalizada. Exitosos: $exitosos | Fallidos: $fallidos"

# Limpiar temp
Remove-Item $TEMP_DIR -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Presiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
