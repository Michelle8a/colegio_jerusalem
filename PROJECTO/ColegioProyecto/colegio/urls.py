
from django.urls import path
from . import views
from . import usuarios_api

urlpatterns = [
    # Página de login
    path('', views.login_view, name='login'),

    # Página de inicio después de iniciar sesión
    path('inicio/', views.inicio, name='inicio'),

    # Cerrar sesión
    path('logout/', views.logout_view, name='logout'),

    # Endpoints API para CRUD de usuarios
   path('adminpanel/', views.admin_panel, name='admin_panel'),
    path("api/usuarios/listar/", usuarios_api.listar_usuarios, name="listar_usuarios"),
    path("api/usuarios/agregar/", usuarios_api.registrar_usuario, name="registrar_usuario"),
    path("api/usuarios/eliminar/<int:id_usuario>/", usuarios_api.eliminar_usuario, name="eliminar_usuario"),

]