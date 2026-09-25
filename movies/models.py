from django.db import models
from django.conf import settings


class Genre(models.Model):
    name = models.CharField(max_length=100, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['name']
        verbose_name = 'Género'
        verbose_name_plural = 'Géneros'
        permissions = [
            ('manage_genres', 'Gestionar géneros (CRUD completo)'),
        ]

    def __str__(self):
        return self.name


class Person(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    birth_date = models.DateField(null=True, blank=True)
    bio = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['last_name', 'first_name']
        verbose_name = 'Persona'
        verbose_name_plural = 'Personas'
        permissions = [
            ('view_person_filmography', 'Ver filmografía de persona'),
        ]

    def __str__(self):
        return f'{self.first_name} {self.last_name}'


class Movie(models.Model):
    title = models.CharField(max_length=200)
    original_title = models.CharField(max_length=200, blank=True)
    synopsis = models.TextField(blank=True)
    release_year = models.PositiveIntegerField()
    duration = models.PositiveIntegerField(help_text='Duración en minutos')
    poster = models.ImageField(upload_to='posters/', null=True, blank=True)
    genres = models.ManyToManyField(Genre, related_name='movies', blank=True)
    director = models.ForeignKey(
        Person,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='directed_movies'
    )
    cast = models.ManyToManyField(Person, related_name='acted_movies', blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-release_year', 'title']
        verbose_name = 'Película'
        verbose_name_plural = 'Películas'
        permissions = [
            ('view_movie_stats', 'Ver estadísticas de películas'),
            ('export_movie_data', 'Exportar datos de películas'),
            ('publish_movie', 'Publicar película'),
        ]

    def __str__(self):
        return f'{self.title} ({self.release_year})'


class Rating(models.Model):
    movie = models.ForeignKey(Movie, on_delete=models.CASCADE, related_name='ratings')
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='ratings')
    score = models.PositiveSmallIntegerField(choices=[(i, str(i)) for i in range(1, 11)])
    comment = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name = 'Valoración'
        verbose_name_plural = 'Valoraciones'
        unique_together = ['movie', 'user']
        permissions = [
            ('moderate_rating', 'Moderar valoraciones (editar/borrar cualquier)'),
        ]

    def __str__(self):
        return f'{self.movie.title} - {self.score}/10 por {self.user.username}'