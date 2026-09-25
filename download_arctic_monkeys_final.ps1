#!/usr/bin/env pwsh
# Descarga SOLO música oficial de Arctic Monkeys usando:
# - Playlists oficiales de álbum (The Car, TBHC)
# - Playlist "Official Videos" del canal (todas las oficiales)
# - Búsquedas precisas por track para Suck It And See, Humbug, AM
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
    Write-Host "`n=== $Name ===" -ForegroundColor Magenta
    $args = @($baseArgs) + @("--output", "$MusicRoot\$Folder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch10:$Query"
}

# 1. THE CAR - Playlist oficial del álbum
Download-Playlist "The Car (Official Album Playlist)" `
    "https://www.youtube.com/playlist?list=PLXboAJo1ui6EhhF6C0_nYsrY8Am8pO2QK" `
    "The Car"

# 2. TRANQUILITY BASE HOTEL & CASINO - Playlist oficial del álbum
Download-Playlist "Tranquility Base Hotel & Casino (Official Album Playlist)" `
    "https://www.youtube.com/playlist?list=PLXboAJo1ui6GFhaGrUFrHAcDgzeLnVyon" `
    "Tranquility Base Hotel & Casino"

# 3. OFFICIAL VIDEOS - Todas las oficiales del canal (filtramos después manualmente si hace falta)
Download-Playlist "Arctic Monkeys Official Videos (All Albums)" `
    "https://www.youtube.com/playlist?list=PLXboAJo1ui6GUpe12EdZVGUKaMpLxmEUn" `
    "AM"

# 4. SUCK IT AND SEE - Búsquedas por track (Official Video/Audio)
$siastracks = @(
    "Arctic Monkeys Don't Sit Down Cause I've Moved Your Chair Official Video",
    "Arctic Monkeys Suck It And See Official Video",
    "Arctic Monkeys The Hellcat Spangled Shalalala Official Video",
    "Arctic Monkeys Black Treacle Official Video",
    "Arctic Monkeys Brick By Brick Official Video",
    "Arctic Monkeys Library Pictures Official Video",
    "Arctic Monkeys All My Own Stunts Official Audio",
    "Arctic Monkeys Piledriver Waltz Official Audio",
    "Arctic Monkeys Love Is A Laserquest Official Audio",
    "Arctic Monkeys She's Thunderstorms Official Audio",
    "Arctic Monkeys That's Where You're Wrong Official Audio",
    "Arctic Monkeys Reckless Serenade Official Audio",
    "Arctic Monkeys Evil Twin Official Video",
    "Arctic Monkeys Baby I'm Yours Official Audio"
)

foreach ($track in $siastracks) {
    Download-Search "Suck It And See: $track" $track "Suck It and See"
}

# 5. HUMBUG - Búsquedas por track
$humbugtracks = @(
    "Arctic Monkeys Crying Lightning Official Video",
    "Arctic Monkeys Cornerstone Official Video",
    "Arctic Monkeys My Propeller Official Video",
    "Arctic Monkeys Pretty Visitors Official Video",
    "Arctic Monkeys Dangerous Animals Official Video",
    "Arctic Monkeys Secret Door Official Video",
    "Arctic Monkeys Potion Approaching Official Audio",
    "Arctic Monkeys Fire And The Thud Official Audio",
    "Arctic Monkeys Dance Little Liar Official Audio",
    "Arctic Monkeys The Jeweller's Hands Official Audio"
)

foreach ($track in $humbugtracks) {
    Download-Search "Humbug: $track" $track "Humbug"
}

# 6. AM - Búsquedas por track
$amtracks = @(
    "Arctic Monkeys Do I Wanna Know Official Video",
    "Arctic Monkeys R U Mine Official Video",
    "Arctic Monkeys One For The Road Official Video",
    "Arctic Monkeys Arabella Official Video",
    "Arctic Monkeys No 1 Party Anthem Official Audio",
    "Arctic Monkeys Mad Sounds Official Audio",
    "Arctic Monkeys Fireside Official Audio",
    "Arctic Monkeys Knee Socks Official Audio",
    "Arctic Monkeys I Wanna Be Yours Official Audio",
    "Arctic Monkeys Snap Out Of It Official Video",
    "Arctic Monkeys Stop The World I Wanna Get Off With You Official Audio",
    "Arctic Monkeys You're So Dark Official Audio"
)

foreach ($track in $amtracks) {
    Download-Search "AM: $track" $track "AM"
}

# 7. B-SIDES ESPECÍFICOS - Solo búsquedas muy específicas
$bSideQueries = @(
    @("Suck It and See B-sides", 'Arctic Monkeys "Suck It And See" B-side official audio', "Suck It and See"),
    @("Humbug B-sides", 'Arctic Monkeys Humbug B-side official audio', "Humbug"),
    @("AM B-sides", 'Arctic Monkeys AM B-side official audio', "AM"),
    @("TBHC B-sides", 'Arctic Monkeys "Tranquility Base Hotel" B-side official audio', "Tranquility Base Hotel & Casino"),
    @("The Car B-sides", 'Arctic Monkeys "The Car" B-side official audio', "The Car")
)

foreach ($q in $bSideQueries) {
    Download-Search $q[0] $q[1] $q[2]
}

Write-Host "`n=== ¡COMPLETADO! ===" -ForegroundColor Green
Write-Host "Música en: $MusicRoot" -ForegroundColor Yellow
Write-Host "Cada MP3: audio HQ + portada embedida + metadatos ID3" -ForegroundColor Cyan