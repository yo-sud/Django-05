from django.contrib import admin
from .models import Genre, Person, Movie, Rating


@admin.register(Genre)
class GenreAdmin(admin.ModelAdmin):
    list_display = ['name', 'created_at', 'updated_at']
    search_fields = ['name']
    readonly_fields = ['created_at', 'updated_at']


@admin.register(Person)
class PersonAdmin(admin.ModelAdmin):
    list_display = ['first_name', 'last_name', 'birth_date', 'created_at', 'updated_at']
    list_filter = ['birth_date']
    search_fields = ['first_name', 'last_name']
    readonly_fields = ['created_at', 'updated_at']


class RatingInline(admin.TabularInline):
    model = Rating
    extra = 1
    readonly_fields = ['created_at', 'updated_at']
    fields = ['user', 'score', 'comment', 'created_at', 'updated_at']


@admin.register(Movie)
class MovieAdmin(admin.ModelAdmin):
    list_display = ['title', 'release_year', 'duration', 'director', 'created_at']
    list_filter = ['genres', 'release_year']
    search_fields = ['title', 'original_title', 'director__first_name', 'director__last_name']
    readonly_fields = ['created_at', 'updated_at']
    filter_horizontal = ['genres', 'cast']
    inlines = [RatingInline]


@admin.register(Rating)
class RatingAdmin(admin.ModelAdmin):
    list_display = ['movie', 'user', 'score', 'created_at']
    list_filter = ['score', 'created_at']
    search_fields = ['movie__title', 'user__username', 'comment']
    readonly_fields = ['created_at', 'updated_at']