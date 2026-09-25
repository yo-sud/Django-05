#!/usr/bin/env python3
# Embed lyrics into MP3 files using LRCLIB API (free, no key needed)
# Run from: C:\Users\usuario\Documents\Default Project
# Requires: pip install mutagen requests

import os
import re
import sys
import time
import requests
from pathlib import Path
from mutagen.mp3 import MP3
from mutagen.id3 import ID3, USLT, SYLT, Encoding

MUSIC_ROOT = Path("C:/Users/usuario/Music/Arctic Monkeys")
LRCLIB_API = "https://lrclib.net/api/search"

def clean_title(title):
    """Remove ID suffix [abc123] and clean for search"""
    title = re.sub(r'\s*\[[A-Za-z0-9_-]{11}\]\.mp3$', '', title)
    title = re.sub(r'\(Official (Video|Audio)\)', '', title, flags=re.IGNORECASE)
    title = re.sub(r'\[.*?\]', '', title)
    return title.strip()

def search_lyrics(artist, title):
    """Search LRCLIB for synced/unsynced lyrics"""
    params = {
        "artist_name": artist,
        "track_name": title,
        "album_name": ""
    }
    try:
        r = requests.get(LRCLIB_API, params=params, timeout=10)
        if r.status_code == 200:
            results = r.json()
            if results:
                for res in results:
                    if res.get("syncedLyrics"):
                        return res["syncedLyrics"], True
                for res in results:
                    if res.get("plainLyrics"):
                        return res["plainLyrics"], False
    except Exception as e:
        print(f"  API error: {e}")
    return None, False

def embed_lyrics(mp3_path, lyrics, synced=False):
    """Embed lyrics into MP3 ID3 tags"""
    try:
        audio = MP3(mp3_path, ID3=ID3)
        if audio.tags is None:
            audio.add_tags()
        
        if synced:
            sylt_data = []
            for line in lyrics.split('\n'):
                match = re.match(r'\[(\d{2}):(\d{2})\.(\d{2,3})\](.*)', line)
                if match:
                    m, s, ms, text = match.groups()
                    total_ms = (int(m) * 60 + int(s)) * 1000 + int(ms.ljust(3, '0')[:3])
                    sylt_data.append((text.strip(), total_ms))
            
            if sylt_data:
                audio.tags.add(SYLT(
                    encoding=Encoding.UTF8,
                    lang="spa",
                    format=2,
                    type=1,
                    desc="",
                    text=sylt_data
                ))
        else:
            audio.tags.add(USLT(
                encoding=Encoding.UTF8,
                lang="spa",
                desc="",
                text=lyrics
            ))
        
        audio.save(v2_version=3)
        return True
    except Exception as e:
        print(f"  Embed error: {e}")
        return False

def process_folder(folder_path, artist="Arctic Monkeys"):
    mp3_files = list(folder_path.rglob("*.mp3"))
    print(f"\n{folder_path.name}: {len(mp3_files)} archivos")
    
    for mp3 in mp3_files:
        title = clean_title(mp3.name)
        safe_title = title[:60].encode('ascii', 'replace').decode('ascii')
        print(f"  {safe_title}...", end=" ")
        
        lyrics, synced = search_lyrics(artist, title)
        if lyrics:
            if embed_lyrics(mp3, lyrics, synced):
                print(f"OK {'SYNCED' if synced else 'PLAIN'}")
            else:
                print("embed failed")
        else:
            print("No lyrics found")
        
        time.sleep(0.5)

def main():
    print("=" * 60)
    print("EMBED LYRICS - Arctic Monkeys")
    print("=" * 60)
    
    if not MUSIC_ROOT.exists():
        print(f"No existe: {MUSIC_ROOT}")
        return
    
    albums = [
        "Suck It and See",
        "Humbug",
        "AM",
        "Tranquility Base Hotel & Casino",
        "The Car",
        "Favourite Worst Nightmare"
    ]
    
    for album in albums:
        folder = MUSIC_ROOT / album
        if folder.exists():
            process_folder(folder)
    
    print("\nProceso completado")

if __name__ == "__main__":
    main()