# Lista completa esperada de Arctic Monkeys
albums = {
    'Whatever People Say I Am (2006)': [
        'The View From The Afternoon', 'I Bet You Look Good On The Dancefloor',
        'Fake Tales of San Francisco', 'Dancing Shoes', 'You Probably Couldnt See For The Lights',
        'Still Take You Home', 'Riot Van', 'Red Light Indicates Doors Are Secured',
        'Mardy Bum', 'Perhaps Vampires Is A Bit Strong But', 'When The Sun Goes Down',
        'From The Ritz To The Rubble', 'A Certain Romance'
    ],
    'Favourite Worst Nightmare (2007)': [
        'Brianstorm', 'Teddy Picker', 'D Is for Dangerous', 'Balaclava', 'Fluorescent Adolescent',
        'Only Ones Who Know', 'Do Me a Favour', 'This House Is a Circus',
        'If You Were There Beware', 'The Bad Thing', 'Old Yellow Bricks', '505'
    ],
    'Humbug (2009)': [
        'My Propeller', 'Crying Lightning', 'Dangerous Animals', 'Secret Door',
        'Potion Approaching', 'Fire and the Thud', 'Cornerstone',
        'Dance Little Liar', 'Pretty Visitors', 'The Jewellers Hands'
    ],
    'Suck It and See (2011)': [
        'Dont Sit Down Cause Ive Moved Your Chair', 'Library Pictures',
        'All My Own Stunts', 'Reckless Serenade', 'The Hellcat Spangled Shalalala',
        'Brick by Brick', 'Love Is a Laserquest', 'She Is Thunderstorms',
        'Black Treacle', 'Piledriver Waltz', 'Thats Where Youre Wrong',
        'Suck It and See', 'Evil Twin'
    ],
    'AM (2013)': [
        'Do I Wanna Know', 'R U Mine', 'One for the Road', 'Arabella',
        'No 1 Party Anthem', 'Mad Sounds', 'Fireside', 'Why Do You Only Call Me When Youre High',
        'Snap Out of It', 'Knee Socks', 'I Wanna Be Yours'
    ],
    'Tranquility Base Hotel Casino (2018)': [
        'Star Treatment', 'One Point Perspective', 'American Sports',
        'Tranquility Base Hotel Casino', 'Golden Trunks', 'Four Out of Five',
        'The Worlds First Ever Monster Truck Front Flip', 'Science Fiction',
        'She Looks Like Fun', 'Batphone', 'The Ultracheese'
    ],
    'The Car (2022)': [
        'Thered Better Be a Mirrorball', 'I Aint Quite Where I Think I Am',
        'Sculptures of Anything Goes', 'Jet Skis on the Moat', 'Body Paint',
        'The Car', 'Big Ideas', 'Hello You', 'Mr Schwartz', 'Perfect Sense'
    ],
    'B-Sides Rarities': [
        'Bigger Boys and Stolen Sweethearts', 'Nettles', 'Plastic Tramp',
        'The Bakery', 'Da Frame 2R', 'Matador', 'Choo Choo',
        'Light Before', 'Catapult', 'Too Much to Ask', 'I.D.S.T.',
        'Scummy', 'The Blond-O-Sonic Shimmer Trap', 'Bad Woman',
        'You And I', 'Evil Twin', '2013', 'Stop The World I Wanna Get Off With You',
        'Anyways', 'Fireside', 'Temptation Greets You Like Your Naughty Friend',
        'Youre So Dark', 'Feels Like We Only Go Backwards'
    ]
}

# Tracks que tenemos
import os
root = r'C:\Users\usuario\Music\Arctic Monkeys'
tracks = []
for d in os.listdir(root):
    dp = os.path.join(root, d)
    if os.path.isdir(dp):
        for f in os.listdir(dp):
            if f.endswith('.mp3'):
                tracks.append(f.lower())

print(f'Tenemos {len(tracks)} tracks totales')
print()

# Verificar albums principales
for album, expected in albums.items():
    print(f'=== {album} ===')
    missing = []
    for track in expected:
        found = any(track.lower() in t for t in tracks)
        if not found:
            missing.append(track)
    if missing:
        for m in missing:
            print(f'  FALTA: {m}')
    else:
        print(f'  Todo OK ({len(expected)} tracks)')
    print()

print(f'Total tracks esperados (aprox): {sum(len(v) for v in albums.values())}')
print(f'Total tracks en disco: {len(tracks)}')