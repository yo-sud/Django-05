# Movies Project - Panel de Administración Django

Proyecto Django para gestionar películas, géneros, personas y valoraciones con panel de administración personalizado.

## Características

### Modelos
- **Genre**: Géneros cinematográficos (Acción, Drama, Ciencia Ficción, Comedia)
- **Person**: Directores y actores con datos biográficos
- **Movie**: Películas con título, año, duración, póster, géneros, director y reparto
- **Rating**: Valoraciones de usuarios (1-10) con comentarios

### Panel de Administración Personalizado
- **Listados optimizados**: Columnas relevantes, filtros por género y año, búsqueda por título y nombres
- **Edición en línea**: Valoraciones como inline en el formulario de película
- **Campos de solo lectura**: `created_at` y `updated_at` marcados como readonly
- **Filtros horizontales**: Para relaciones muchos-a-muchos (géneros, reparto)

### Control de Acceso
- **Superusuario**: Acceso completo (admin / admin123)
- **Grupo "editores"**: Permisos para añadir y cambiar películas, **NO** para eliminarlas
- **Usuario editor**: editor / editor123 (pertenece al grupo editores)

### Vista Pública de Recomendaciones
- Endpoint: `/genre/<id>/` - Películas del mismo género ordenadas por mejor valoración media
- Lista de géneros: `/` - Navegación a recomendaciones por género

## Instalación y Ejecución

```bash
# Crear entorno virtual
python -m venv venv
.\venv\Scripts\Activate.ps1

# Instalar dependencias
pip install -r requirements.txt

# Aplicar migraciones
python manage.py migrate

# Crear superusuario (opcional, ya creado: admin/admin123)
python manage.py createsuperuser

# Cargar datos de prueba
python manage.py load_test_data

# Ejecutar servidor
python manage.py runserver
```

## URLs Principales
- Panel admin: `http://localhost:8000/admin/`
- Recomendaciones por género: `http://localhost:8000/genre/1/`
- Lista de géneros: `http://localhost:8000/`

## Credenciales de Prueba
| Usuario | Contraseña | Rol |
|---------|------------|-----|
| admin | admin123 | Superusuario |
| editor | editor123 | Editor (sin permiso de borrado) |

## Estructura del Proyecto
```
movies_project/
├── movies_project/          # Configuración del proyecto
│   ├── settings.py
│   └── urls.py
├── movies/                  # Aplicación principal
│   ├── models.py            # Genre, Person, Movie, Rating
│   ├── admin.py             # ModelAdmin personalizados
│   ├── views.py             # Vistas públicas
│   ├── urls.py              # URLs de la app
│   ├── templates/           # Templates para vistas públicas
│   └── management/
│       └── commands/
│           └── load_test_data.py
├── media/                   # Archivos subidos (pósters)
├── requirements.txt
└── manage.py
```

## Observaciones sobre Roles y Permisos

### Superusuario (admin)
- Ve todos los modelos en el panel
- Puede añadir, cambiar y **eliminar** cualquier registro
- Acceso completo a acciones masivas

### Editor (editor)
- Ve los modelos Movie, Genre, Person, Rating
- **No ve el botón "Eliminar"** en películas
- No puede ejecutar la acción "Eliminar seleccionados" en películas
- Puede añadir y editar películas, géneros, personas y valoraciones
- Los campos `created_at` y `updated_at` son de solo lectura para ambos roles

### Qué desaparece para el editor
1. Botón "Eliminar" en el detalle de película
2. Checkbox de selección para eliminación masiva en listado de películas
3. Acción "Eliminar películas seleccionadas" en el dropdown de acciones

## Capturas de Pantalla (Descripción)

### Panel antes de personalización (registro simple)
- Listados con solo `__str__` del modelo
- Sin filtros ni búsqueda
- Sin edición en línea de valoraciones

### Panel después de personalización (ModelAdmin)
- **MovieAdmin**: list_display con título, año, duración, director; list_filter por géneros y año; search_fields por título y director; inline de Rating
- **GenreAdmin**: list_display con nombre y fechas; search por nombre
- **PersonAdmin**: list_display con nombre completo y nacimiento; filtro por fecha; search por nombre
- **RatingAdmin**: list_display con película, usuario, puntuación; filtros por puntuación y fecha

### Comparativa Superusuario vs Editor
- Superusuario: botón "Eliminar" visible, acciones de borrado disponibles
- Editor: sin botón "Eliminar", sin acciones de borrado, resto de funcionalidad idéntica