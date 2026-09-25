#!/usr/bin/env pwsh
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

Write-Host "=== B-SIDES PEDIDOS ===" -ForegroundColor Cyan
DL "Suck It and See" "Light Before" 'Arctic Monkeys Light Before official audio'
DL "Suck It and See" "Catapult" 'Arctic Monkeys Catapult official audio'

Write-Host "`n=== COVERS ===" -ForegroundColor Magenta
DL "Suck It and See" "Feels Like We Only Go Backwards Tame Impala Cover" 'Alex Turner Feels Like We Only Go Backwards Tame Impala cover'

Write-Host "`n=== ALEX TURNER SUBMARINE EP ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$MusicRoot\Alex Turner - Submarine" | Out-Null
$st = @(
    "Stuck On The Puzzle",
    "Piledriver Waltz",
    "Hiding Tonight",
    "Glass In The Park",
    "It Is Hard To Get Around The Wind",
    "Stuck On The Puzzle Reprise"
)
foreach ($t in $st) { DL "Alex Turner - Submarine" $t "Alex Turner $t Submarine EP official audio" }

Write-Host "`n=== OTROS B-SIDES ===" -ForegroundColor Magenta
DL "Suck It and See" "Scummy" 'Arctic Monkeys Scummy official audio'
DL "Suck It and See" "The Blond-O-Sonic Shimmer Trap" 'Arctic Monkeys "Blond-O-Sonic Shimmer Trap" official audio'
DL "Suck It and See" "I.D.S.T." 'Arctic Monkeys "I.D.S.T." official audio'
DL "Suck It and See" "Bad Woman" 'Arctic Monkeys "Bad Woman" official audio'
DL "Humbug" "Nettles" 'Arctic Monkeys Nettles official audio'
DL "Humbug" "Plastic Tramp" 'Arctic Monkeys "Plastic Tramp" official audio'
DL "Humbug" "Da Frame 2R" 'Arctic Monkeys "Da Frame 2R" official audio'

Write-Host "`nCOMPLETADO" -ForegroundColor Green