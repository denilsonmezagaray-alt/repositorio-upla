<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!--
  =============================================================================
  REPOSITORIO UNIVERSITARIO UPLA - ARQUITECTURA DE SOFTWARE
  Estudiante / Autor: Alessander (Ingeniería de Sistemas - UPLA)
  Vista Principal: index.jsp (JSTL + Chart.js + Supabase + Responsive UI)
  =============================================================================
-->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Repositorio Universitario | UPLA - Arquitectura de Software</title>
    <!-- Estilos Personalizados UPLA Anti-Slop -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<div class="container">
    <!-- ENCABEZADO Y BARRA DE NAVEGACIÓN -->
    <header class="navbar">
        <div class="brand-section">
            <div class="brand-logo">UPLA</div>
            <div class="brand-info">
                <h1>Repositorio Universitario de Entregables</h1>
                <p>Asignatura: Arquitectura de Software &bull; Autor: Alessander (Ing. de Sistemas)</p>
            </div>
        </div>

        <div class="user-controls">
            <!-- MODO EDICIÓN / PRIVADO: SI EXISTE SESIÓN INICIADA -->
            <c:if test="${not empty sessionScope.usuario}">
                <div class="user-profile">
                    <img src="${sessionScope.usuario.fotoUrl}" alt="Foto Perfil" class="avatar">
                    <div>
                        <div class="user-name">${sessionScope.usuario.nombre}</div>
                        <span class="user-badge">Administrador</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-secondary btn-sm">Cerrar Sesión</a>
            </c:if>

            <!-- MODO VISITANTE / PÚBLICO: SI NO HAY SESIÓN -->
            <c:if test="${empty sessionScope.usuario}">
                <a href="${pageContext.request.contextPath}/auth" class="btn btn-primary">
                    <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"/></svg>
                    Iniciar Sesión / Registro
                </a>
            </c:if>
        </div>
    </header>

    <!-- ALERTAS Y MENSAJES DE ESTADO -->
    <c:if test="${param.msg == 'login_success'}">
        <div class="alert alert-success">
            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
            Bienvenido de nuevo, ${sessionScope.usuario.nombre}. Has iniciado sesión en Modo Edición.
        </div>
    </c:if>
    <c:if test="${param.msg == 'upload_success'}">
        <div class="alert alert-success">
            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
            ¡Archivo subido correctamente a Supabase Storage para la Semana ${param.week}!
        </div>
    </c:if>
    <c:if test="${param.msg == 'delete_success'}">
        <div class="alert alert-error">
            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
            Entregable de la Semana ${param.week} eliminado exitosamente.
        </div>
    </c:if>

    <!-- SECCIÓN SUPERIOR: GRÁFICO CHART.JS Y FORMULARIO O MÉTRICAS -->
    <div class="grid-top">
        <!-- 1. GRÁFICO DINÁMICO DE CHART.JS (AVANCE POR UNIDADES) -->
        <div class="card">
            <div class="card-title">
                <span>Progreso por Unidades Académicas</span>
                <span class="icon-badge">📊</span>
            </div>
            <div style="position: relative; height: 220px; width: 100%;">
                <canvas id="unidadesChart"></canvas>
            </div>
            <div class="progress-bar-bg">
                <div class="progress-bar-fill" style="width: ${porcentajeProgreso}%;"></div>
            </div>
            <div style="display: flex; justify-content: space-between; margin-top: 0.5rem; font-size: 0.8rem; color: var(--text-secondary);">
                <span>Avance General del Semestre</span>
                <strong style="color: var(--upla-gold-400);">${porcentajeProgreso}% (${totalSubidos} de 16 Semanas)</strong>
            </div>
        </div>

        <!-- 2. FORMULARIO DE SUBIDA (MODO EDICIÓN) O PANEL INFORMATIVO (MODO VISITANTE) -->
        <c:choose>
            <c:when test="${not empty sessionScope.usuario}">
                <!-- MODO EDICIÓN: SUBIDA DE ARCHIVOS MULTIPART -->
                <div class="card">
                    <div class="card-title">
                        <span>Gestor de Subida de Entregables</span>
                        <span class="icon-badge">☁️</span>
                    </div>
                    <form action="${pageContext.request.contextPath}/upload" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="form-label">Seleccionar Semana del Semestre (1 al 16):</label>
                            <select name="semana" class="form-control" required>
                                <c:forEach var="item" items="${entregables}">
                                    <option value="${item.semana}">
                                        Semana ${item.semana} (${item.nombreUnidad}) - ${item.completado ? 'Completado' : 'Pendiente'}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Adjuntar Archivo o Documento (PDF, ZIP, Docx, Imagen):</label>
                            <input type="file" name="archivo" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">
                            <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/></svg>
                            Subir Entregable a Supabase Storage
                        </button>
                    </form>
                </div>
            </c:when>

            <c:otherwise>
                <!-- MODO VISITANTE: RESUMEN INFORMATIVO -->
                <div class="card" style="display: flex; flex-direction: column; justify-content: space-between;">
                    <div>
                        <div class="card-title">
                            <span>Información General del Repositorio</span>
                            <span class="icon-badge">🎓</span>
                        </div>
                        <p style="font-size: 0.9rem; color: var(--text-secondary); margin-bottom: 1rem;">
                            Bienvenido al repositorio digital de la asignatura <strong>Arquitectura de Software</strong> en la <strong>Universidad Peruana Los Andes</strong>.
                            Cualquier visitante puede revisar los archivos publicados y descargarlos.
                        </p>
                        <div class="stats-wrapper">
                            <div class="stat-item">
                                <div class="stat-value">4</div>
                                <div class="stat-label">Unidades</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value">16</div>
                                <div class="stat-label">Semanas</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value">${totalSubidos}</div>
                                <div class="stat-label">Archivos</div>
                            </div>
                        </div>
                    </div>
                    <div style="margin-top: 1.5rem;">
                        <a href="${pageContext.request.contextPath}/auth" class="btn btn-secondary" style="width: 100%; justify-content: center;">
                            Iniciar Sesión como Administrador (Alessander)
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- SECCIÓN INFERIOR: TABLA DE LAS 16 SEMANAS -->
    <div class="card" style="padding: 0; overflow: hidden;">
        <div style="padding: 1.5rem 1.5rem 1rem 1.5rem; display: flex; justify-content: space-between; align-items: center;">
            <h2 style="font-size: 1.15rem; font-weight: 700;">Detalle de las 16 Semanas Académicas</h2>
            <span style="font-size: 0.825rem; color: var(--text-secondary);">
                Modo Actual: <strong style="color: var(--upla-gold-400);">${not empty sessionScope.usuario ? 'EDICIÓN (Privado)' : 'VISITANTE (Público)'}</strong>
            </span>
        </div>

        <div class="table-container" style="border: none; border-radius: 0;">
            <table class="weeks-table">
                <thead>
                    <tr>
                        <th>Semana</th>
                        <th>Unidad Académica</th>
                        <th>Estado del Entregable</th>
                        <th>Archivo Adjunto</th>
                        <th style="text-align: right;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="e" items="${entregables}">
                        <tr>
                            <td>
                                <span class="week-badge">Semana ${e.semana}</span>
                            </td>
                            <td>
                                <strong style="color: var(--text-primary); font-size: 0.9rem;">${e.nombreUnidad}</strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${e.completado}">
                                        <span class="status-pill status-completed">
                                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/></svg>
                                            Entregado
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill status-pending">
                                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/></svg>
                                            Pendiente
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${e.completado}">
                                        <span style="font-size: 0.85rem; color: var(--text-secondary); word-break: break-all;">
                                            📄 ${e.nombreArchivo}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="font-size: 0.85rem; color: var(--text-muted); italic;">Sin entregable subido</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: right;">
                                <div style="display: flex; gap: 0.5rem; justify-content: flex-end;">
                                    <!-- BOTÓN DESCARGAR (VISIBLE PARA TODOS) -->
                                    <c:if test="${e.completado}">
                                        <a href="${e.archivoUrl}" target="_blank" class="btn btn-secondary btn-sm" title="Descargar Archivo">
                                            <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/></svg>
                                            Descargar
                                        </a>
                                    </c:if>

                                    <!-- BOTÓN ELIMINAR (SOLO MODO EDICIÓN / PRIVADO) -->
                                    <c:if test="${not empty sessionScope.usuario and e.completado}">
                                        <form action="${pageContext.request.contextPath}/upload" method="post" style="display: inline;" onsubmit="return confirm('¿Está seguro de eliminar el entregable de la Semana ${e.semana}?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="semana" value="${e.semana}">
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                Eliminar
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="footer">
        <p><strong>Universidad Peruana Los Andes (UPLA)</strong> &bull; Facultad de Ingeniería</p>
        <p>Proyecto de Arquitectura de Software &bull; Desarrollado por <strong>Alessander</strong></p>
    </footer>
</div>

<!-- INICIALIZACIÓN DINÁMICA DE CHART.JS -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const ctx = document.getElementById('unidadesChart').getContext('2d');
        
        // Extraer datos desde JSTL enviado por IndexServlet
        const labels = [];
        const dataCompletadas = [];
        
        <c:forEach var="u" items="${unidades}">
            labels.push('Unidad ${u.numero}');
            dataCompletadas.push(${u.semanasCompletadas});
        </c:forEach>

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Semanas Completadas (de 4)',
                    data: dataCompletadas,
                    backgroundColor: [
                        'rgba(212, 175, 55, 0.85)',
                        'rgba(52, 211, 153, 0.85)',
                        'rgba(96, 165, 250, 0.85)',
                        'rgba(248, 113, 113, 0.85)'
                    ],
                    borderColor: [
                        '#d4af37',
                        '#34d399',
                        '#60a5fa',
                        '#f87171'
                    ],
                    borderWidth: 1.5,
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 4,
                        ticks: {
                            stepSize: 1,
                            color: '#94a3b8'
                        },
                        grid: {
                            color: 'rgba(255, 255, 255, 0.06)'
                        }
                    },
                    x: {
                        ticks: {
                            color: '#94a3b8'
                        },
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        labels: {
                            color: '#f8fafc',
                            font: {
                                family: 'Plus Jakarta Sans',
                                weight: '600'
                            }
                        }
                    }
                }
            }
        });
    });
</script>

</body>
</html>
