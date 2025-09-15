
from django.urls import path
from . import views
from . import usuarios_api

urlpatterns = [
    # Página de inicio después de iniciar sesión
    path('', views.inicio, name='inicio'),

    # Página de login
    path('login/', views.login_view, name='login'),

    
    # Cerrar sesión
    path('logout/', views.logout_view, name='logout'),


    # Endpoints API para CRUD de usuarios
    path('adminpanel/', views.admin_panel, name='admin_panel'),

    path("api/usuarios/listar/", usuarios_api.listar_usuarios, name="listar_usuarios"),
    path("api/usuarios/agregar/", usuarios_api.registrar_usuario, name="registrar_usuario"),
    path("api/usuarios/eliminar/<int:id_usuario>/", usuarios_api.eliminar_usuario, name="eliminar_usuario"),
    path('api/usuarios/editar/<int:id_usuario>/', usuarios_api.editar_usuario, name='editar_usuario'),

    
    # SOLO MAESTROS
    path('maestros/', views.maestro, name='maestro'),


    path('grados/', views.grados, name='grados'),
]