from django.shortcuts import render, get_object_or_404
from django.db.models import Avg, Count
from .models import Movie, Genre, Rating


def movie_recommendations(request, genre_id):
    genre = get_object_or_404(Genre, pk=genre_id)
    
    movies = Movie.objects.filter(genres=genre).annotate(
        avg_score=Avg('ratings__score'),
        ratings_count=Count('ratings')
    ).filter(ratings_count__gt=0).order_by('-avg_score', '-ratings_count')
    
    context = {
        'genre': genre,
        'movies': movies,
    }
    return render(request, 'movies/recommendations.html', context)


def genre_list(request):
    genres = Genre.objects.annotate(
        movies_count=Count('movies')
    ).filter(movies_count__gt=0).order_by('name')
    
    context = {
        'genres': genres,
    }
    return render(request, 'movies/genre_list.html', context)