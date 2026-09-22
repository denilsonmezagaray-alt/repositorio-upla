<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!--
  =============================================================================
  REPOSITORIO UNIVERSITARIO UPLA - ARQUITECTURA DE SOFTWARE
  Estudiante / Autor: Alessander (Ingeniería de Sistemas - UPLA)
  Vista de Autenticación: auth.jsp (Login & Registro con Foto de Perfil en Supabase)
  =============================================================================
-->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Autenticación | Repositorio UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .auth-wrapper {
            max-width: 460px;
            margin: 4rem auto;
        }
        .tab-buttons {
            display: flex;
            background: rgba(4, 18, 38, 0.8);
            border-radius: var(--radius-md);
            padding: 4px;
            margin-bottom: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.08);
        }
        .tab-btn {
            flex: 1;
            padding: 0.65rem;
            text-align: center;
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-secondary);
            border: none;
            background: transparent;
            cursor: pointer;
            border-radius: var(--radius-sm);
            transition: var(--transition);
        }
        .tab-btn.active {
            background: var(--upla-navy-700);
            color: var(--upla-gold-400);
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
        }
        .demo-box {
            background: rgba(212, 175, 55, 0.08);
            border: 1px dashed rgba(212, 175, 55, 0.3);
            border-radius: var(--radius-md);
            padding: 0.85rem 1rem;
            margin-bottom: 1.25rem;
            font-size: 0.825rem;
            color: var(--upla-gold-400);
        }
    </style>
</head>
<body>

<div class="container">
    <div class="auth-wrapper">
        <div style="text-align: center; margin-bottom: 2rem;">
            <div class="brand-logo" style="margin: 0 auto 1rem auto; width: 60px; height: 60px; font-size: 1.5rem;">UPLA</div>
            <h1 style="font-size: 1.5rem; font-weight: 800;">Acceso al Repositorio UPLA</h1>
            <p style="font-size: 0.875rem; color: var(--text-secondary); margin-top: 0.25rem;">
                Asignatura: Arquitectura de Software &bull; Autor: Alessander
            </p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                ${error}
            </div>
        </c:if>

        <div class="card">
            <!-- PESTAÑAS LOGIN / REGISTRO -->
            <div class="tab-buttons">
                <button type="button" class="tab-btn active" id="btnLoginTab" onclick="showTab('login')">Iniciar Sesión</button>
                <button type="button" class="tab-btn" id="btnRegisterTab" onclick="showTab('register')">Registrarse</button>
            </div>

            <!-- FORMULARIO 1: INICIAR SESIÓN -->
            <div id="loginFormSection">
                <div class="demo-box">
                    💡 <strong>Credenciales Semilla del Administrador:</strong><br>
                    Usuario: <code style="color: #fff;">alessander</code> &bull; Clave: <code style="color: #fff;">upla2026</code>
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
                        Ingresar como Administrador
                    </button>
                </form>
            </div>

            <!-- FORMULARIO 2: REGISTRO (CON FOTO EN SUPABASE STORAGE) -->
            <div id="registerFormSection" style="display: none;">
                <form action="${pageContext.request.contextPath}/auth" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="register">
                    <div class="form-group">
                        <label class="form-label">Nombre Completo:</label>
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
                        <label class="form-label">Foto de Perfil (Se guardará en Supabase Storage):</label>
                        <input type="file" name="fotoPerfil" class="form-control" accept="image/*">
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center; margin-top: 0.5rem;">
                        Crear Cuenta y Guardar en Supabase
                    </button>
                </form>
            </div>
        </div>

        <div style="text-align: center; margin-top: 1.5rem;">
            <a href="${pageContext.request.contextPath}/index" style="color: var(--text-secondary); text-decoration: none; font-size: 0.875rem;">
                &larr; Volver al Repositorio (Modo Visitante)
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
