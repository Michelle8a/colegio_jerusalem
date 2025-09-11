import mysql.connector
import bcrypt
import uuid
from net import mydb    

mycursor = mydb.cursor(dictionary=True)


def registrar_usuario():
    nombre = input("Primer nombre y apellido: ")
    rol = input("Rol (maestro/alumno/admin): ")
    correo = input("Correo electronico: ")
    contrasena = input("Contraseña: ")

    # Generar hash de la contraseña
    hashed = bcrypt.hashpw(contrasena.encode('utf-8'), bcrypt.gensalt())

    try:
        sql = "INSERT INTO usuarios (nombre, rol, correo , contrasena) VALUES (%s, %s, %s, %s)"
        mycursor.execute(sql, (nombre, rol, correo, hashed.decode('utf-8')))
        mydb.commit()
        print(f"Usuario '{nombre}' registrado correctamente.\n")
    except mysql.connector.IntegrityError:
        print("Error: El usuario ya existe.\n")


def listar_usuarios():
    mycursor.execute("SELECT id_usuario, nombre, rol, correo,contrasena FROM usuarios")
    usuarios = mycursor.fetchall()
    print("\nUsuarios registrados:")
    for u in usuarios:
        print(f"ID: {u['id_usuario']}, Nombre: {u['nombre']}, Rol: {u['rol']}, Correo Electronico: {u['correo']}, Contraseña: {u['contrasena']}")
    print("")



def eliminar_usuario():
    listar_usuarios()
    id_eliminar = input("Ingresa el ID del usuario a eliminar: ")
    sql = "DELETE FROM usuarios WHERE id_usuario = %s"
    mycursor.execute(sql, (id_eliminar,))
    mydb.commit()
    print(f"Usuario con ID {id_eliminar} eliminado.\n")


def menu():
    while True:
        print("=== Gestión de Usuarios ===")
        print("1. Registrar usuario")
        print("2. Listar usuarios")
        print("3. Eliminar usuario")
        print("4. Salir")
        opcion = input("Selecciona una opción: ")

        if opcion == "1":
            registrar_usuario()
        elif opcion == "2":
            listar_usuarios()
        elif opcion == "3":
            eliminar_usuario()
        elif opcion == "4":
            break
        else:
            print("Opción no válida.\n")


if __name__ == "__main__":
    menu()
