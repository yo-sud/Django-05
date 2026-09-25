#!/usr/bin/env pwsh
# Descarga SOLO música oficial de Arctic Monkeys: álbumes específicos + B-sides

$MusicRoot = "$env:USERPROFILE\Music\Arctic Monkeys"
$YTDLP = "yt-dlp"
$FFMPEG = "$env:USERPROFILE\ffmpeg\ffmpeg-master-latest-win64-gpl\bin"

$folders = @(
    "Suck It and See",
    "Humbug",
    "AM",
    "Tranquility Base Hotel & Casino",
    "The Car"
)
foreach ($f in $folders) { New-Item -ItemType Directory -Force -Path "$MusicRoot\$f" | Out-Null }

$baseArgs = @(
    "--extract-audio",
    "--audio-format", "mp3",
    "--audio-quality", "0",
    "--embed-metadata",
    "--embed-thumbnail",
    "--write-thumbnail",
    "--convert-thumbnails", "jpg",
    "--add-metadata",
    "--parse-metadata", "artist:Arctic Monkeys",
    "--ignore-errors",
    "--no-overwrites",
    "--sleep-interval", "3",
    "--max-sleep-interval", "6",
    "--ffmpeg-location", $FFMPEG
)

function Download-Album {
    param([string]$AlbumName, [string]$SearchQuery, [string]$Folder)
    Write-Host "`n=== $AlbumName ===" -ForegroundColor Cyan
    $args = @($baseArgs) + @("--output", "$MusicRoot\$Folder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch20:$SearchQuery"
}

# 1. SUCK IT AND SEE + B-SIDES
Download-Album "Suck It And See" `
    'Arctic Monkeys Suck It And See full album official' `
    "Suck It and See"

Download-Album "Suck It And See B-sides" `
    'Arctic Monkeys Suck It And See B-side OR bonus track Evil Twin OR Hellcat Spangled Shalalala OR You And I OR Piledriver Waltz OR Love Is A Laserquest OR Dont Sit Down OR Reckless official audio' `
    "Suck It and See"

# 2. HUMBUG + B-SIDES
Download-Album "Humbug" `
    'Arctic Monkeys Humbug full album official' `
    "Humbug"

Download-Album "Humbug B-sides" `
    'Arctic Monkeys Humbug B-side OR bonus track Nettles OR Potion Approaching OR Fire And The Thud OR Cornerstone OR Crying Lightning OR My Propeller OR Pretty Visitors OR Dangerous Animals OR Secret Door OR Jewellers Hands official audio' `
    "Humbug"

# 3. AM + B-SIDES
Download-Album "AM" `
    'Arctic Monkeys AM full album official' `
    "AM"

Download-Album "AM B-sides" `
    'Arctic Monkeys AM B-side OR bonus track Youre So Dark OR Stop The World OR Anyways OR Fireside OR Do I Wanna Know OR R U Mine OR One For The Road OR Arabella OR No 1 Party Anthem OR Mad Sounds OR Knee Socks OR I Wanna Be Yours official audio' `
    "AM"

# 4. TRANQUILITY BASE HOTEL & CASINO + B-SIDES
Download-Album "Tranquility Base Hotel & Casino" `
    'Arctic Monkeys Tranquility Base Hotel Casino full album official' `
    "Tranquility Base Hotel & Casino"

Download-Album "Tranquility Base Hotel & Casino B-sides" `
    'Arctic Monkeys Tranquility Base Hotel Casino B-side OR bonus track Four Out Of Five OR Star Treatment OR One Point Perspective OR American Sports OR Golden Trunks OR Science Fiction OR She Looks Like Fun OR Batphone OR Ultracheese official audio' `
    "Tranquility Base Hotel & Casino"

# 5. THE CAR + B-SIDES
Download-Album "The Car" `
    'Arctic Monkeys The Car full album official' `
    "The Car"

Download-Album "The Car B-sides" `
    'Arctic Monkeys The Car B-side OR bonus track Mirrorball OR Aint Quite Where I Think I Am OR Sculptures Of Anything Goes OR Jet Skis On The Moat OR Body Paint OR Big Ideas OR Hello You OR Mr Schwartz OR Perfect Sense official audio' `
    "The Car"

Write-Host "`n=== ¡COMPLETADO! ===" -ForegroundColor Green
Write-Host "Carpetas en: $MusicRoot" -ForegroundColor Yellow
Write-Host "Cada MP3: audio HQ + portada embedida + metadatos ID3" -ForegroundColor Cyan