#!/usr/bin/env pwsh
# Descarga SOLO música oficial de Arctic Monkeys
# Usa playlists oficiales del canal + búsquedas "Official Audio" precisas
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

function Download-Search {
    param([string]$Name, [string]$Query, [string]$Folder)
    Write-Host "`n=== $Name ===" -ForegroundColor Cyan
    $args = @($baseArgs) + @("--output", "$MusicRoot\$Folder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch20:$Query"
}

# 1. THE CAR - Playlist oficial del canal
Download-Playlist "The Car (Official Channel Playlist)" `
    "https://www.youtube.com/playlist?list=PLXboAJo1ui6EhhF6C0_nYsrY8Am8pO2QK" `
    "The Car"

# 2. TRANQUILITY BASE HOTEL & CASINO - Playlist oficial del canal
Download-Playlist "Tranquility Base Hotel & Casino (Official Channel Playlist)" `
    "https://www.youtube.com/playlist?list=PLXboAJo1ui6GFhaGrUFrHAcDgzeLnVyon" `
    "Tranquility Base Hotel & Casino"

# 3. AM - Búsqueda precisa: solo "Official Audio" tracks del álbum AM
Download-Search "AM (Official Audio tracks)" `
    'Arctic Monkeys "Official Audio" AM album Do I Wanna Know OR R U Mine OR One For The Road OR Arabella OR No 1 Party Anthem OR Mad Sounds OR Fireside OR Knee Socks OR I Wanna Be Yours OR Snap Out Of It OR Stop The World OR Youre So Dark' `
    "AM"

# 4. HUMBUG - Búsqueda precisa: solo "Official Audio/Video" tracks del álbum Humbug
Download-Search "Humbug (Official Audio/Video tracks)" `
    'Arctic Monkeys "Official" Humbug album Crying Lightning OR Cornerstone OR My Propeller OR Pretty Visitors OR Dangerous Animals OR Secret Door OR Potion Approaching OR Fire And The Thud OR Dance Little Liar OR Jewellers Hands' `
    "Humbug"

# 5. SUCK IT AND SEE - Búsqueda precisa: solo "Official Audio/Video" tracks
Download-Search "Suck It And See (Official Audio/Video tracks)" `
    'Arctic Monkeys "Official" "Suck It And See" album Dont Sit Down OR Black Treacle OR Piledriver Waltz OR Love Is A Laserquest OR Thats Where Youre Wrong OR Library Pictures OR Shes Thunderstorms OR Reckless Serenade OR Evil Twin OR Hellcat Spangled' `
    "Suck It and See"

# B-SIDES: Búsquedas específicas con "official audio" para filtrar basura
$bSideQueries = @(
    @("Suck It and See B-sides", 'Arctic Monkeys "Suck It And See" B-side official audio', "Suck It and See"),
    @("Humbug B-sides", 'Arctic Monkeys Humbug B-side official audio', "Humbug"),
    @("AM B-sides", 'Arctic Monkeys AM B-side official audio', "AM"),
    @("TBHC B-sides", 'Arctic Monkeys "Tranquility Base Hotel" B-side official audio', "Tranquility Base Hotel & Casino"),
    @("The Car B-sides", 'Arctic Monkeys "The Car" B-side official audio', "The Car")
)

foreach ($q in $bSideQueries) {
    Write-Host "`n=== $($q[0]) ===" -ForegroundColor Magenta
    $args = @($baseArgs) + @("--output", "$MusicRoot\$($q[2])\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch15:$($q[1])"
}

Write-Host "`n=== ¡COMPLETADO! ===" -ForegroundColor Green
Write-Host "Música en: $MusicRoot" -ForegroundColor Yellow
Write-Host "Cada MP3: audio HQ + portada embedida + metadatos ID3" -ForegroundColor Cyan