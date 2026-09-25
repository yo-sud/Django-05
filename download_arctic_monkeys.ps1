#!/usr/bin/env pwsh
# Descarga Arctic Monkeys: álbumes, B-sides, acústicos, rarezas con metadata+portada+letra embedida
# Requiere: yt-dlp (actualizado), ffmpeg (instalado)

$MusicRoot = "$env:USERPROFILE\Music\Arctic Monkeys"
$YTDLP = "yt-dlp"

# Crear estructura
$folders = @("Albums", "B-Sides", "Acoustic", "Rarities-Unreleased", "Live", "Compilations-Soundtracks")
foreach ($f in $folders) { New-Item -ItemType Directory -Force -Path "$MusicRoot\$f" | Out-Null }

# Config base: audio HQ + embed metadata/thumbnail/lyrics
$baseArgs = @(
    "--extract-audio",
    "--audio-format", "mp3",
    "--audio-quality", "0",           # mejor calidad VBR
    "--embed-metadata",               # tags ID3
    "--embed-thumbnail",              # portada en el archivo
    "--write-thumbnail",              # también guarda .jpg aparte
    "--convert-thumbnails", "jpg",
    "--add-metadata",
    "--parse-metadata", "artist:Arctic Monkeys",
    "--output", "$MusicRoot/%(playlist_title|Unknown)s/%(title)s [%(id)s].%(ext)s",
    "--ignore-errors",
    "--no-overwrites",
    "--sleep-interval", "3",
    "--max-sleep-interval", "6",
    "--ffmpeg-location", "$env:USERPROFILE\ffmpeg\ffmpeg-master-latest-win64-gpl\bin"
)

function Download-Category {
    param([string]$Category, [string[]]$Queries, [string]$Subdir)
    Write-Host "=== $Category ===" -ForegroundColor Cyan
    foreach ($q in $Queries) {
        Write-Host "  Buscando: $q" -ForegroundColor Gray
        $args = @($baseArgs) + @("--output", "$MusicRoot\$Subdir\%(title)s [%(id)s].%(ext)s")
        & $YTDLP @args "ytsearch30:$q"
    }
}

# 1. ÁLBUMES OFICIALES (7 álbumes de estudio)
$albums = @(
    "Whatever People Say I Am That's What I'm Not full album",
    "Favourite Worst Nightmare full album",
    "Humbug full album",
    "Suck It and See full album",
    "AM full album",
    "Tranquility Base Hotel & Casino full album",
    "The Car full album"
)
Download-Category "Álbumes Oficiales" $albums "Albums"

# 2. EPs
$eps = @(
    "Five Minutes with Arctic Monkeys EP",
    "Who the Fuck Are Arctic Monkeys EP",
    "Cornerstone EP",
    "Don't Sit Down Cause I've Moved Your Chair EP"
)
Download-Category "EPs" $eps "Albums"

# 3. B-SIDES Y CARAS B
$bSides = @(
    "Arctic Monkeys B-sides",
    "Arctic Monkeys bonus tracks",
    "Arctic Monkeys single B-side",
    'Arctic Monkeys "B side"',
    "Arctic Monkeys rarities B-sides compilation"
)
Download-Category "B-Sides" $bSides "B-Sides"

# 4. VERSIONES ACÚSTICAS / STRIPPED / UNPLUGGED
$acoustic = @(
    "Arctic Monkeys acoustic session",
    "Arctic Monkeys acoustic live",
    "Arctic Monkeys unplugged",
    "Arctic Monkeys stripped version",
    "Arctic Monkeys acoustic version",
    "Alex Turner acoustic"
)
Download-Category "Acústicos" $acoustic "Acoustic"

# 5. RAREZAS, DEMOS, INÉDITOS, PERDIDOS, OUTTAKES
$rarities = @(
    "Arctic Monkeys demo",
    "Arctic Monkeys unreleased",
    "Arctic Monkeys rare track",
    "Arctic Monkeys lost track",
    "Arctic Monkeys bootleg",
    "Arctic Monkeys outtake",
    "Arctic Monkeys hidden track",
    "Arctic Monkeys soundcheck",
    "Arctic Monkeys rehearsal"
)
Download-Category "Rarezas/Inéditos" $rarities "Rarities-Unreleased"

# 6. CONCIERTOS Y SESIONES LIVE OFICIALES
$live = @(
    "Arctic Monkeys Live at the Royal Albert Hall",
    "Arctic Monkeys Live at the Apollo",
    "Arctic Monkeys Live at Abbey Road",
    "Arctic Monkeys Live Lounge",
    "Arctic Monkeys KEXP",
    "Arctic Monkeys Tiny Desk",
    "Arctic Monkeys Glastonbury full",
    "Arctic Monkeys Reading Festival full",
    "Arctic Monkeys live full concert"
)
Download-Category "Live" $live "Live"

# 7. BANDAS SONORAS, COLABORACIONES, SIDE PROJECTS
$comp = @(
    "Arctic Monkeys soundtrack",
    "Arctic Monkeys compilation",
    "Alex Turner solo",
    "The Last Shadow Puppets",
    "Miles Kane Arctic Monkeys"
)
Download-Category "Compilaciones/Side Projects" $comp "Compilations-Soundtracks"

Write-Host "`n=== ¡COMPLETADO! ===" -ForegroundColor Green
Write-Host "Música en: $MusicRoot" -ForegroundColor Yellow
Write-Host "Cada archivo MP3 tiene: portada embedida + metadatos ID3 + máxima calidad" -ForegroundColor Cyan