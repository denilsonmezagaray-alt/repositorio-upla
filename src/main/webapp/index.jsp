<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="pe.edu.upla.repositorio.dao.RepositorioDAO" %>
<!--
  =============================================================================
  REPOSITORIO UNIVERSITARIO UPLA - ARQUITECTURA DE SOFTWARE 2026-I
  Estudiante / Autor: Alessander Meza Garay (Código: r03396b)
  Docente: Mg. Raúl Enrique Fernández Bejarano
  Vista Principal: index.jsp (Diseño Institucional Limpio y Pestañas Simplificadas)
  =============================================================================
-->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portafolio Académico Digital | Arquitectura de Software - UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<div class="container">
    <!-- BARRA SUPERIOR INSTITUCIONAL -->
    <header class="navbar">
        <div class="brand-section">
            <img src="${pageContext.request.contextPath}/img/upla_logo.png" alt="Logo UPLA" class="brand-logo-img">
            <div class="brand-info">
                <h1>Universidad Peruana Los Andes</h1>
                <p>Facultad de Ingeniería &bull; Asignatura: Arquitectura de Software 2026-I</p>
            </div>
        </div>

        <div style="display: flex; align-items: center; gap: 0.75rem;">
            <c:choose>
                <c:when test="${not empty sessionScope.usuario}">
                    <div style="display: flex; align-items: center; gap: 0.6rem; padding: 0.3rem 0.8rem; background: rgba(0,82,204,0.15); border: 1px solid var(--upla-blue-600); border-radius: 9999px;">
                        <img src="${pageContext.request.contextPath}/${sessionScope.usuario.fotoUrl}" alt="Alessander" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;">
                        <span style="font-size: 0.825rem; font-weight: 700; color: #fff;">${sessionScope.usuario.nombre}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-secondary btn-sm">Cerrar Sesión</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth" class="btn btn-primary btn-sm">
                        🔐 Acceso Administrador (Alessander)
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <!-- MENÚ DE NAVEGACIÓN SIMPLIFICADO POR PESTAÑAS -->
    <nav class="nav-tabs">
        <button class="tab-link active" onclick="openTab(event, 'sec-inicio')">
            🏠 Inicio & Perfil
        </button>
        <button class="tab-link" onclick="openTab(event, 'sec-unidades')">
            📚 Unidades & Entregables
        </button>
        <button class="tab-link" onclick="openTab(event, 'sec-metricas')">
            📊 Avance Curricular
        </button>
        <button class="tab-link" onclick="openTab(event, 'sec-admin')">
            ⚙️ ${not empty sessionScope.usuario ? 'Gestión de Subida' : 'Información del Sistema'}
        </button>
    </nav>

    <!-- PESTAÑA 1: INICIO & PERFIL DEL ESTUDIANTE / DOCENTE -->
    <div id="sec-inicio" class="tab-content active">
        <!-- TARJETA DEL ESTUDIANTE AUTOR -->
        <div class="card">
            <div class="card-title-row">
                <h2>Estudiante Autor del Portafolio</h2>
                <span class="status-pill status-ok">Ingeniería de Sistemas y Computación</span>
            </div>

            <div class="profile-hero">
                <img src="${pageContext.request.contextPath}/img/alessander.jpg" alt="Alessander Meza Garay" class="profile-avatar-img">
                <div>
                    <h3 style="font-size: 1.4rem; font-weight: 800; color: #ffffff;">Alessander Meza Garay</h3>
                    <p style="color: var(--text-accent); font-size: 0.9rem; font-weight: 600;">Código Universitario: r03396b</p>
                    <p style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 0.25rem;">
                        Estudiante del VII Ciclo &bull; Universidad Peruana Los Andes (UPLA) &bull; Huancayo
                    </p>
                </div>
            </div>

            <div class="profile-meta-grid">
                <div class="info-box">
                    <div class="info-box-label">Correo Institucional</div>
                    <div class="info-box-value" style="color: var(--text-accent);">s01269h@upla.edu.pe</div>
                </div>
                <div class="info-box">
                    <div class="info-box-label">Asignatura</div>
                    <div class="info-box-value">Arquitectura de Software (332181)</div>
                </div>
                <div class="info-box">
                    <div class="info-box-label">Semestre Académico</div>
                    <div class="info-box-value">2026-I &bull; Plan de Estudios 2022</div>
                </div>
            </div>
        </div>

        <!-- TARJETA DEL DOCENTE CÁTEDRA -->
        <div class="card">
            <div class="card-title-row">
                <h2>Docente de la Asignatura</h2>
                <span style="font-size: 0.8rem; color: var(--text-secondary);">Cátedra de Arquitectura UPLA</span>
            </div>

            <div style="display: flex; align-items: center; gap: 1.25rem;">
                <div style="width: 60px; height: 60px; border-radius: 50%; background: var(--upla-blue-600); display: flex; align-items: center; justify-content: center; font-size: 1.75rem; color: #fff;">
                    👨‍🏫
                </div>
                <div>
                    <h3 style="font-size: 1.15rem; font-weight: 800;">Mg. Raúl Enrique Fernández Bejarano</h3>
                    <p style="font-size: 0.85rem; color: var(--text-accent); font-weight: 600;">Docente Titular de la Asignatura</p>
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Correo Oficial: d.rfernandezb@ms.upla.edu.pe &bull; 04 Horas Prácticas</p>
                </div>
            </div>
        </div>
    </div>

    <!-- PESTAÑA 2: UNIDADES Y TABLA DE ENTREGABLES CON VISTA EN PANTALLA -->
    <div id="sec-unidades" class="tab-content">
        <!-- 4 UNIDADES DEL SÍLABO -->
        <div class="card">
            <div class="card-title-row">
                <h2>Resumen de Unidades Académicas (Sílabo Oficial)</h2>
                <span style="font-size: 0.8rem; color: var(--text-secondary);">4 Unidades &bull; 16 Semanas</span>
            </div>

            <div class="units-grid">
                <c:forEach var="u" items="${unidades}">
                    <div class="unit-card">
                        <div>
                            <span class="unit-badge">UNIDAD ${u.numero} &bull; SEMANAS ${((u.numero-1)*4)+1}-${u.numero*4}</span>
                            <h3 style="font-size: 0.95rem; font-weight: 700; margin-bottom: 0.4rem;">${u.nombre}</h3>
                            <p style="font-size: 0.8rem; color: var(--text-secondary);">${u.descripcion}</p>
                        </div>
                        <div>
                            <div class="progress-track">
                                <div class="progress-fill" style="width: ${(u.semanasCompletadas / 4.0) * 100}%;"></div>
                            </div>
                            <div style="display: flex; justify-content: space-between; font-size: 0.775rem; color: var(--text-accent); font-weight: 700;">
                                <span>Avance: ${Math.round((u.semanasCompletadas / 4.0) * 100)}%</span>
                                <span>${u.semanasCompletadas} de 4 Semanas</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- TABLA DE ENTREGABLES CON OPCIÓN DE VISTA SIN DESCARGAR -->
        <div class="card" style="padding: 0; overflow: hidden;">
            <div style="padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border-card); display: flex; justify-content: space-between; align-items: center;">
                <h2 style="font-size: 1.1rem; font-weight: 800;">Entregables y Trabajos por Semana</h2>
                <span style="font-size: 0.8rem; color: var(--text-secondary);">Haz clic en "Ver Documento" para leer sin descargar</span>
            </div>

            <div class="table-container">
                <table class="clean-table">
                    <thead>
                        <tr>
                            <th>Sem.</th>
                            <th>Tema del Sílabo</th>
                            <th>Estado</th>
                            <th>Archivo Adjunto</th>
                            <th style="text-align: right;">Acciones de Visualización</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="e" items="${entregables}">
                            <tr>
                                <td>
                                    <strong style="color: var(--text-accent);">Semana ${e.semana}</strong>
                                </td>
                                <td>
                                    <span style="font-weight: 600;">${RepositorioDAO.getTemaSemana(e.semana)}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${e.completado}">
                                            <span class="status-pill status-ok">✓ Subido</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-pill status-wait">⌛ Pendiente</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${e.completado}">
                                            <span style="font-size: 0.85rem; color: var(--text-secondary);">
                                                📄 ${e.nombreArchivo}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="font-size: 0.8rem; color: var(--text-muted); font-style: italic;">Sin entregable</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: right;">
                                    <div style="display: flex; gap: 0.4rem; justify-content: flex-end;">
                                        <c:if test="${e.completado}">
                                            <!-- VER EN PANTALLA SIN DESCARGAR (MODAL VIEWER) -->
                                            <button type="button" class="btn btn-primary btn-sm" onclick="openDocViewer('${e.archivoUrl}', '${e.nombreArchivo}')">
                                                👁️ Ver Documento
                                            </button>
                                            <!-- DESCARGAR ARCHIVO -->
                                            <a href="${e.archivoUrl}" target="_blank" class="btn btn-secondary btn-sm" title="Descargar">
                                                ⬇️ Descargar
                                            </a>
                                        </if>

                                        <!-- ELIMINAR (SOLO SI TIENE SESIÓN ACTIVA) -->
                                        <c:if test="${not empty sessionScope.usuario and e.completado}">
                                            <form action="${pageContext.request.contextPath}/upload" method="post" style="display: inline;" onsubmit="return confirm('¿Está seguro de eliminar el entregable de la Semana ${e.semana}?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="semana" value="${e.semana}">
                                                <button type="submit" class="btn btn-danger btn-sm">
                                                    🗑️ Eliminar
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
    </div>

    <!-- PESTAÑA 3: MÉTRICAS Y GRÁFICO DE AVANCE -->
    <div id="sec-metricas" class="tab-content">
        <div class="card">
            <div class="card-title-row">
                <h2>Gráfico de Progreso por Unidades</h2>
                <span style="font-size: 0.8rem; color: var(--text-accent);">Procesado dinámicamente con Chart.js</span>
            </div>

            <div style="position: relative; height: 300px; width: 100%;">
                <canvas id="unidadesChart"></canvas>
            </div>

            <div style="margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid rgba(255,255,255,0.08); display: flex; justify-content: space-between; align-items: center;">
                <span style="color: var(--text-secondary);">Avance total de entregables del semestre:</span>
                <strong style="color: var(--text-accent); font-size: 1.1rem;">${porcentajeProgreso}% (${totalSubidos} de 16 semanas entregadas)</strong>
            </div>
        </div>
    </div>

    <!-- PESTAÑA 4: GESTIÓN DE SUBIDA Y EDICIÓN -->
    <div id="sec-admin" class="tab-content">
        <c:choose>
            <c:when test="${not empty sessionScope.usuario}">
                <div class="card">
                    <div class="card-title-row">
                        <h2>Formulario de Subida de Entregables</h2>
                        <span class="status-pill status-ok">Sesión Activa: ${sessionScope.usuario.nombre}</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/upload" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="form-label">Seleccionar Semana (1 al 16):</label>
                            <select name="semana" class="form-control" required>
                                <c:forEach var="item" items="${entregables}">
                                    <option value="${item.semana}">
                                        Semana ${item.semana}: ${RepositorioDAO.getTemaSemana(item.semana)} - [${item.completado ? 'Ya subido' : 'Pendiente'}]
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Adjuntar Archivo o Foto del Trabajo (PDF, Imagen, Documento):</label>
                            <input type="file" name="archivo" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">
                            📤 Subir Entregable a Supabase Storage
                        </button>
                    </form>
                </div>
            </c:when>

            <c:otherwise>
                <div class="card" style="text-align: center; padding: 3rem 1.5rem;">
                    <h2 style="font-size: 1.3rem; margin-bottom: 0.75rem;">Acceso a Modificación de Entregables</h2>
                    <p style="color: var(--text-secondary); max-width: 500px; margin: 0 auto 1.5rem auto;">
                        Para poder subir nuevos archivos, actualizar evidencias o eliminar entregables, debes iniciar sesión con tu cuenta de alumno administrador.
                    </p>
                    <a href="${pageContext.request.contextPath}/auth" class="btn btn-primary">
                        🔐 Iniciar Sesión como Alessander Meza Garay
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- MODAL DE VISUALIZACIÓN EN PANTALLA ("VER SIN DESCARGAR") -->
    <div id="docViewerModal" class="modal-backdrop">
        <div class="modal-window">
            <div class="modal-header">
                <h3 id="modalDocTitle" style="font-size: 1rem; color: #ffffff;">Vista Previa de Entregables</h3>
                <button type="button" class="btn btn-secondary btn-sm" onclick="closeDocViewer()">✕ Cerrar</button>
            </div>
            <div class="modal-body" id="modalDocContainer">
                <!-- Se inyecta dinámicamente el iframe o imagen -->
            </div>
        </div>
    </div>

    <!-- FOOTER INSTITUCIONAL -->
    <footer class="footer">
        <p><strong>UNIVERSIDAD PERUANA LOS ANDES &bull; FACULTAD DE INGENIERÍA</strong></p>
        <p>Portafolio Digital de Arquitectura de Software 2026-I &bull; Desarrollado por <strong>Alessander Meza Garay</strong> (Código: r03396b)</p>
    </footer>
</div>

<!-- SCRIPTS DE NAVEGACIÓN Y PREVISUALIZADOR -->
<script>
    // Cambio de pestañas limpia
    function openTab(evt, tabId) {
        const contents = document.getElementsByClassName("tab-content");
        for (let i = 0; i < contents.length; i++) {
            contents[i].classList.remove("active");
        }
        const links = document.getElementsByClassName("tab-link");
        for (let i = 0; i < links.length; i++) {
            links[i].classList.remove("active");
        }
        document.getElementById(tabId).classList.add("active");
        evt.currentTarget.classList.add("active");
    }

    // Modal de visualización sin descargar
    function openDocViewer(url, fileName) {
        const modal = document.getElementById("docViewerModal");
        const title = document.getElementById("modalDocTitle");
        const container = document.getElementById("modalDocContainer");

        title.textContent = "📄 Viendo: " + fileName;

        // Si es imagen o PDF, inyectar el visor adecuado
        if (url.match(/\.(jpeg|jpg|gif|png|webp)$/i)) {
            container.innerHTML = `<img src="${url}" alt="${fileName}">`;
        } else {
            container.innerHTML = `<iframe src="${url}"></iframe>`;
        }

        modal.classList.add("active");
    }

    function closeDocViewer() {
        const modal = document.getElementById("docViewerModal");
        const container = document.getElementById("modalDocContainer");
        container.innerHTML = "";
        modal.classList.remove("active");
    }

    // Gráfico de Chart.js
    document.addEventListener("DOMContentLoaded", function() {
        const ctx = document.getElementById('unidadesChart').getContext('2d');
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
                    label: 'Semanas Entregadas (de 4)',
                    data: dataCompletadas,
                    backgroundColor: 'rgba(0, 82, 204, 0.85)',
                    borderColor: '#0052cc',
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
                        ticks: { stepSize: 1, color: '#94a3b8' },
                        grid: { color: 'rgba(255, 255, 255, 0.08)' }
                    },
                    x: {
                        ticks: { color: '#ffffff', font: { weight: '700' } },
                        grid: { display: false }
                    }
                },
                plugins: {
                    legend: {
                        labels: { color: '#ffffff', font: { weight: '700' } }
                    }
                }
            }
        });
    });
</script>

</body>
</html>
