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

Write-Host "=== DEBUT ALBUM (2006) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$MusicRoot\Whatever People Say I Am" | Out-Null
$debut = @(
    "The View From The Afternoon",
    "I Bet You Look Good On The Dancefloor",
    "Fake Tales of San Francisco",
    "Dancing Shoes",
    "You Probably Couldnt See For The Lights But You Were Staring Straight At Me",
    "Still Take You Home",
    "Riot Van",
    "Red Light Indicates Doors Are Secured",
    "Mardy Bum",
    "Perhaps Vampires Is A Bit Strong But",
    "When The Sun Goes Down",
    "From The Ritz To The Rubble",
    "A Certain Romance"
)
foreach ($t in $debut) { DL "Whatever People Say I Am" $t "Arctic Monkeys $t official video" }

Write-Host "`n=== Favourite Worst Nightmare - Missing ===" -ForegroundColor Cyan
$fwn = @("Brianstorm", "Only Ones Who Know", "If You Were There Beware")
foreach ($t in $fwn) { DL "Favourite Worst Nightmare" $t "Arctic Monkeys $t official video" }

Write-Host "`n=== Humbug - Missing ===" -ForegroundColor Cyan
$humbug = @("Pretty Visitors", "The Jewellers Hands")
foreach ($t in $humbug) { DL "Humbug" $t "Arctic Monkeys $t official video" }

Write-Host "`n=== Suck It and See - Missing ===" -ForegroundColor Cyan
$siast = @(
    "Dont Sit Down Cause Ive Moved Your Chair",
    "Reckless Serenade",
    "Love Is a Laserquest",
    "She Is Thunderstorms",
    "Thats Where Youre Wrong"
)
foreach ($t in $siast) { DL "Suck It and See" $t "Arctic Monkeys $t official video" }

Write-Host "`n=== AM - Missing ===" -ForegroundColor Cyan
$am = @("No 1 Party Anthem", "Why Do You Only Call Me When Youre High", "Knee Socks", "I Wanna Be Yours")
foreach ($t in $am) { DL "AM" $t "Arctic Monkeys $t official video" }

Write-Host "`n=== TBHC - Missing ===" -ForegroundColor Cyan
$tbhc = @("Tranquility Base Hotel Casino", "The Worlds First Ever Monster Truck Front Flip")
foreach ($t in $tbhc) { DL "Tranquility Base Hotel & Casino" $t "Arctic Monkeys $t official video" }

Write-Host "`n=== The Car - Missing ===" -ForegroundColor Cyan
$car = @("Thered Better Be a Mirrorball", "I Aint Quite Where I Think I Am")
foreach ($t in $car) { DL "The Car" $t "Arctic Monkeys $t official video" }

Write-Host "`n=== B-Sides Missing ===" -ForegroundColor Magenta
DL "Favourite Worst Nightmare" "Da Frame 2R" "Arctic Monkeys Da Frame 2R official audio"
DL "Suck It and See" "Light Before" "Arctic Monkeys Light Before official audio"
DL "Suck It and See" "I.D.S.T." "Arctic Monkeys I.D.S.T. official audio"
DL "AM" "Youre So Dark" "Arctic Monkeys Youre So Dark official audio"

Write-Host "`nCOMPLETADO" -ForegroundColor Green