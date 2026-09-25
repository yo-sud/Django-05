from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from movies.models import Genre, Person, Movie, Rating

User = get_user_model()


class Command(BaseCommand):
    help = 'Carga datos de prueba: 10 películas, 4 géneros, valoraciones en al menos 5 películas'

    def handle(self, *args, **options):
        # Crear géneros
        genres_data = [
            'Acción',
            'Drama',
            'Ciencia Ficción',
            'Comedia',
        ]
        genres = {}
        for name in genres_data:
            genre, _ = Genre.objects.get_or_create(name=name)
            genres[name] = genre
            self.stdout.write(f'Género creado: {genre.name}')

        # Crear personas (directores y actores)
        people_data = [
            ('Christopher', 'Nolan', '1970-07-30'),
            ('Steven', 'Spielberg', '1946-12-18'),
            ('Denis', 'Villeneuve', '1967-10-03'),
            ('Quentin', 'Tarantino', '1963-03-27'),
            ('Greta', 'Gerwig', '1983-08-04'),
            ('Leonardo', 'DiCaprio', '1974-11-11'),
            ('Tom', 'Hanks', '1956-07-09'),
            ('Timothée', 'Chalamet', '1995-12-27'),
            ('Margot', 'Robbie', '1990-07-02'),
            ('Ryan', 'Gosling', '1980-11-12'),
        ]
        people = {}
        for first, last, birth in people_data:
            person, _ = Person.objects.get_or_create(
                first_name=first,
                last_name=last,
                defaults={'birth_date': birth}
            )
            people[f'{first} {last}'] = person
            self.stdout.write(f'Persona creada: {person}')

        # Crear películas
        movies_data = [
            {
                'title': 'Origen',
                'original_title': 'Inception',
                'synopsis': 'Un ladrón que roba secretos corporativos mediante la tecnología de sueños compartidos.',
                'release_year': 2010,
                'duration': 148,
                'director': 'Christopher Nolan',
                'genres': ['Acción', 'Ciencia Ficción'],
                'cast': ['Leonardo DiCaprio'],
            },
            {
                'title': 'Interestelar',
                'original_title': 'Interstellar',
                'synopsis': 'Un grupo de exploradores viaja a través de un agujero de gusano para asegurar la supervivencia de la humanidad.',
                'release_year': 2014,
                'duration': 169,
                'director': 'Christopher Nolan',
                'genres': ['Ciencia Ficción', 'Drama'],
                'cast': ['Matthew McConaughey', 'Anne Hathaway'],
            },
            {
                'title': 'La lista de Schindler',
                'original_title': "Schindler's List",
                'synopsis': 'La historia real de Oskar Schindler, quien salvó a más de mil judíos durante el Holocausto.',
                'release_year': 1993,
                'duration': 195,
                'director': 'Steven Spielberg',
                'genres': ['Drama'],
                'cast': ['Liam Neeson', 'Ben Kingsley'],
            },
            {
                'title': 'Dune',
                'original_title': 'Dune',
                'synopsis': 'Paul Atreides debe liderar a su pueblo en el planeta desértico Arrakis.',
                'release_year': 2021,
                'duration': 155,
                'director': 'Denis Villeneuve',
                'genres': ['Ciencia Ficción', 'Acción'],
                'cast': ['Timothée Chalamet', 'Zendaya'],
            },
            {
                'title': 'Pulp Fiction',
                'original_title': 'Pulp Fiction',
                'synopsis': 'Las vidas de dos sicarios, un boxeador, una esposa de gánster y una pareja de ladrones se entrelazan.',
                'release_year': 1994,
                'duration': 154,
                'director': 'Quentin Tarantino',
                'genres': ['Drama', 'Comedia'],
                'cast': ['John Travolta', 'Samuel L. Jackson', 'Uma Thurman'],
            },
            {
                'title': 'Barbie',
                'original_title': 'Barbie',
                'synopsis': 'Barbie sufre una crisis existencial en su mundo perfecto.',
                'release_year': 2023,
                'duration': 114,
                'director': 'Greta Gerwig',
                'genres': ['Comedia'],
                'cast': ['Margot Robbie', 'Ryan Gosling'],
            },
            {
                'title': 'El caballero oscuro',
                'original_title': 'The Dark Knight',
                'synopsis': 'Batman lucha contra el Joker en Gotham City.',
                'release_year': 2008,
                'duration': 152,
                'director': 'Christopher Nolan',
                'genres': ['Acción', 'Drama'],
                'cast': ['Christian Bale', 'Heath Ledger'],
            },
            {
                'title': 'Salvar al soldado Ryan',
                'original_title': 'Saving Private Ryan',
                'synopsis': 'Un grupo de soldados busca a un paracaidista cuyas tres hermanos murieron en combate.',
                'release_year': 1998,
                'duration': 169,
                'director': 'Steven Spielberg',
                'genres': ['Acción', 'Drama'],
                'cast': ['Tom Hanks', 'Matt Damon'],
            },
            {
                'title': 'Blade Runner 2049',
                'original_title': 'Blade Runner 2049',
                'synopsis': 'Un nuevo blade runner descubre un secreto que podría sumir a la sociedad en el caos.',
                'release_year': 2017,
                'duration': 164,
                'director': 'Denis Villeneuve',
                'genres': ['Ciencia Ficción', 'Drama'],
                'cast': ['Ryan Gosling', 'Harrison Ford'],
            },
            {
                'title': 'Mujercitas',
                'original_title': 'Little Women',
                'synopsis': 'Cuatro hermanas crecen en la América de la Guerra Civil.',
                'release_year': 2019,
                'duration': 135,
                'director': 'Greta Gerwig',
                'genres': ['Drama'],
                'cast': ['Saoirse Ronan', 'Emma Watson', 'Florence Pugh'],
            },
        ]

        movies = {}
        for data in movies_data:
            director = people.get(data['director'])
            movie, created = Movie.objects.get_or_create(
                title=data['title'],
                defaults={
                    'original_title': data['original_title'],
                    'synopsis': data['synopsis'],
                    'release_year': data['release_year'],
                    'duration': data['duration'],
                    'director': director,
                }
            )
            if created:
                movie.genres.set([genres[g] for g in data['genres']])
                cast_people = [people[c] for c in data['cast'] if c in people]
                movie.cast.set(cast_people)
                movies[data['title']] = movie
                self.stdout.write(f'Película creada: {movie}')
            else:
                movies[data['title']] = movie
                self.stdout.write(f'Película ya existe: {movie}')

        # Crear valoraciones en al menos 5 películas
        admin_user = User.objects.filter(username='admin').first()
        editor_user = User.objects.filter(username='editor').first()

        ratings_data = [
            ('Origen', admin_user, 9, 'Una obra maestra del cine moderno'),
            ('Origen', editor_user, 8, 'Compleja pero gratificante'),
            ('Interestelar', admin_user, 10, 'Visualmente impresionante y emocionalmente profunda'),
            ('La lista de Schindler', admin_user, 10, 'Imprescindible'),
            ('Dune', admin_user, 9, 'Adaptación fiel y espectacular'),
            ('Dune', editor_user, 8, 'Gran cinematografía'),
            ('Pulp Fiction', admin_user, 9, 'Diálogos icónicos'),
            ('Barbie', editor_user, 7, 'Divertida con mensaje'),
            ('El caballero oscuro', admin_user, 10, 'La mejor película de Batman'),
            ('El caballero oscuro', editor_user, 9, 'Heath Ledger inolvidable'),
            ('Salvar al soldado Ryan', admin_user, 9, 'Realismo brutal'),
            ('Blade Runner 2049', admin_user, 8, 'Secuela digna'),
            ('Mujercitas', editor_user, 8, 'Hermosa adaptación'),
        ]

        for title, user, score, comment in ratings_data:
            if title in movies and user:
                rating, created = Rating.objects.get_or_create(
                    movie=movies[title],
                    user=user,
                    defaults={'score': score, 'comment': comment}
                )
                if created:
                    self.stdout.write(f'Valoración: {rating}')
                else:
                    self.stdout.write(f'Valoración ya existe: {rating}')

        self.stdout.write(self.style.SUCCESS('Datos de prueba cargados correctamente'))