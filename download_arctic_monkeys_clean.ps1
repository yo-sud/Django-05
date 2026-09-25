#!/usr/bin/env pwsh
# Descarga SOLO música oficial de Arctic Monkeys - 5 álbumes + B-sides
# Audio HQ (MP3 V0) + portada embedida + metadatos ID3

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

function Download-Playlist {
    param([string]$AlbumName, [string]$PlaylistURL, [string]$Folder)
    Write-Host "`n=== $AlbumName ===" -ForegroundColor Cyan
    $args = @($baseArgs) + @("--output", "$MusicRoot\$Folder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args $PlaylistURL
}

function Download-Track {
    param([string]$AlbumFolder, [string]$TrackName)
    Write-Host "  $TrackName" -ForegroundColor Gray
    $query = "Arctic Monkeys $TrackName Official Video"
    $args = @($baseArgs) + @("--output", "$MusicRoot\$AlbumFolder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch1:$query"
}

# 1. THE CAR - Playlist oficial
Download-Playlist "The Car (Official Playlist)" `
    "https://www.youtube.com/playlist?list=PLXboAJo1ui6EhhF6C0_nYsrY8Am8pO2QK" `
    "The Car"

# 2. TRANQUILITY BASE HOTEL & CASINO - Playlist oficial
Download-Playlist "Tranquility Base Hotel & Casino (Official Playlist)" `
    "https://www.youtube.com/playlist?list=PLXboAJo1ui6GFhaGrUFrHAcDgzeLnVyon" `
    "Tranquility Base Hotel & Casino"

# 3. SUCK IT AND SEE - Tracks oficiales
$siastracks = @(
    "Don't Sit Down 'Cause I've Moved Your Chair",
    "Suck It And See",
    "The Hellcat Spangled Shalalala",
    "Black Treacle",
    "Brick By Brick",
    "Library Pictures",
    "All My Own Stunts",
    "Piledriver Waltz",
    "Love Is A Laserquest",
    "She's Thunderstorms",
    "That's Where You're Wrong",
    "Reckless Serenade",
    "Evil Twin"
)
Write-Host "`n=== Suck It And See (Tracks) ===" -ForegroundColor Cyan
foreach ($t in $siastracks) { Download-Track "Suck It and See" $t }

# 4. HUMBUG - Tracks oficiales
$humbugtracks = @(
    "Crying Lightning",
    "Cornerstone",
    "My Propeller",
    "Pretty Visitors",
    "Dangerous Animals",
    "Secret Door",
    "Potion Approaching",
    "Fire And The Thud",
    "Dance Little Liar",
    "The Jeweller's Hands"
)
Write-Host "`n=== Humbug (Tracks) ===" -ForegroundColor Cyan
foreach ($t in $humbugtracks) { Download-Track "Humbug" $t }

# 5. AM - Tracks oficiales
$amtracks = @(
    "Do I Wanna Know",
    "R U Mine",
    "One For The Road",
    "Arabella",
    "No 1 Party Anthem",
    "Mad Sounds",
    "Fireside",
    "Knee Socks",
    "I Wanna Be Yours",
    "Snap Out Of It",
    "Stop The World I Wanna Get Off With You",
    "You're So Dark"
)
Write-Host "`n=== AM (Tracks) ===" -ForegroundColor Cyan
foreach ($t in $amtracks) { Download-Track "AM" $t }

# B-SIDES - Búsquedas específicas
$bSides = @(
    @("Suck It and See B-sides", 'Arctic Monkeys "Suck It And See" B-side official audio', "Suck It and See"),
    @("Humbug B-sides", 'Arctic Monkeys Humbug B-side official audio', "Humbug"),
    @("AM B-sides", 'Arctic Monkeys AM B-side official audio', "AM"),
    @("TBHC B-sides", 'Arctic Monkeys "Tranquility Base Hotel" B-side official audio', "Tranquility Base Hotel & Casino"),
    @("The Car B-sides", 'Arctic Monkeys "The Car" B-side official audio', "The Car")
)

foreach ($q in $bSides) {
    Write-Host "`n=== $($q[0]) ===" -ForegroundColor Magenta
    $args = @($baseArgs) + @("--output", "$MusicRoot\$($q[2])\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch5:$($q[1])"
}

Write-Host "`n=== ¡COMPLETADO! ===" -ForegroundColor Green
Write-Host "Música en: $MusicRoot" -ForegroundColor Yellow
Write-Host "Cada MP3: audio HQ + portada embedida + metadatos ID3" -ForegroundColor Cyan