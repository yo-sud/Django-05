#!/usr/bin/env pwsh
# Descarga SOLO música oficial de The Strokes - 6 álbumes + B-sides
# Audio HQ (MP3 V0) + portada embedida + metadatos ID3

$MusicRoot = "$env:USERPROFILE\Music\The Strokes"
$YTDLP = "yt-dlp"
$FFMPEG = "$env:USERPROFILE\ffmpeg\ffmpeg-master-latest-win64-gpl\bin"

$folders = @(
    "Is This It",
    "Room on Fire",
    "First Impressions of Earth",
    "Angles",
    "Comedown Machine",
    "The New Abnormal"
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
    "--parse-metadata", "artist:The Strokes",
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
    $query = "The Strokes $TrackName Official Video"
    $args = @($baseArgs) + @("--output", "$MusicRoot\$AlbumFolder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch1:$query"
}

# 1. OFFICIAL MUSIC VIDEOS PLAYLIST (contains tracks from all albums)
Download-Playlist "The Strokes Official Music Videos (All Albums)" `
    "https://www.youtube.com/playlist?list=PLiJs4u3SwK38z1O4hXricA9sJxk7Zz7I5" `
    "Is This It"

# 2. THE NEW ABNORMAL - Specific album playlist
Download-Playlist "The New Abnormal (Official Playlist)" `
    "https://www.youtube.com/playlist?list=PLiJs4u3SwK3_1b_te_QOXK4V5saHWK-eZ" `
    "The New Abnormal"

# 3. THE SINGLES VOLUME 01 - B-sides/rarities
Download-Playlist "The Singles Volume 01" `
    "https://www.youtube.com/playlist?list=PLiJs4u3SwK3-EkdeXlrfH-y8Awjb8L7Ek" `
    "Is This It"

# 4. IS THIS IT (2001) - Track by track
$itiTracks = @(
    "Is This It",
    "The Modern Age",
    "Soma",
    "Barely Legal",
    "Someday",
    "Alone Together",
    "Last Nite",
    "Hard To Explain",
    "When It Started",
    "Trying Your Luck",
    "Take It Or Leave It"
)
Write-Host "`n=== Is This It (Tracks) ===" -ForegroundColor Cyan
foreach ($t in $itiTracks) { Download-Track "Is This It" $t }

# 5. ROOM ON FIRE (2003) - Track by track
$rofTracks = @(
    "What Ever Happened",
    "Reptilia",
    "Automatic Stop",
    "12:51",
    "You Talk Way Too Much",
    "Between Love & Hate",
    "Meet Me In The Bathroom",
    "Under Control",
    "The Way It Is",
    "I Can't Win",
    "I Can't Lose"
)
Write-Host "`n=== Room on Fire (Tracks) ===" -ForegroundColor Cyan
foreach ($t in $rofTracks) { Download-Track "Room on Fire" $t }

# 6. FIRST IMPRESSIONS OF EARTH (2006) - Track by track
$fioeTracks = @(
    "You Only Live Once",
    "Juicebox",
    "Heart In A Cage",
    "Razorblade",
    "On The Other Side",
    "Vision Of Division",
    "Ask Me Anything",
    "Electricityscape",
    "Killing Lies",
    "Fear Of Sleep",
    "Ize Of The World",
    "Even The Worst",
    "Red Light"
)
Write-Host "`n=== First Impressions of Earth (Tracks) ===" -ForegroundColor Cyan
foreach ($t in $fioeTracks) { Download-Track "First Impressions of Earth" $t }

# 7. ANGLES (2011) - Track by track
$anglesTracks = @(
    "Machu Picchu",
    "Under Cover Of Darkness",
    "Two Kinds Of Happiness",
    "You're So Right",
    "Taken For A Fool",
    "Games",
    "Call Me Back",
    "Gratisfaction",
    "Metabolism",
    "Life Is Simple In The Moonlight"
)
Write-Host "`n=== Angles (Tracks) ===" -ForegroundColor Cyan
foreach ($t in $anglesTracks) { Download-Track "Angles" $t }

# 8. COMEDOWN MACHINE (2013) - Track by track
$cmTracks = @(
    "Tap Out",
    "All The Time",
    "One Way Trigger",
    "Welcome To Japan",
    "80's Comedown Machine",
    "50/50",
    "Slow Animals",
    "Partners In Crime",
    "Chances",
    "Happy Ending",
    "Call It Fate Call It Karma"
)
Write-Host "`n=== Comedown Machine (Tracks) ===" -ForegroundColor Cyan
foreach ($t in $cmTracks) { Download-Track "Comedown Machine" $t }

# 9. FUTURE PRESENT PAST EP (2016)
$fppTracks = @(
    "OBLIVIUS",
    "Drag Queen",
    "Threat Of Joy"
)
Write-Host "`n=== Future Present Past EP ===" -ForegroundColor Cyan
foreach ($t in $fppTracks) { Download-Track "Comedown Machine" $t }

# B-SIDES / RARITIES
$bSides = @(
    @("B-Sides & Rarities", 'The Strokes B-side official audio', "Is This It"),
    @("Demis & Unreleased", 'The Strokes demo unreleased official', "Is This It")
)

foreach ($q in $bSides) {
    Write-Host "`n=== $($q[0]) ===" -ForegroundColor Magenta
    $args = @($baseArgs) + @("--output", "$MusicRoot\$($q[2])\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch10:$($q[1])"
}

Write-Host "`n=== ¡COMPLETADO! ===" -ForegroundColor Green
Write-Host "Música en: $MusicRoot" -ForegroundColor Yellow
Write-Host "Cada MP3: audio HQ + portada embedida + metadatos ID3" -ForegroundColor Cyan