from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import mysql.connector
import bcrypt
import json
from net import mydb

mycursor = mydb.cursor(dictionary=True)

# ---- Registrar usuario ----
@csrf_exempt
def registrar_usuario(request):
    if request.method == "POST":
        data = json.loads(request.body)
        nombre = data.get("nombre")
        rol = data.get("rol")
        correo = data.get("correo")
        contrasena = data.get("contrasena")

        hashed = bcrypt.hashpw(contrasena.encode('utf-8'), bcrypt.gensalt())

        try:
            sql = "INSERT INTO usuarios (nombre, rol, correo, contrasena) VALUES (%s, %s, %s, %s)"
            mycursor.execute(sql, (nombre, rol, correo, hashed.decode('utf-8')))
            mydb.commit()
            return JsonResponse({"status": "ok", "mensaje": f"Usuario '{nombre}' registrado"})
        except mysql.connector.IntegrityError:
            return JsonResponse({"status": "error", "mensaje": "El usuario ya existe"})


# ---- Listar usuarios ----
def listar_usuarios(request):
    if request.method == "GET":
        mycursor.execute("SELECT id_usuario, nombre, rol, correo FROM usuarios")
        usuarios = mycursor.fetchall()
        return JsonResponse(usuarios, safe=False)


# ---- Eliminar usuario ----
@csrf_exempt
def eliminar_usuario(request, id_usuario):
    if request.method == "DELETE":
        sql = "DELETE FROM usuarios WHERE id_usuario = %s"
        mycursor.execute(sql, (id_usuario,))
        mydb.commit()
        return JsonResponse({"status": "ok", "mensaje": f"Usuario {id_usuario} eliminado"})


        