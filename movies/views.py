from django.shortcuts import render, get_object_or_404
from django.db.models import Avg, Count
from .models import Movie, Genre


def _base_genres():
    return Genre.objects.annotate(movies_count=Count('movies')).order_by('name')


def _annotated_movies():
    return Movie.objects.select_related('director').prefetch_related('genres', 'ratings').annotate(
        avg_score=Avg('ratings__score'),
        ratings_count=Count('ratings'),
    )


def genre_list(request):
    genres = _base_genres().filter(movies_count__gt=0)
    top_movies = _annotated_movies().filter(ratings_count__gt=0).order_by('-avg_score', '-ratings_count')[:8]
    billboard = _annotated_movies().order_by('-release_year', '-ratings_count')[:8]
    total_movies = Movie.objects.count()
    total_ratings = sum(m.ratings_count for m in _annotated_movies().filter(ratings_count__gt=0)[:1000])

    context = {
        'genres': genres,
        'all_genres': _base_genres(),
        'top_movies': top_movies,
        'billboard': billboard,
        'total_movies': total_movies,
        'total_ratings': total_ratings,
    }
    return render(request, 'movies/genre_list.html', context)


def movie_recommendations(request, genre_id):
    genre = get_object_or_404(Genre, pk=genre_id)
    movies = (
        _annotated_movies()
        .filter(genres=genre, ratings_count__gt=0)
        .order_by('-avg_score', '-ratings_count')
    )
    others = (
        _annotated_movies()
        .exclude(genres=genre)
        .filter(ratings_count__gt=0)
        .order_by('-avg_score')[:4]
    )

    context = {
        'genre': genre,
        'movies': movies,
        'others': others,
        'all_genres': _base_genres(),
    }
    return render(request, 'movies/recommendations.html', context)
