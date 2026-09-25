from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse
from django.db.models import Avg, Count
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
    list_display = [
        'title', 'release_year', 'duration', 'director_link',
        'genres_list', 'avg_score', 'ratings_count', 'created_at'
    ]
    list_filter = ['genres', 'release_year', 'created_at']
    search_fields = ['title', 'original_title', 'synopsis', 'director__first_name', 'director__last_name']
    readonly_fields = ['created_at', 'updated_at', 'avg_score_display', 'ratings_count_display']
    filter_horizontal = ['genres', 'cast']
    inlines = [RatingInline]
    date_hierarchy = 'created_at'
    ordering = ['-release_year', 'title']
    autocomplete_fields = ['director']
    list_per_page = 20
    list_max_show_all = 100
    save_on_top = True
    actions = ['mark_as_released', 'export_selected']

    fieldsets = (
        ('Información básica', {
            'fields': ('title', 'original_title', 'synopsis', 'release_year', 'duration', 'poster')
        }),
        ('Relaciones', {
            'fields': ('director', 'genres', 'cast')
        }),
        ('Estadísticas', {
            'fields': ('avg_score_display', 'ratings_count_display'),
            'classes': ('collapse',)
        }),
        ('Auditoría', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

    def director_link(self, obj):
        if obj.director:
            url = reverse('admin:movies_person_change', args=[obj.director.id])
            return format_html('<a href="{}">{}</a>', url, obj.director)
        return '-'
    director_link.short_description = 'Director'
    director_link.admin_order_field = 'director__last_name'

    def genres_list(self, obj):
        return ', '.join([g.name for g in obj.genres.all()[:3]]) + ('...' if obj.genres.count() > 3 else '')
    genres_list.short_description = 'Géneros'

    def avg_score(self, obj):
        avg = obj.ratings.aggregate(avg=Avg('score'))['avg']
        if avg:
            color = 'green' if avg >= 7 else 'orange' if avg >= 5 else 'red'
            return format_html('<span style="color: {}; font-weight: bold;">{:.1f}</span>', color, avg)
        return '-'
    avg_score.short_description = 'Media'
    avg_score.admin_order_field = 'avg_score'

    def ratings_count(self, obj):
        count = obj.ratings.count()
        if count:
            url = reverse('admin:movies_rating_changelist') + f'?movie__id__exact={obj.id}'
            return format_html('<a href="{}">{}</a>', url, count)
        return '0'
    ratings_count.short_description = 'Valoraciones'
    ratings_count.admin_order_field = 'ratings_count'

    def avg_score_display(self, obj):
        avg = obj.ratings.aggregate(avg=Avg('score'))['avg']
        return f'{avg:.1f}/10' if avg else 'Sin valoraciones'
    avg_score_display.short_description = 'Puntuación media'

    def ratings_count_display(self, obj):
        return f'{obj.ratings.count()} valoraciones'
    ratings_count_display.short_description = 'Total valoraciones'

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        return qs.select_related('director').prefetch_related('genres', 'ratings').annotate(
            avg_score=Avg('ratings__score'),
            ratings_count=Count('ratings')
        )

    @admin.action(description='Marcar como estrenadas (año actual)')
    def mark_as_released(self, request, queryset):
        from datetime import date
        current_year = date.today().year
        updated = queryset.update(release_year=current_year)
        self.message_user(request, f'{updated} películas actualizadas a {current_year}.')

    @admin.action(description='Exportar seleccionadas (CSV)')
    def export_selected(self, request, queryset):
        import csv
        from django.http import HttpResponse
        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="peliculas.csv"'
        writer = csv.writer(response)
        writer.writerow(['Título', 'Año', 'Duración', 'Director', 'Géneros', 'Media', 'Valoraciones'])
        for movie in queryset:
            writer.writerow([
                movie.title, movie.release_year, movie.duration,
                str(movie.director) if movie.director else '',
                ', '.join([g.name for g in movie.genres.all()]),
                movie.avg_score_display, movie.ratings_count_display
            ])
        return response


@admin.register(Rating)
class RatingAdmin(admin.ModelAdmin):
    list_display = ['movie_link', 'user_link', 'score', 'score_badge', 'short_comment', 'created_at']
    list_filter = ['score', 'created_at', 'movie__genres']
    search_fields = ['movie__title', 'user__username', 'comment']
    readonly_fields = ['created_at', 'updated_at']
    date_hierarchy = 'created_at'
    ordering = ['-created_at']
    list_per_page = 25
    autocomplete_fields = ['movie', 'user']
    list_select_related = ['movie', 'user']

    def movie_link(self, obj):
        url = reverse('admin:movies_movie_change', args=[obj.movie.id])
        return format_html('<a href="{}">{}</a>', url, obj.movie)
    movie_link.short_description = 'Película'
    movie_link.admin_order_field = 'movie__title'

    def user_link(self, obj):
        url = reverse('admin:auth_user_change', args=[obj.user.id])
        return format_html('<a href="{}">{}</a>', url, obj.user.username)
    user_link.short_description = 'Usuario'
    user_link.admin_order_field = 'user__username'

    def score_badge(self, obj):
        color = 'green' if obj.score >= 7 else 'orange' if obj.score >= 5 else 'red'
        return format_html(
            '<span style="background: {}; color: white; padding: 2px 8px; border-radius: 3px;">{}/10</span>',
            color, obj.score
        )
    score_badge.short_description = 'Puntuación'

    def short_comment(self, obj):
        if obj.comment:
            return obj.comment[:50] + ('...' if len(obj.comment) > 50 else '')
        return '-'
    short_comment.short_description = 'Comentario'