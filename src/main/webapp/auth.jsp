<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!--
  =============================================================================
  REPOSITORIO UNIVERSITARIO UPLA - ARQUITECTURA DE SOFTWARE 2026-I
  Estudiante / Autor: Alessander Meza Garay (Código: r03396b)
  Vista Autenticación: auth.jsp (Diseño Institucional Limpio)
  =============================================================================
-->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso Alumno Administrador | UPLA Arquitectura de Software</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .auth-wrapper {
            max-width: 460px;
            margin: 3.5rem auto;
        }
        .tab-buttons {
            display: flex;
            background: rgba(11, 19, 41, 0.8);
            border-radius: var(--radius-md);
            padding: 4px;
            margin-bottom: 1.5rem;
            border: 1px solid var(--border-card);
        }
        .tab-btn {
            flex: 1;
            padding: 0.7rem;
            text-align: center;
            font-size: 0.875rem;
            font-weight: 700;
            color: var(--text-secondary);
            border: none;
            background: transparent;
            cursor: pointer;
            border-radius: var(--radius-sm);
            transition: var(--transition);
        }
        .tab-btn.active {
            background: var(--upla-blue-600);
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 82, 204, 0.4);
        }
        .demo-box {
            background: rgba(0, 163, 224, 0.1);
            border: 1px dashed var(--upla-cyan);
            border-radius: var(--radius-md);
            padding: 0.9rem 1rem;
            margin-bottom: 1.25rem;
            font-size: 0.85rem;
            color: var(--text-accent);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="auth-wrapper">
        <div style="text-align: center; margin-bottom: 2rem;">
            <img src="${pageContext.request.contextPath}/img/upla_logo.png" alt="UPLA" style="height: 54px; width: auto; margin-bottom: 0.75rem;">
            <h1 style="font-size: 1.5rem; font-weight: 800; color: #ffffff;">Acceso Alumno Administrador</h1>
            <p style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 0.25rem;">
                Alessander Meza Garay &bull; Código: r03396b
            </p>
        </div>

        <c:if test="${not empty error}">
            <div style="background: rgba(239, 68, 68, 0.15); border: 1px solid rgba(239, 68, 68, 0.4); color: #f87171; padding: 0.9rem 1.1rem; border-radius: 12px; margin-bottom: 1.25rem; font-size: 0.875rem;">
                ⚠️ ${error}
            </div>
        </c:if>

        <div class="card">
            <!-- PESTAÑAS LOGIN / REGISTRO -->
            <div class="tab-buttons">
                <button type="button" class="tab-btn active" id="btnLoginTab" onclick="showTab('login')">Iniciar Sesión</button>
                <button type="button" class="tab-btn" id="btnRegisterTab" onclick="showTab('register')">Registrarse</button>
            </div>

            <!-- FORMULARIO 1: LOGIN -->
            <div id="loginFormSection">
                <div class="demo-box">
                    💡 <strong>Credenciales Semilla de Alessander Meza Garay:</strong><br>
                    Usuario: <code style="color: #fff; font-weight: 700;">alessander</code> &bull; Clave: <code style="color: #fff; font-weight: 700;">upla2026</code>
                </div>

                <form action="${pageContext.request.contextPath}/auth" method="post">
                    <input type="hidden" name="action" value="login">
                    <div class="form-group">
                        <label class="form-label">Nombre de Usuario:</label>
                        <input type="text" name="usuario" class="form-control" value="alessander" placeholder="Ej. alessander" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Contraseña:</label>
                        <input type="password" name="clave" class="form-control" value="upla2026" placeholder="••••••••" required>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center; margin-top: 0.5rem;">
                        🔐 Ingresar como Administrador (Alessander)
                    </button>
                </form>
            </div>

            <!-- FORMULARIO 2: REGISTRO DE USUARIO Y FOTO EN SUPABASE STORAGE -->
            <div id="registerFormSection" style="display: none;">
                <form action="${pageContext.request.contextPath}/auth" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="register">
                    <div class="form-group">
                        <label class="form-label">Nombre Completo del Estudiante:</label>
                        <input type="text" name="nombre" class="form-control" value="Alessander Meza Garay" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Usuario:</label>
                        <input type="text" name="usuario" class="form-control" placeholder="Ej. alessander_upla" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Contraseña:</label>
                        <input type="password" name="clave" class="form-control" placeholder="••••••••" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Subir/Actualizar Foto de Perfil (Guardada en Supabase Storage):</label>
                        <input type="file" name="fotoPerfil" class="form-control" accept="image/*">
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center; margin-top: 0.5rem;">
                        📸 Crear Cuenta y Guardar Foto en Supabase
                    </button>
                </form>
            </div>
        </div>

        <div style="text-align: center; margin-top: 1.5rem;">
            <a href="${pageContext.request.contextPath}/index" style="color: var(--text-accent); text-decoration: none; font-size: 0.875rem;">
                &larr; Volver al Portafolio (Modo Lectura)
            </a>
        </div>
    </div>
</div>

<script>
    function showTab(tab) {
        const loginForm = document.getElementById('loginFormSection');
        const registerForm = document.getElementById('registerFormSection');
        const btnLogin = document.getElementById('btnLoginTab');
        const btnRegister = document.getElementById('btnRegisterTab');

        if (tab === 'login') {
            loginForm.style.display = 'block';
            registerForm.style.display = 'none';
            btnLogin.classList.add('active');
            btnRegister.classList.remove('active');
        } else {
            loginForm.style.display = 'none';
            registerForm.style.display = 'block';
            btnLogin.classList.remove('active');
            btnRegister.classList.add('active');
        }
    }
</script>

</body>
</html>
