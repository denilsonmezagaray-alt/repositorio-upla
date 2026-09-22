<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!--
  =============================================================================
  REPOSITORIO UNIVERSITARIO UPLA - ARQUITECTURA DE SOFTWARE 2026-I
  Estudiante / Autor: Alessander (Ingeniería de Sistemas y Computación)
  Vista Autenticación: auth.jsp (Cyberpunk Neon Academic Glassmorphism)
  =============================================================================
-->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso Alumno / Administrador | UPLA Arquitectura de Software</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .auth-wrapper {
            max-width: 480px;
            margin: 3.5rem auto;
        }
        .tab-buttons {
            display: flex;
            background: rgba(5, 5, 15, 0.9);
            border-radius: var(--radius-md);
            padding: 5px;
            margin-bottom: 1.5rem;
            border: 1px solid rgba(0, 242, 254, 0.2);
        }
        .tab-btn {
            flex: 1;
            padding: 0.75rem;
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
            background: linear-gradient(135deg, var(--neon-pink), #7928ca);
            color: #ffffff;
            box-shadow: 0 0 15px rgba(255, 0, 127, 0.4);
        }
        .demo-box {
            background: rgba(0, 242, 254, 0.1);
            border: 1px dashed rgba(0, 242, 254, 0.4);
            border-radius: var(--radius-md);
            padding: 1rem;
            margin-bottom: 1.25rem;
            font-size: 0.85rem;
            color: var(--neon-cyan);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="auth-wrapper">
        <div style="text-align: center; margin-bottom: 2rem;">
            <div class="upla-hexagon-logo" style="margin: 0 auto 1rem auto; width: 64px; height: 64px; font-size: 1.5rem;">UPLA</div>
            <h1 style="font-size: 1.65rem; font-weight: 800; background: linear-gradient(90deg, #ffffff, var(--neon-cyan)); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                ACCESO ALUMNO MODIFICAR
            </h1>
            <p style="font-family: 'JetBrains Mono', monospace; font-size: 0.775rem; color: var(--neon-cyan); margin-top: 0.25rem;">
                FACULTAD DE INGENIERÍA // ARQUITECTURA DE SOFTWARE 2026-I
            </p>
        </div>

        <c:if test="${not empty error}">
            <div style="background: rgba(255, 0, 127, 0.15); border: 1px solid var(--neon-pink); color: var(--neon-pink); padding: 1rem 1.25rem; border-radius: 14px; margin-bottom: 1.5rem; font-size: 0.875rem;">
                ⚠️ ${error}
            </div>
        </c:if>

        <div class="cyber-card" style="border-color: var(--border-glow);">
            <!-- PESTAÑAS LOGIN / REGISTRO -->
            <div class="tab-buttons">
                <button type="button" class="tab-btn active" id="btnLoginTab" onclick="showTab('login')">Iniciar Sesión</button>
                <button type="button" class="tab-btn" id="btnRegisterTab" onclick="showTab('register')">Registrarse</button>
            </div>

            <!-- FORMULARIO 1: LOGIN -->
            <div id="loginFormSection">
                <div class="demo-box">
                    💡 <strong>Credenciales Semilla de Alessander:</strong><br>
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
                    <button type="submit" class="btn btn-pink" style="width: 100%; justify-content: center; margin-top: 0.5rem;">
                        ⚡ Ingresar como Administrador (Alessander)
                    </button>
                </form>
            </div>

            <!-- FORMULARIO 2: REGISTRO CON FOTO EN SUPABASE STORAGE -->
            <div id="registerFormSection" style="display: none;">
                <form action="${pageContext.request.contextPath}/auth" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="register">
                    <div class="form-group">
                        <label class="form-label">Nombre Completo del Estudiante:</label>
                        <input type="text" name="nombre" class="form-control" placeholder="Ej. Alessander (Ing. Sistemas)" required>
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
                        <label class="form-label">Foto de Perfil (Almacenada en Supabase Storage):</label>
                        <input type="file" name="fotoPerfil" class="form-control" accept="image/*">
                    </div>
                    <button type="submit" class="btn btn-cyan" style="width: 100%; justify-content: center; margin-top: 0.5rem;">
                        ⚡ Crear Cuenta y Guardar en Supabase
                    </button>
                </form>
            </div>
        </div>

        <div style="text-align: center; margin-top: 1.5rem;">
            <a href="${pageContext.request.contextPath}/index" style="color: var(--neon-cyan); text-decoration: none; font-size: 0.875rem; font-family: 'JetBrains Mono', monospace;">
                &larr; Volver al Portafolio (Modo Auditoria)
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
