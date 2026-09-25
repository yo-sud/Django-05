#!/usr/bin/env pwsh
# Descarga B-sides FALTANTES de Arctic Monkeys

$MusicRoot = "$env:USERPROFILE\Music\Arctic Monkeys"
$YTDLP = "yt-dlp"
$FFMPEG = "$env:USERPROFILE\ffmpeg\ffmpeg-master-latest-win64-gpl\bin"

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

function DL($folder, $name, $query) {
    Write-Host "  $name" -ForegroundColor Gray
    $args = @($baseArgs) + @("--output", "$MusicRoot\$folder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch1:$query"
}

Write-Host "`n=== B-SIDES FALTANTES ===" -ForegroundColor Cyan

# Suck It and See era
DL "Suck It and See" "The Afternoon's Hat" 'Arctic Monkeys "The Afternoon''s Hat" official audio'
DL "Suck It and See" "You And I" 'Arctic Monkeys "You And I" official audio'
DL "Suck It and See" "Bad Woman" 'Arctic Monkeys "Bad Woman" official audio'
DL "Suck It and See" "I.D.S.T." 'Arctic Monkeys "I.D.S.T." official audio'

# Humbug era
DL "Humbug" "No Buses" 'Arctic Monkeys "No Buses" official audio'
DL "Humbug" "Choo Choo" 'Arctic Monkeys "Choo Choo" official audio'
DL "Humbug" "Nettles" 'Arctic Monkeys "Nettles" official audio'
DL "Humbug" "Plastic Tramp" 'Arctic Monkeys "Plastic Tramp" official audio'

# AM era
DL "AM" "You''re So Dark" 'Arctic Monkeys "You''re So Dark" official audio'
DL "AM" "Stop The World I Wanna Get Off With You" 'Arctic Monkeys "Stop The World I Wanna Get Off With You" official audio'
DL "AM" "Anyways" 'Arctic Monkeys "Anyways" official audio'
DL "AM" "Fireside" 'Arctic Monkeys "Fireside" official audio'
DL "AM" "Temptation Greets You Like Your Naughty Friend" 'Arctic Monkeys "Temptation Greets You Like Your Naughty Friend" official audio'
DL "AM" "2013" 'Arctic Monkeys "2013" official audio'

# Favourite Worst Nightmare era
DL "Humbug" "Da Frame 2R" 'Arctic Monkeys "Da Frame 2R" official audio'
DL "Humbug" "Matador" 'Arctic Monkeys "Matador" official audio'
DL "Humbug" "If You Were There Beware" 'Arctic Monkeys "If You Were There Beware" official audio'
DL "Humbug" "Balaclava" 'Arctic Monkeys "Balaclava" official audio'

# TBHC
DL "Tranquility Base Hotel & Casino" "The World''s First Ever Monster Truck Front Flip" 'Arctic Monkeys "The World''s First Ever Monster Truck Front Flip" official audio'

# The Car
DL "The Car" "Difficult To See" 'Arctic Monkeys "Difficult To See" official audio'

Write-Host "`n=== ¡COMPLETADO! ===" -ForegroundColor Green