// registro.js
document.addEventListener("DOMContentLoaded", function () {
    const adminPage = document.getElementById("adminPage");
    const userForm = document.getElementById("userForm");
    const tablaUsuarios = document.getElementById("tablaUsuarios");
    const submitBtn = userForm.querySelector("button");

    adminPage.classList.remove("d-none");

    let editMode = false;
    let editUserId = null;

    // Listar usuarios
    async function listarUsuarios() {
        tablaUsuarios.innerHTML = "";
        try {
            const res = await fetch("/api/usuarios/listar/");
            const usuarios = await res.json();

            usuarios.forEach(u => {
                // Aseguramos que el id sea número
                const id = Number(u.id_usuario);
                tablaUsuarios.innerHTML += `
                    <tr>
                        <td>${u.nombre}</td>
                        <td>${u.correo}</td>
                        <td>${u.rol}</td>
                        <td style="white-space: nowrap;">
                            <button class="btn btn-sm btn-primary me-1" onclick="window.editarUsuario(${id})">Editar</button>
                            <button class="btn btn-sm btn-danger" onclick="window.eliminarUsuario(${id})">Eliminar</button>
                        </td>
                    </tr>
                `;
            });
        } catch (err) {
            console.error("Error al listar usuarios:", err);
        }
    }

    // Agregar/Actualizar usuario
    userForm.addEventListener("submit", async function (e) {
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

        let url = "/api/usuarios/agregar/";
        let method = "POST";

        if (editMode) {
            url = `/api/usuarios/editar/${editUserId}/`;
            method = "PUT";
        }

        try {
            const res = await fetch(url, {
                method: method,
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ nombre, correo, rol, contrasena })
            });

            const data = await res.json();
            alert(data.mensaje);

            if (data.status === "ok") {
                userForm.reset();
                submitBtn.textContent = "Agregar Usuario";
                submitBtn.classList.remove("btn-warning");
                submitBtn.classList.add("btn-success");
                editMode = false;
                editUserId = null;
                listarUsuarios();
            }
        } catch (err) {
            console.error("Error al agregar/editar usuario:", err);
        }
    });

    // Eliminar usuario
    window.eliminarUsuario = async function (id_usuario) {
        if (!confirm("¿Deseas eliminar este usuario?")) return;
        try {
            const res = await fetch(`/api/usuarios/eliminar/${id_usuario}/`, { method: "DELETE" });
            const data = await res.json();
            alert(data.mensaje);
            listarUsuarios();
        } catch (err) {
            console.error("Error al eliminar usuario:", err);
        }
    }

    // Editar usuario
    window.editarUsuario = async function (id_usuario) {
        try {
            const res = await fetch("/api/usuarios/listar/");
            const usuarios = await res.json();
            const usuario = usuarios.find(u => Number(u.id_usuario) === Number(id_usuario));
            if (!usuario) return alert("Usuario no encontrado");

            document.getElementById("nombre").value = usuario.nombre;
            document.getElementById("correo").value = usuario.correo;
            document.getElementById("rol").value = usuario.rol;
            document.getElementById("contrasena").value = "";
            document.getElementById("confirmar").value = "";

            submitBtn.textContent = "Actualizar Usuario";
            submitBtn.classList.remove("btn-success");
            submitBtn.classList.add("btn-warning");

            editMode = true;
            editUserId = id_usuario;

        } catch (err) {
            console.error("Error al obtener usuario:", err);
        }
    }

    // Inicializa la tabla al cargar
    listarUsuarios();
});
