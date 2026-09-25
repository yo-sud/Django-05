#!/usr/bin/env pwsh
# Descarga tracks FALTANTES según comparación

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

# 1. DEBUT ALBUM - Whatever People Say I Am (2006)
Write-Host "`n=== Whatever People Say I Am (DEBUT) ===" -ForegroundColor Cyan
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

# 2. FAVOURITE WORST NIGHTMARE - Missing
Write-Host "`n=== Favourite Worst Nightmare - Missing ===" -ForegroundColor Cyan
$fwn_missing = @(
    "Brianstorm",
    "Only Ones Who Know",
    "If You Were There Beware"
)
foreach ($t in $fwn_missing) { DL "Favourite Worst Nightmare" $t "Arctic Monkeys $t official video" }

# 3. HUMBUG - Missing
Write-Host "`n=== Humbug - Missing ===" -ForegroundColor Cyan
$humbug_missing = @(
    "Pretty Visitors",
    "The Jewellers Hands"
)
foreach ($t in $humbug_missing) { DL "Humbug" $t "Arctic Monkeys $t official video" }

# 4. SUCK IT AND SEE - Missing
Write-Host "`n=== Suck It and See - Missing ===" -ForegroundColor Cyan
$siast_missing = @(
    "Dont Sit Down Cause Ive Moved Your Chair",
    "Reckless Serenade",
    "Love Is a Laserquest",
    "She Is Thunderstorms",
    "Thats Where Youre Wrong"
)
foreach ($t in $siast_missing) { DL "Suck It and See" $t "Arctic Monkeys $t official video" }

# 5. AM - Missing
Write-Host "`n=== AM - Missing ===" -ForegroundColor Cyan
$am_missing = @(
    "No 1 Party Anthem",
    "Why Do You Only Call Me When Youre High",
    "Knee Socks",
    "I Wanna Be Yours"
)
foreach ($t in $am_missing) { DL "AM" $t "Arctic Monkeys $t official video" }

# 6. TBHC - Missing
Write-Host "`n=== TBHC - Missing ===" -ForegroundColor Cyan
$tbhc_missing = @(
    "Tranquility Base Hotel Casino",
    "The Worlds First Ever Monster Truck Front Flip"
)
foreach ($t in $tbhc_missing) { DL "Tranquility Base Hotel & Casino" $t "Arctic Monkeys $t official video" }

# 7. THE CAR - Missing
Write-Host "`n=== The Car - Missing ===" -ForegroundColor Cyan
$car_missing = @(
    "Thered Better Be a Mirrorball",
    "I Aint Quite Where I Think I Am"
)
foreach ($t in $car_missing) { DL "The Car" $t "Arctic Monkeys $t official video" }

# 8. B-Sides Rarities - Missing
Write-Host "`n=== B-Sides Missing ===" -ForegroundColor Magenta
$bsides_missing = @(
    @("Favourite Worst Nightmare", "Da Frame 2R", 'Arctic Monkeys "Da Frame 2R" official audio'),
    @("Suck It and See", "Light Before", 'Arctic Monkeys "Light Before" official audio'),
    @("Suck It and See", "I.D.S.T.", 'Arctic Monkeys "I.D.S.T." official audio'),
    @("AM", "Youre So Dark", 'Arctic Monkeys "Youre So Dark" official audio'),
)
foreach ($b in $bsides_missing) { DL $b[0] $b[1] $b[2] }

Write-Host "`n=== ¡COMPLETADO! ===" -ForegroundColor Green