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

        # Buscar el usuario por correo
        cursor.execute("SELECT * FROM usuarios WHERE LOWER(correo)=%s", (correo,))
        user = cursor.fetchone()

        if user:
            hashed_password = user["contrasena"].encode('utf-8')
            if bcrypt.checkpw(contrasena.encode('utf-8'), hashed_password):
                # Guardar sesión
                request.session["usuario_id"] = user["id_usuario"]
                request.session["usuario_correo"] = user["correo"]
                request.session["usuario_rol"] = user["rol"]  #Guarda el rol
                return redirect("admin_panel")  #Redirige al panel
            else:
                error = "Correo o contraseña incorrectos"
        else:
            error = "Correo o contraseña incorrectos"

    return render(request, "login.html", {"error": error})


# ---- INICIO ----
def inicio(request):
    if "usuario_id" in request.session:
        correo = request.session["usuario_correo"]
        return render(request, "inicio.html", {"usuario": {"correo": correo}})
    else:
        return redirect("login")


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

    # Si es admin, mostrar el panel
    return render(request, "registro.html")



