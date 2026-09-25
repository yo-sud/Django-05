from django.core.management.base import BaseCommand
from django.contrib.auth.models import Group, Permission, User
from django.contrib.contenttypes.models import ContentType
from movies.models import Movie, Genre, Person, Rating


class Command(BaseCommand):
    help = 'Configura grupos y permisos personalizados para el panel de administración'

    def handle(self, *args, **options):
        # 1. Crear grupo EDITORES
        editors_group, created = Group.objects.get_or_create(name='editores')
        if created:
            self.stdout.write(self.style.SUCCESS('Grupo "editores" creado'))
        else:
            self.stdout.write('Grupo "editores" ya existe')

        # Permisos para editores
        movie_ct = ContentType.objects.get_for_model(Movie)
        genre_ct = ContentType.objects.get_for_model(Genre)
        person_ct = ContentType.objects.get_for_model(Person)
        rating_ct = ContentType.objects.get_for_model(Rating)

        editor_perms = [
            # Movie: add, change, view, custom
            ('add_movie', movie_ct),
            ('change_movie', movie_ct),
            ('view_movie', movie_ct),
            ('view_movie_stats', movie_ct),
            ('export_movie_data', movie_ct),
            # Genre: view, change
            ('view_genre', genre_ct),
            ('change_genre', genre_ct),
            # Person: view, change
            ('view_person', person_ct),
            ('change_person', person_ct),
            ('view_person_filmography', person_ct),
            # Rating: view, add, change (sus propias)
            ('view_rating', rating_ct),
            ('add_rating', rating_ct),
            ('change_rating', rating_ct),
        ]

        for codename, ct in editor_perms:
            try:
                perm = Permission.objects.get(codename=codename, content_type=ct)
                editors_group.permissions.add(perm)
            except Permission.DoesNotExist:
                self.stdout.write(self.style.WARNING(f'Permiso no encontrado: {codename}'))

        editors_group.save()
        self.stdout.write(f'Permisos asignados a editores: {editors_group.permissions.count()}')

        # 2. Crear grupo MODERADORES
        moderators_group, created = Group.objects.get_or_create(name='moderadores')
        if created:
            self.stdout.write(self.style.SUCCESS('Grupo "moderadores" creado'))

        moderator_perms = list(editor_perms) + [
            # Moderadores pueden eliminar películas
            ('delete_movie', movie_ct),
            ('delete_genre', genre_ct),
            ('delete_person', person_ct),
            # Moderar valoraciones (cualquiera)
            ('moderate_rating', rating_ct),
            ('delete_rating', rating_ct),
            ('publish_movie', movie_ct),
        ]

        for codename, ct in moderator_perms:
            try:
                perm = Permission.objects.get(codename=codename, content_type=ct)
                moderators_group.permissions.add(perm)
            except Permission.DoesNotExist:
                self.stdout.write(self.style.WARNING(f'Permiso no encontrado: {codename}'))

        moderators_group.save()
        self.stdout.write(f'Permisos asignados a moderadores: {moderators_group.permissions.count()}')

        # 3. Crear grupo VISTA (solo lectura)
        viewers_group, created = Group.objects.get_or_create(name='vista')
        if created:
            self.stdout.write(self.style.SUCCESS('Grupo "vista" creado'))

        viewer_perms = [
            ('view_movie', movie_ct),
            ('view_genre', genre_ct),
            ('view_person', person_ct),
            ('view_rating', rating_ct),
        ]

        for codename, ct in viewer_perms:
            try:
                perm = Permission.objects.get(codename=codename, content_type=ct)
                viewers_group.permissions.add(perm)
            except Permission.DoesNotExist:
                self.stdout.write(self.style.WARNING(f'Permiso no encontrado: {codename}'))

        viewers_group.save()
        self.stdout.write(f'Permisos asignados a vista: {viewers_group.permissions.count()}')

        # 4. Crear usuarios de prueba para cada grupo
        users_data = [
            ('editor', 'editor123', 'editor@example.com', 'editores'),
            ('moderador', 'moderador123', 'moderador@example.com', 'moderadores'),
            ('visor', 'visor123', 'visor@example.com', 'vista'),
        ]

        for username, password, email, group_name in users_data:
            user, created = User.objects.get_or_create(
                username=username,
                defaults={'email': email, 'is_staff': True}
            )
            if created:
                user.set_password(password)
                user.save()
                self.stdout.write(self.style.SUCCESS(f'Usuario "{username}" creado'))
            else:
                self.stdout.write(f'Usuario "{username}" ya existe')

            group = Group.objects.get(name=group_name)
            user.groups.add(group)
            user.save()
            self.stdout.write(f'  -> Asignado a grupo "{group_name}"')

        # 5. Resumen de permisos por grupo
        self.stdout.write(self.style.NOTICE('\n=== RESUMEN DE PERMISOS ==='))
        for group in [editors_group, moderators_group, viewers_group]:
            self.stdout.write(f'\n{group.name.upper()}:')
            for perm in group.permissions.all().order_by('content_type__model', 'codename'):
                self.stdout.write(f'  - {perm.content_type.model}.{perm.codename}')

        self.stdout.write(self.style.SUCCESS('\nConfiguración completada.'))