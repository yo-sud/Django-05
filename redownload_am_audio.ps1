#!/usr/bin/env pwsh
# Re-descargar tracks de Arctic Monkeys como OFFICIAL AUDIO (no video)

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

function ReDL($folder, $trackName, $query) {
    Write-Host "  Re-descargando: $trackName" -ForegroundColor Gray
    # Primero eliminar el archivo video existente
    $existing = Get-ChildItem "$MusicRoot\$folder" -Filter "*$trackName*" -File
    if ($existing) {
        $existing | Remove-Item -Force
        Write-Host "    Eliminado archivo anterior" -ForegroundColor Yellow
    }
    $args = @($baseArgs) + @("--output", "$MusicRoot\$folder\%(title)s [%(id)s].%(ext)s")
    & $YTDLP @args "ytsearch1:$query"
}

Write-Host "=== Re-descargar OFFICIAL AUDIO ===" -ForegroundColor Cyan

# AM - Tracks con video
$am_video = @(
    @("AM", "Arabella", 'Arctic Monkeys Arabella official audio'),
    @("AM", "Do I Wanna Know", 'Arctic Monkeys "Do I Wanna Know" official audio'),
    @("AM", "One For The Road", 'Arctic Monkeys "One For The Road" official audio'),
    @("AM", "R U Mine", 'Arctic Monkeys "R U Mine" official audio'),
    @("AM", "Snap Out Of It", 'Arctic Monkeys "Snap Out Of It" official audio'),
    @("AM", "Why Do You Only Call Me When Youre High", 'Arctic Monkeys "Why Do You Only Call Me When Youre High" official audio'),
)

# Favourite Worst Nightmare
$fwn_video = @(
    @("Favourite Worst Nightmare", "505", 'Arctic Monkeys 505 official audio'),
    @("Favourite Worst Nightmare", "Fluorescent Adolescent", 'Arctic Monkeys "Fluorescent Adolescent" official audio'),
    @("Favourite Worst Nightmare", "Old Yellow Bricks", 'Arctic Monkeys "Old Yellow Bricks" official audio'),
    @("Favourite Worst Nightmare", "Teddy Picker", 'Arctic Monkeys "Teddy Picker" official audio'),
)

# Humbug
$humbug_video = @(
    @("Humbug", "Cornerstone", 'Arctic Monkeys "Cornerstone" official audio'),
    @("Humbug", "Crying Lightning", 'Arctic Monkeys "Crying Lightning" official audio'),
    @("Humbug", "My Propeller", 'Arctic Monkeys "My Propeller" official audio'),
)

# Suck It and See
$siast_video = @(
    @("Suck It and See", "Black Treacle", 'Arctic Monkeys "Black Treacle" official audio'),
    @("Suck It and See", "Brick By Brick", 'Arctic Monkeys "Brick By Brick" official audio'),
    @("Suck It and See", "Don't Sit Down Cause I've Moved Your Chair", 'Arctic Monkeys "Don't Sit Down Cause Ive Moved Your Chair" official audio'),
    @("Suck It and See", "Evil Twin", 'Arctic Monkeys "Evil Twin" official audio'),
    @("Suck It and See", "She's Thunderstorms", 'Arctic Monkeys "She's Thunderstorms" official audio'),
    @("Suck It and See", "The Hellcat Spangled Shalalala", 'Arctic Monkeys "The Hellcat Spangled Shalalala" official audio'),
)

# The Car
$car_video = @(
    @("The Car", "Body Paint", 'Arctic Monkeys "Body Paint" official audio'),
    @("The Car", "I Ain't Quite Where I Think I Am", 'Arctic Monkeys "I Ain't Quite Where I Think I Am" official audio'),
    @("The Car", "Sculptures Of Anything Goes", 'Arctic Monkeys "Sculptures Of Anything Goes" official audio'),
    @("The Car", "There'd Better Be A Mirrorball", 'Arctic Monkeys "There'd Better Be A Mirrorball" official audio'),
)

# TBHC
$tbhc_video = @(
    @("Tranquility Base Hotel & Casino", "Four Out Of Five", 'Arctic Monkeys "Four Out Of Five" official audio'),
    @("Tranquility Base Hotel & Casino", "Tranquility Base Hotel Casino", 'Arctic Monkeys "Tranquility Base Hotel Casino" official audio'),
)

# Whatever People Say I Am
$debut_video = @(
    @("Whatever People Say I Am", "Fake Tales Of San Francisco", 'Arctic Monkeys "Fake Tales Of San Francisco" official audio'),
    @("Whatever People Say I Am", "I Bet You Look Good On The Dancefloor", 'Arctic Monkeys "I Bet You Look Good On The Dancefloor" official audio'),
    @("Whatever People Say I Am", "The View From The Afternoon", 'Arctic Monkeys "The View From The Afternoon" official audio'),
    @("Whatever People Say I Am", "When The Sun Goes Down", 'Arctic Monkeys "When The Sun Goes Down" official audio'),
)

$all_video = $am_video + $fwn_video + $humbug_video + $siast_video + $car_video + $tbhc_video + $debut_video

foreach ($t in $all_video) {
    ReDL $t[0] $t[1] $t[2]
}

Write-Host "`n=== COMPLETADO ===" -ForegroundColor Green