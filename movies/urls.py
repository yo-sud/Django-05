from django.urls import path
from . import views

app_name = 'movies'
urlpatterns = [
    path('', views.genre_list, name='genre_list'),
    path('genre/<int:genre_id>/', views.movie_recommendations, name='movie_recommendations'),
]