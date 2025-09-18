import pyodbc

conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=127.0.0.1:3306;"          # o tu instancia: localhost\SQLEXPRESS
    "DATABASE=jerusalem_college;"
    "UID=sa;"                    # tu usuario de SQL Server
    "PWD=3011;"
)
from flask import Flask, render_template
import pyodbc

app = Flask(__name__)

# 🔹 Configuración conexión a SQL Server
db_config = {
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=127.0.0.1:3306;"          # o tu instancia: localhost\SQLEXPRESS
    "DATABASE=jerusalem_college;"
    "UID=sa;"                    # tu usuario de SQL Server
    "PWD=3011;"
}

def get_connection():
    return pyodbc.connect(
        "DRIVER={ODBC Driver 17 for SQL Server};"
        f"SERVER={db_config['server']};"
        f"DATABASE={db_config['database']};"
        f"UID={db_config['username']};"
        f"PWD={db_config['password']}"
    )

@app.route('/')
def lista_representantes():
    conn = get_connection()
    cursor = conn.cursor()

    # 🔹 Consulta SQL
    cursor.execute("SELECT Id, Nombre, Apellido, Telefono, Email FROM Representante")
    rows = cursor.fetchall()

    # Convertir a lista de diccionarios para Jinja2
    representantes = []
    for row in rows:
        representantes.append({
            "id": row[0],
            "nombre": row[1],
            "apellido": row[2],
            "telefono": row[3],
            "email": row[4]
        })

    cursor.close()
    conn.close()

    return render_template("representantes.html", representantes=representantes)

if __name__ == '__main__':
    app.run(debug=True)
