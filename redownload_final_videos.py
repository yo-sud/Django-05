#!/usr/bin/env python3
# Re-descargar tracks de Arctic Monkeys que son de video como OFFICIAL AUDIO

import subprocess
import os

MUSIC_ROOT = r"C:\Users\usuario\Music\Arctic Monkeys"
YTDLP = "yt-dlp"
FFMPEG = r"C:\Users\usuario\ffmpeg\ffmpeg-master-latest-win64-gpl\bin"

base_args = [
    "--extract-audio", "--audio-format", "mp3", "--audio-quality", "0",
    "--embed-metadata", "--embed-thumbnail", "--write-thumbnail",
    "--convert-thumbnails", "jpg", "--add-metadata",
    "--parse-metadata", "artist:Arctic Monkeys",
    "--ignore-errors", "--no-overwrites",
    "--sleep-interval", "3", "--max-sleep-interval", "6",
    "--ffmpeg-location", FFMPEG
]

def re_dl(folder, track_name, query):
    print(f"  Re-descargando: {track_name}")
    folder_path = os.path.join(MUSIC_ROOT, folder)
    for f in os.listdir(folder_path):
        if track_name.lower() in f.lower() and f.endswith(".mp3"):
            os.remove(os.path.join(folder_path, f))
            safe_name = f.encode('ascii', 'replace').decode('ascii')
            print(f"  Eliminado: {safe_name}")
    
    args = [YTDLP] + base_args + ["--output", os.path.join(MUSIC_ROOT, folder, "%(title)s [%(id)s].%(ext)s"), f"ytsearch1:{query}"]
    subprocess.run(args, check=False)

tracks = [
    # Favourite Worst Nightmare - tracks from video
    ("Favourite Worst Nightmare", "505", "Arctic Monkeys 505 official audio"),
    ("Favourite Worst Nightmare", "D is for dangerous", 'Arctic Monkeys "D is for dangerous" official audio'),
    ("Favourite Worst Nightmare", "Teddy Picker", 'Arctic Monkeys "Teddy Picker" official audio'),
    ("Favourite Worst Nightmare", "Old Yellow Bricks", 'Arctic Monkeys "Old Yellow Bricks" official audio'),
    ("Favourite Worst Nightmare", "Only Ones Who Know", 'Arctic Monkeys "Only Ones Who Know" official audio'),
    ("Favourite Worst Nightmare", "The Bad Thing", 'Arctic Monkeys "The Bad Thing" official audio'),
    ("Favourite Worst Nightmare", "This House is a Circus", 'Arctic Monkeys "This House is a Circus" official audio'),
    
    # AM - remaining video tracks
    ("AM", "Do I Wanna Know", 'Arctic Monkeys "Do I Wanna Know" official audio'),
    ("AM", "One For The Road", 'Arctic Monkeys "One For The Road" official audio'),
    ("AM", "Why Do You Only Call Me When Youre High", 'Arctic Monkeys "Why Do You Only Call Me When Youre High" official audio'),
    
    # Humbug - Cornerstone
    ("Humbug", "Cornerstone", 'Arctic Monkeys "Cornerstone" official audio'),
    
    # Suck It and See - video tracks
    ("Suck It and See", "Do I Wanna Know", 'Arctic Monkeys "Do I Wanna Know" official audio'),
    ("Suck It and See", "Don't Sit Down Cause Ive Moved Your Chair", 'Arctic Monkeys "Don\'t Sit Down Cause Ive Moved Your Chair" official audio'),
    ("Suck It and See", "Evil Twin", 'Arctic Monkeys "Evil Twin" official audio'),
    ("Suck It and See", "The Hellcat Spangled Shalalala", 'Arctic Monkeys "The Hellcat Spangled Shalalala" official audio'),
    ("Suck It and See", "You And I", 'Arctic Monkeys "You And I" official audio'),
    
    # The Car
    ("The Car", "There'd Better Be A Mirrorball", 'Arctic Monkeys "There\'d Better Be A Mirrorball" official audio'),
    
    # TBHC
    ("Tranquility Base Hotel & Casino", "Tranquility Base Hotel Casino", 'Arctic Monkeys "Tranquility Base Hotel Casino" official audio'),
    
    # Whatever People Say I Am
    ("Whatever People Say I Am", "The View From The Afternoon", 'Arctic Monkeys "The View From The Afternoon" official audio'),
    ("Whatever People Say I Am", "When The Sun Goes Down", 'Arctic Monkeys "When The Sun Goes Down" official audio'),
]

base_args = [
    "--extract-audio", "--audio-format", "mp3", "--audio-quality", "0",
    "--embed-metadata", "--embed-thumbnail", "--write-thumbnail",
    "--convert-thumbnails", "jpg", "--add-metadata",
    "--parse-metadata", "artist:Arctic Monkeys",
    "--ignore-errors", "--no-overwrites",
    "--sleep-interval", "3", "--max-sleep-interval", "6",
    "--ffmpeg-location", r"C:\Users\usuario\ffmpeg\ffmpeg-master-latest-win64-gpl\bin"
]

MUSIC_ROOT = r"C:\Users\usuario\Music\Arctic Monkeys"
YTDLP = "yt-dlp"

for folder, track_name, query in tracks:
    print(f"\n=== {folder} - {track_name} ===")
    folder_path = os.path.join(MUSIC_ROOT, folder)
    for f in os.listdir(folder_path):
        if track_name.lower() in f.lower() and f.endswith(".mp3"):
            os.remove(os.path.join(folder_path, f))
            safe_name = f.encode('ascii', 'replace').decode('ascii')
            print(f"  Eliminado: {safe_name}")
    
    args = [YTDLP] + base_args + ["--output", os.path.join(MUSIC_ROOT, folder, "%(title)s [%(id)s].%(ext)s"), f"ytsearch1:{query}"]
    subprocess.run(args, check=False)

print("\n=== COMPLETADO ===")