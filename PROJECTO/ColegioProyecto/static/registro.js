document.addEventListener("DOMContentLoaded", function() {
    const adminPage = document.getElementById("adminPage");
    const userForm = document.getElementById("userForm");
    const tablaUsuarios = document.getElementById("tablaUsuarios");
    const submitBtn = userForm.querySelector("button");

    // Mostrar el panel admin
    adminPage.classList.remove("d-none");

    let editMode = false;
    let editUserId = null;

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
                        <button class="btn btn-sm btn-primary me-1" onclick="editarUsuario(${u.id_usuario})">Editar</button>
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
    async function agregarUsuario(e) {
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
                headers: { "Content-Type": "application/json" },
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
    }

    userForm.addEventListener("submit", agregarUsuario);

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

    // Función para editar usuario
    window.editarUsuario = async function(id_usuario) {
        try {
            const res = await fetch("/api/usuarios/listar/");
            const usuarios = await res.json();
            const usuario = usuarios.find(u => u.id_usuario === id_usuario);
            if (!usuario) return alert("Usuario no encontrado");

            // Llenar formulario
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

    // Modificar submit para actualizar
    userForm.addEventListener("submit", async function(e) {
        if (!editMode) return; // si no está en modo edición, deja pasar a agregar

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
            const res = await fetch(`/api/usuarios/editar/${editUserId}/`, {
                method: "PUT",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ nombre, correo, rol, contrasena })
            });
            const data = await res.json();
            alert(data.mensaje);

            userForm.reset();
            submitBtn.textContent = "Agregar Usuario";
            submitBtn.classList.remove("btn-warning");
            submitBtn.classList.add("btn-success");
            editMode = false;
            editUserId = null;
            listarUsuarios();
        } catch (err) {
            console.error("Error al actualizar usuario:", err);
        }
    });

    // Listar usuarios al cargar la página
    listarUsuarios();
});

