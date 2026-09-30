# Movies Project - Panel de Administración Django

Proyecto Django que demuestra la configuración avanzada del panel de administración para gestionar un catálogo de películas con modelos relacionados, personalización de listados/filtros/búsqueda y control de acceso basado en roles.

## Características

### Modelos
- **Genre**: Géneros cinematográficos
- **Person**: Directores y actores con datos biográficos
- **Movie**: Películas con título, año, duración, póster, géneros (M2M), director (FK) y reparto (M2M)
- **Rating**: Valoraciones de usuarios (1-10) con comentarios, únicas por usuario/película

### Panel de Administración (`movies/admin.py`)
- **ModelAdmin personalizados** para los 4 modelos con:
  - `list_display` con campos útiles y computados (enlaces, contadores, badges)
  - `list_filter` por relaciones y fechas
  - `search_fields` traversing relaciones (ej. `director__last_name`)
  - `readonly_fields` para auditoría (`created_at`, `updated_at`)
  - `filter_horizontal` para M2M
  - `autocomplete_fields` para FK/M2M
  - `date_hierarchy`, `ordering`, `list_per_page`, `save_on_top`
- **Inlines**: `RatingInline` (TabularInline) en Movie para edición en línea
- **Acciones personalizadas**: exportar CSV, marcar año actual
- **Fieldsets** colapsables para organización
- **get_queryset optimizado** con `select_related`/`prefetch_related` + annotations

### Control de Acceso (RBAC)
Tres grupos con permisos granulares definidos en `Meta.permissions` de cada modelo:

| Grupo | Permisos clave | Por qué |
|-------|----------------|---------|
| **editores** | add/change/view Movie, Genre, Person, Rating; export, stats. Sin delete | Carga diaria sin riesgo de borrar cartelera ni valoraciones |
| **moderadores** | Todo lo anterior + delete + moderate_rating + publish | Supervisa, publica y modera; concentra el borrado fuera del flujo diario |
| **vista** | Solo view_* en todos los modelos | Auditoría y consulta sin edición |

Comando de configuración: `python manage.py setup_permissions`

Verificación comprobada (ver `docs/ROLES_Y_VERIFICACION.md`): editor recibe 403 en `/admin/movies/movie/1/delete/`, visor recibe 403 en `/add/`, moderador conserva el flujo completo. El panel antes mostraba solo `__str__` sin filtros; después muestra columnas útiles, filtros por género/año y búsqueda por título/director, con valoraciones en línea dentro de la película.

### Vista Pública
- `/` → Lista de géneros con conteo de películas
- `/genre/<id>/` → Películas del género ordenadas por valoración media (annotate Avg/Count)

## Instalación

```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
.\venv\Scripts\Activate.ps1  # Windows

pip install -r requirements.txt
python manage.py migrate
python manage.py load_test_data
python manage.py setup_permissions
python manage.py runserver
```

## Usuarios de prueba (creados por `setup_permissions`)
Todos con `is_staff=True` para acceso al admin:

| Usuario | Grupo | Permisos |
|---------|-------|----------|
| editor | editores | CRUD sin delete en Movie |
| moderador | moderadores | CRUD completo + moderación |
| visor | vista | Solo lectura |

## Estructura

```
movies_project/
├── movies_project/          # Configuración proyecto
│   ├── settings.py
│   └── urls.py
├── movies/                  # App principal
│   ├── models.py            # 4 modelos con Meta.permissions
│   ├── admin.py             # 4 ModelAdmin + Inlines + Actions
│   ├── views.py             # Vistas públicas (recomendaciones)
│   ├── urls.py              # URLs namespace 'movies'
│   ├── templates/movies/    # Templates públicos
│   └── management/commands/
│       ├── load_test_data.py   # 10 películas, 4 géneros, ratings
│       └── setup_permissions.py # Grupos, permisos, usuarios
├── requirements.txt
└── manage.py
```

## Permisos personalizados por modelo

```python
Movie: view_movie_stats, export_movie_data, publish_movie
Genre: manage_genres
Person: view_person_filmography
Rating: moderate_rating
```

## Tecnologías
- Django 6.x
- SQLite (desarrollo)
- Pillow (imágenes)