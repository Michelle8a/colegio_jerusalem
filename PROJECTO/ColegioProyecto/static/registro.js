document.addEventListener("DOMContentLoaded", function() {
    const adminPage = document.getElementById("adminPage");
    const userForm = document.getElementById("userForm");
    const tablaUsuarios = document.getElementById("tablaUsuarios");

    // Mostrar el panel admin
    adminPage.classList.remove("d-none");

    // Función para listar usuarios
    async function listarUsuarios() {
        tablaUsuarios.innerHTML = "";
        try {
            const res = await fetch("/api/usuarios/listar/");
            const usuarios = await res.json();

            usuarios.forEach(u => {
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td>${u.nombre}</td>
                    <td>${u.correo}</td>
                    <td>${u.rol}</td>
                    <td>
                        <button class="btn btn-sm btn-danger" onclick="eliminarUsuario(${u.id_usuario})">Eliminar</button>
                    </td>
                `;
                tablaUsuarios.appendChild(row);
            });
        } catch (err) {
            console.error("Error al listar usuarios:", err);
        }
    }

    // Función para agregar usuario
    userForm.addEventListener("submit", async (e) => {
        e.preventDefault();

        const nombre = document.getElementById("nombre").value;
        const correo = document.getElementById("correo").value;
        const rol = document.getElementById("rol").value;
        const contrasena = document.getElementById("contrasena").value;
        const confirmar = document.getElementById("confirmar").value;

        if (contrasena !== confirmar) {
            alert("Las contraseñas no coinciden");
            return;
        }

        try {
            const res = await fetch("/api/usuarios/agregar/", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({ nombre, correo, rol, contrasena })
            });

            const data = await res.json();
            alert(data.mensaje);

            if (data.status === "ok") {
                userForm.reset();
                listarUsuarios();
            }
        } catch (err) {
            console.error("Error al agregar usuario:", err);
        }
    });
    
    // Función para eliminar usuario
    window.eliminarUsuario = async function(id_usuario) {
        if (!confirm("¿Deseas eliminar este usuario?")) return;
        try {
            const res = await fetch(`/api/usuarios/eliminar/${id_usuario}/`, {
                method: "DELETE",
            });
            const data = await res.json();
            alert(data.mensaje);
            listarUsuarios();
        } catch (err) {
            console.error("Error al eliminar usuario:", err);
        }
    }

    // Listar usuarios al cargar la página
    listarUsuarios();
});

