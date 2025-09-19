from django.shortcuts import render, redirect
import mysql.connector
import bcrypt  # Necesitas instalarlo: pip install bcrypt
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

from collections import defaultdict
from django.shortcuts import render
from django.db import connection

#----------------------------



# Conexión a MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",  # Cambia esto si aplica
    database="jerusalem_colegio"
)
cursor = db.cursor(dictionary=True)

# ---- LOGIN ----
def login_view(request):
    error = None
    if request.method == "POST":
        correo = request.POST.get("correo", "").strip().lower()
        contrasena = request.POST.get("contrasena", "").strip()

        #Busca el usuario por correo
        cursor.execute("SELECT * FROM usuarios WHERE LOWER(correo)=%s", (correo,))
        user = cursor.fetchone()

        if user:
            hashed_password = user["contrasena"].encode('utf-8')
            if bcrypt.checkpw(contrasena.encode('utf-8'), hashed_password):
                #Guardar sesion
                request.session["usuario_id"] = user["id_usuario"]
                request.session["usuario_correo"] = user["correo"]
                rol = user["rol"].lower()
                request.session["usuario_rol"] = rol

                #Redirecciona por rol
                if rol == "admin":
                    return redirect("admin_panel")
                elif rol == "maestro":
                    return redirect("maestro")
                elif rol == "padre":
                    return redirect("padre")
                else:
                    return redirect("inicio")
            else:
                error = "Correo o contraseña incorrectos"
        else:
            error = "Correo o contraseña incorrectos"

    return render(request, "login.html", {"error": error})



# ---- INICIO ----
def inicio(request):
    usuario = None

    # Solo asigna el usuario si realmente hay sesión
    if "usuario_id" in request.session:
        usuario = {
            "correo": request.session["usuario_correo"],
            "rol": request.session["usuario_rol"]
        }

    # Si no hay sesión, usuario seguirá siendo None
    return render(request, "inicio.html", {"usuario": usuario})




# ---- LOGOUT ----
def logout_view(request):
    request.session.flush()
    return redirect("login")


# ---- USUARIOS ----
def admin_panel(request):
    if "usuario_id" not in request.session:
        return redirect("login")

    # Verificar si es administrador
    if request.session.get("usuario_rol") != "admin":
        return redirect("login")

    # Si es admin, pasar info del usuario al template
    usuario = {
        "correo": request.session["usuario_correo"],
        "rol": request.session["usuario_rol"]
    }

    return render(request, "registro.html", {"usuario": usuario})



#---- MAESTRO ----
def maestro(request):
    if "usuario_id" not in request.session:
        return redirect("login")

    if request.session.get("usuario_rol") != "maestro":
        return redirect("login")

    # Pasar info del usuario al template
    usuario = {
        "correo": request.session["usuario_correo"],
        "rol": request.session["usuario_rol"]
    }

    return render(request, "alumnos.html", {"usuario": usuario})

#---- PADRE ----
def padre(request):
    if "usuario_id" not in request.session:
        return redirect("login")
    if request.session.get("usuario_rol") != "padre":
        return redirect("login")
    usuario = {
        "correo": request.session["usuario_correo"],
        "rol": request.session["usuario_rol"]
    }
    return render(request, "Mensualidades.html", {"usuario": usuario})


# ---- ALERTAS ----
def alertas(request):
    if "usuario_id" not in request.session:
        return redirect("login")

    # Obtener datos de la BD
    cursor.execute("SELECT * FROM alertas ORDER BY fecha DESC")
    lista_alertas = cursor.fetchall()

    usuario = {
        "correo": request.session["usuario_correo"],
        "rol": request.session["usuario_rol"]
    }

    return render(request, "alertas.html", {
        "usuario": usuario,
        "alertas": lista_alertas
    })



def horarios(request):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT dia, hora_inicio, hora_fin, id_materia, id_aula
            FROM horarios
            ORDER BY FIELD(dia, 'Lunes','Martes','Miércoles','Jueves','Viernes'), hora_inicio
        """)
        filas = cursor.fetchall()

    # Agrupar por día
    horarios_por_dia = defaultdict(list)
    for fila in filas:
        horarios_por_dia[fila[0]].append({
            'hora_inicio': fila[1],
            'hora_fin': fila[2],
            'id_materia': fila[3],
            'id_aula': fila[4],
        })

    return render(request, 'horarios.html', {
        'horarios_por_dia': dict(horarios_por_dia),
        'usuario': request.session.get('usuario')
    })



#vista de los grados 
def grados(request):
   if request.method == "GET":
        cursor.execute("SELECT * FROM grados")
        grados = cursor.fetchall()
        
   return render(request, "grados/grados.html", {"grados": grados})

#obtener lista de grados 
def listar_grados(request):
    if request.method == "GET":
        cursor.execute("SELECT * FROM grados")
        grados = cursor.fetchall()
        return JsonResponse(grados, safe=False)

#insertar grados.
@csrf_exempt
def add_grado(request):
    if request.method == "POST":
        try:
            data = json.loads(request.body)
            nombre = data.get("nombre")
            nivel = data.get("nivel")
            seccion = data.get("seccion")
            encargado = data.get("encargado")
            cursor.execute("INSERT INTO grados(nombre, nivel, seccion, encargado) VALUES(%s, %s, %s, %s)",[nombre,nivel,seccion,encargado]);
            return JsonResponse({"success":True,"message":"Grado se guardo con exito"});
        except Exception as e:
            return JsonResponse({"success": False, "message": str(e)}, status = 400)
        

def listar_maestros(request):
    # Verificar sesión
    if "usuario_id" not in request.session:
        return redirect("login")

    # Verificar rol: solo admin o maestro
    rol = request.session.get("usuario_rol")
    if rol not in ["admin", "maestro"]:
        return redirect("login")

    # Obtener todos los maestros de la BD
    cursor.execute("SELECT id_maestro, nombres, apellidos, especialidad FROM maestros")
    lista_maestros = cursor.fetchall()  # Devuelve diccionarios

    # Información del usuario para la plantilla
    usuario = {
        "correo": request.session["usuario_correo"],
        "rol": rol
    }

    return render(request, "listamaestros.html", {
        "usuario": usuario,
        "maestros": lista_maestros
    })


#-------------------------------funciones de materias---------------------------
def materias(request):
    if request.method == "GET":
        cursor.execute("SELECT * FROM materias")
        materias = cursor.fetchall()
        
    return render(request, "materias/materias.html", {"materias": materias})

#obtener lista de materia carga las materias en la vista 
def listar_materias(request):
    if request.method == "GET":
        cursor.execute("SELECT * FROM materias")
        materia = cursor.fetchall()
        return JsonResponse(materia, safe=False)

#insertar materia a la base de datos
@csrf_exempt
def add_materia(request):
    if request.method == "POST":
        try:
            data = json.loads(request.body)
            nombre = data.get("nombre")
            descripcion = data.get("descripcion")
            id_maestro = data.get("id_maestro")
            
            cursor.execute("INSERT INTO materias(nombre, descripcion, id_maestro) VALUES(%s, %s, %s)",[nombre,descripcion,id_maestro]);
            db.commit()
            #INSERT INTO `materias` (`id_materia`, `nombre`, `descripcion`, `id_maestro`) VALUES (NULL, 'programacion python', 'programacion con python', '1'),
            return JsonResponse({"success":True,"message":"materia se guardo con exito"});
        except Exception as e:
            return JsonResponse({"success": False, "message": str(e)}, status = 400)

 # ----LISTA DE MAESTROS para la vista de materias ----
def get_maestros(request):
    # Verificar sesión
    if "usuario_id" not in request.session:
        return redirect("login")

    # Verificar rol: solo admin o maestro
    rol = request.session.get("usuario_rol")
    if rol not in ["admin", "maestro"]:
        return redirect("login")

    # Obtener todos los maestros de la BD
    cursor.execute("SELECT id_maestro, nombres, apellidos, especialidad FROM maestros")
    lista_maestros = cursor.fetchall()  # Devuelve diccionarios

    # Información del usuario para la plantilla
    usuario = {
        "correo": request.session["usuario_correo"],
        "rol": rol
    }
    data = {
        "usuario": usuario,
        "maestros": lista_maestros
        }

    return JsonResponse(data);



#---------------------------
