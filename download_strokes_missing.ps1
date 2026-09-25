#!/usr/bin/env pwsh
$MusicRoot = "$env:USERPROFILE\Music\The Strokes"
$YTDLP = "yt-dlp"
$FFMPEG = "$env:USERPROFILE\ffmpeg\ffmpeg-master-latest-win64-gpl\bin"

$baseArgs = @(
    "--extract-audio", "--audio-format", "mp3", "--audio-quality", "0",
    "--embed-metadata", "--embed-thumbnail", "--write-thumbnail",
    "--convert-thumbnails", "jpg", "--add-metadata",
    "--parse-metadata", "artist:The Strokes",
    "--ignore-errors", "--no-overwrites",
    "--sleep-interval", "3", "--max-sleep-interval", "6",
    "--ffmpeg-location", $FFMPEG
)

function DL($folder, $name, $query) {
    Write-Host "  $name" -ForegroundColor Gray
    $args = @($baseArgs) + @("--output", "$MusicRoot\$folder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch1:$query"
}

Write-Host "=== Angles - Missing ===" -ForegroundColor Cyan
DL "Angles" "Machu Picchu" "The Strokes Machu Picchu official video"

Write-Host "`n=== First Impressions of Earth - Missing ===" -ForegroundColor Cyan
DL "First Impressions of Earth" "Ize of the World" "The Strokes Ize of the World official video"

Write-Host "`n=== Room on Fire - Missing ===" -ForegroundColor Cyan
DL "Room on Fire" "Fruit of the Congo" "The Strokes Fruit of the Congo official audio"

Write-Host "`n=== B-Sides ===" -ForegroundColor Magenta
DL "Is This It" "Going Shopping" 'The Strokes "Going Shopping" official audio'
DL "Is This It" "Lonely in the Future" 'The Strokes "Lonely in the Future" official audio'
DL "Angles" "OBLIVIUS" 'The Strokes OBLIVIUS official audio'
DL "Angles" "Drag Queen" 'The Strokes Drag Queen official audio'
DL "Angles" "Threat of Joy" 'The Strokes "Threat of Joy" official audio'
DL "Is This It" "Hawaii" 'The Strokes Hawaii official audio'
DL "Is This It" "Mercy Mercy Me" 'The Strokes "Mercy Mercy Me" official audio'
DL "Is This It" "I'll Try Anything Once" 'The Strokes "I''ll Try Anything Once" official audio'

Write-Host "`nCOMPLETADO" -ForegroundColor Green