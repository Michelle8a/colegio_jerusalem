from django.shortcuts import render, redirect
import mysql.connector
import bcrypt  # Necesitas instalarlo: pip install bcrypt
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json

# Conexión a MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",  # Cambia esto si aplica
    database="jerusalem_college"
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

#vista de los grados 
def grados(request):
   
    return render(request,"grados/grados.html")

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

