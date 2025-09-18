
from django.urls import path
from . import views
from . import usuarios_api

#------------------------
from representantes import views_representantes
from django.contrib import admin

urlpatterns = [
    # Página de inicio después de iniciar sesión
    path('', views.inicio, name='inicio'),

    # Página de login
    path('login/', views.login_view, name='login'),

    
    # Cerrar sesión
    path('logout/', views.logout_view, name='logout'),



    # SOLO ADMIN
   path('adminpanel/', views.admin_panel, name='admin_panel'),
    path("api/usuarios/listar/", usuarios_api.listar_usuarios, name="listar_usuarios"),
    path("api/usuarios/agregar/", usuarios_api.registrar_usuario, name="registrar_usuario"),
    path("api/usuarios/eliminar/<int:id_usuario>/", usuarios_api.eliminar_usuario, name="eliminar_usuario"),
    path('api/usuarios/editar/<int:id_usuario>/', usuarios_api.editar_usuario, name='editar_usuario'),

    
    # SOLO MAESTROS
    path('maestros/', views.maestro, name='maestro'),

    # SOLO PADRES
    path('padres/', views.padre, name='padre'),


    # ALERTAS
    path('alertas/', views.alertas, name='alertas'),

    
# horarios  
    path('horarios/', views.horarios, name='horarios'),

    #para grados
    path('grados/', views.grados, name='grados'),
    path('get_grados/', views.listar_grados, name='get_grados'),
    path('add_grados/', views.add_grado, name='add_grados'),

 #para maestros
    path('lista_maestros/', views.listar_maestros, name='lista_maestros'),


#------------------------
path('admin/', admin.site.urls),
path('representantes/', views_representantes.lista_representantes, name='lista_representantes'),
    
]