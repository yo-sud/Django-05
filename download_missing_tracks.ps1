#!/usr/bin/env pwsh
# Descarga tracks FALTANTES específicos

$MusicRoot = "$env:USERPROFILE\Music\Arctic Monkeys"
$YTDLP = "yt-dlp"
$FFMPEG = "$env:USERPROFILE\ffmpeg\ffmpeg-master-latest-win64-gpl\bin"

$baseArgs = @(
    "--extract-audio", "--audio-format", "mp3", "--audio-quality", "0",
    "--embed-metadata", "--embed-thumbnail", "--write-thumbnail",
    "--convert-thumbnails", "jpg", "--add-metadata",
    "--parse-metadata", "artist:Arctic Monkeys",
    "--ignore-errors", "--no-overwrites",
    "--sleep-interval", "3", "--max-sleep-interval", "6",
    "--ffmpeg-location", $FFMPEG
)

function DL($folder, $name, $query) {
    Write-Host "  $name" -ForegroundColor Gray
    $args = @($baseArgs) + @("--output", "$MusicRoot\$folder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch1:$query"
}

Write-Host "`n=== B-SIDES PEDIDOS ===" -ForegroundColor Cyan

# Too Much to Ask
DL "Suck It and See" "Too Much to Ask" 'Arctic Monkeys "Too Much to Ask" official audio'

# The Bakery
DL "Suck It and See" "The Bakery" 'Arctic Monkeys "The Bakery" official audio'

# 2. FAVOURITE WORST NIGHTMARE (álbum completo)
Write-Host "`n=== Favourite Worst Nightmare ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$MusicRoot\Favourite Worst Nightmare" | Out-Null

$fwnTracks = @(
    "Brianstorm",
    "Teddy Picker",
    "D Is for Dangerous",
    "Balaclava",
    "Fluorescent Adolescent",
    "Only Ones Who Know",
    "Do Me a Favour",
    "This House Is a Circus",
    "If You Were There Beware",
    "The Bad Thing",
    "Old Yellow Bricks",
    "505"
)
foreach ($t in $fwnTracks) {
    DL "Favourite Worst Nightmare" $t "Arctic Monkeys $t official video"
}

# B-Sides de FWN
Write-Host "`n=== B-Sides Favourite Worst Nightmare ===" -ForegroundColor Magenta
DL "Favourite Worst Nightmare" "The Bakery" 'Arctic Monkeys "The Bakery" official audio'
DL "Favourite Worst Nightmare" "Plastic Tramp" 'Arctic Monkeys "Plastic Tramp" official audio'
DL "Favourite Worst Nightmare" "Nettles" 'Arctic Monkeys "Nettles" official audio'
DL "Favourite Worst Nightmare" "Da Frame 2R" 'Arctic Monkeys "Da Frame 2R" official audio'
DL "Favourite Worst Nightmare" "Matador" 'Arctic Monkeys "Matador" official audio'
DL "Favourite Worst Nightmare" "If You Were There Beware" 'Arctic Monkeys "If You Were There Beware" official audio'

Write-Host "`n=== ¡COMPLETADO! ===" -ForegroundColor Green