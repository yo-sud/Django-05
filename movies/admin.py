from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse
from .models import Genre, Person, Movie, Rating


class RatingInline(admin.TabularInline):
    model = Rating
    extra = 1
    readonly_fields = ['created_at', 'updated_at']
    fields = ['user', 'score', 'comment', 'created_at', 'updated_at']
    autocomplete_fields = ['user']
    verbose_name = 'Valoración'
    verbose_name_plural = 'Valoraciones'


@admin.register(Genre)
class GenreAdmin(admin.ModelAdmin):
    list_display = ['name', 'movies_count', 'created_at', 'updated_at']
    list_filter = ['created_at']
    search_fields = ['name']
    readonly_fields = ['created_at', 'updated_at']
    date_hierarchy = 'created_at'
    ordering = ['name']
    actions = ['delete_selected']

    def movies_count(self, obj):
        count = obj.movies.count()
        url = reverse('admin:movies_movie_changelist') + f'?genres__id__exact={obj.id}'
        return format_html('<a href="{}">{} películas</a>', url, count)
    movies_count.short_description = 'Películas'


@admin.register(Person)
class PersonAdmin(admin.ModelAdmin):
    list_display = ['full_name', 'birth_date', 'age', 'directed_count', 'acted_count', 'created_at']
    list_filter = ['birth_date', 'created_at']
    search_fields = ['first_name', 'last_name', 'bio']
    readonly_fields = ['created_at', 'updated_at']
    date_hierarchy = 'created_at'
    ordering = ['last_name', 'first_name']
    fieldsets = (
        ('Datos personales', {'fields': ('first_name', 'last_name', 'birth_date', 'bio')}),
        ('Auditoría', {'fields': ('created_at', 'updated_at'), 'classes': ('collapse',)}),
    )

    def full_name(self, obj):
        return f'{obj.first_name} {obj.last_name}'
    full_name.short_description = 'Nombre'
    full_name.admin_order_field = 'last_name'

    def age(self, obj):
        if obj.birth_date:
            from datetime import date
            today = date.today()
            return today.year - obj.birth_date.year - (
                (today.month, today.day) < (obj.birth_date.month, obj.birth_date.day)
            )
        return '-'
    age.short_description = 'Edad'

    def directed_count(self, obj):
        count = obj.directed_movies.count()
        url = reverse('admin:movies_movie_changelist') + f'?director__id__exact={obj.id}'
        return format_html('<a href="{}">{} dirigidas</a>', url, count)
    directed_count.short_description = 'Dirigidas'

    def acted_count(self, obj):
        count = obj.acted_movies.count()
        url = reverse('admin:movies_movie_changelist') + f'?cast__id__exact={obj.id}'
        return format_html('<a href="{}">{} actuadas</a>', url, count)
    acted_count.short_description = 'Actuadas'


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