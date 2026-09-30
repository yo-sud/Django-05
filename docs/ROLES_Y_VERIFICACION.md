# Reparto de roles y verificación del panel

## 1. Roles y por qué se reparten así

| Rol | Integrantes | Permisos | Justificación |
|---|---|---|---|
| Superusuario | `admin` | Todo | Administración total y recuperación ante errores. Único que puede borrar sin restricción y gestionar usuarios. |
| `moderadores` | `moderador` | Todo lo de editores + `delete_movie`, `delete_genre`, `delete_person`, `delete_rating`, `moderate_rating`, `publish_movie` | Supervisión editorial: publica y modera, incluido borrado. Separa la responsabilidad de borrar del trabajo diario de carga. |
| `editores` | `editor` | `add/change/view` en Movie, Genre, Person, Rating + `view_movie_stats`, `export_movie_data`, `view_person_filmography`. Sin ningún `delete_*` ni `moderate_rating` ni `publish_movie` | Carga y corrección de cartelera sin riesgo de pérdida de datos. Puede crear y editar, pero no eliminar ni moderar valoraciones ajenas. |
| `vista` | `visor` | Solo `view_*` en los 4 modelos | Consulta y auditoría sin posibilidad de modificar. Ideal para comprobar qué ve un perfil restringido. |

Comando reproducible: `python manage.py setup_permissions`

## 2. Qué cambia en el panel según el rol (comprobado)

Verificación con cliente de prueba Django (30/09/2026, ruta `Django-lab05`):

| Comprobación | Resultado |
|---|---|
| `GET /admin/` anónimo | 302 (redirige a login) |
| `editor` login | True |
| `editor GET /admin/movies/movie/` | 200 |
| `editor GET /admin/movies/movie/add/` | 200 |
| `editor GET /admin/movies/movie/1/delete/` | **403 PermissionDenied** |
| `visor` login | True |
| `visor GET /admin/movies/movie/` | 200 |
| `visor GET /admin/movies/movie/add/` | **403 PermissionDenied** |
| `moderador GET /admin/movies/movie/` | 200 |
| `editor.has_perm(movies.delete_movie)` | False |
| `editor.has_perm(movies.add_movie)` | True |

Lectura operativa:
- **Editor**: ve botón Guardar y puede añadir/cambiar películas, pero no ve acción de borrado efectiva; el acceso directo a `/delete/` devuelve 403.
- **Visor**: entra al listado (solo lectura), pero `/add/` devuelve 403.
- **Moderador**: mantiene el flujo completo incluida eliminación y moderación.

## 3. Panel antes y después (qué documentar con capturas)

### Antes (registro simple)
- `admin.site.register(Movie)` sin `ModelAdmin`.
- Listado con una sola columna (`__str__`), sin filtros ni búsqueda.
- Valoraciones solo por separado, sin contexto de la película.

### Después (personalizado)
- `MovieAdmin`: `list_display` con título, año, duración, director con enlace, géneros, media con color y conteo con enlace; `list_filter` por género y año; `search_fields` por título, título original, sinopsis y nombre del director; `RatingInline` dentro de la película; `filter_horizontal` para géneros y reparto; auditoría en `readonly_fields`.
- `PersonAdmin`: nombre completo, edad calculada, contadores con enlace a dirigidas/actuadas y `DirectedMovieInline` para ver sus películas sin salir del registro.
- `RatingAdmin`: enlaces a película y usuario, badge de puntaje, comentario recortado, filtro por puntaje y por género de la película.
- `GenreAdmin`: conteo con enlace al listado filtrado de películas.

## 4. Superusuario frente a editor

| Elemento | Superusuario | Editor |
|---|---|---|
| Listados | Todos los modelos y acciones | Mismos listados, pero sin acciones de borrado efectivas |
| Detalle película | Botones Guardar + Eliminar | Solo Guardar; `/delete/` → 403 |
| Valoraciones | Edita/borra cualquiera | Añade/cambia, sin `moderate_rating` |
| Auditoría | `created_at`/`updated_at` solo lectura | Igual, solo lectura |
| Exportar | Disponible | Disponible (`export_movie_data`) |
| Publicar | Disponible | No disponible (`publish_movie` denegado) |

## 5. Cómo reproducir la evidencia

```powershell
cd "C:\Users\usuario\Documents\3mosqueteros\Ramas\Django-lab05"
.\venv\Scripts\Activate.ps1
python manage.py migrate
python manage.py load_test_data
python manage.py setup_permissions
python manage.py check
python manage.py runserver
```

- Admin: `http://127.0.0.1:8000/admin/`
- Cartelera: `http://127.0.0.1:8000/`
- Ranking por género: `http://127.0.0.1:8000/genre/1/`
