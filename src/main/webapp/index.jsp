<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="pe.edu.upla.repositorio.dao.RepositorioDAO" %>
<!--
  =============================================================================
  REPOSITORIO UNIVERSITARIO UPLA - ARQUITECTURA DE SOFTWARE 2026-I
  Estudiante / Autor: Alessander Meza Garay (Código: r03396b)
  Correo Institucional: r03396b@ms.upla.edu.pe
  Docente: Mg. Raúl Enrique Fernández Bejarano
  =============================================================================
-->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portafolio Académico | Arquitectura de Software - UPLA</title>
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
                <p>Facultad de Ingeniería &bull; Arquitectura de Software 2026-I</p>
            </div>
        </div>

        <div style="display: flex; align-items: center; gap: 0.75rem;">
            <c:choose>
                <c:when test="${not empty sessionScope.usuario}">
                    <div style="display: flex; align-items: center; gap: 0.6rem; padding: 0.3rem 0.8rem; background: rgba(0,82,204,0.15); border: 1px solid var(--upla-blue-600); border-radius: 9999px;">
                        <img src="${pageContext.request.contextPath}/img/alessander.jpg" alt="Alessander" style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;">
                        <span style="font-size: 0.825rem; font-weight: 700; color: #fff;">${sessionScope.usuario.nombre}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-secondary btn-sm">Cerrar Sesión</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth" class="btn btn-primary btn-sm">
                        🔐 Acceso Alumno (Alessander)
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <!-- MENÚ DE NAVEGACIÓN POR PESTAÑAS (CLICK ROBUSTO) -->
    <nav class="nav-tabs">
        <button type="button" class="tab-link active" data-tab="sec-inicio" onclick="openTab('sec-inicio')">
            🏠 Inicio & Perfil
        </button>
        <button type="button" class="tab-link" data-tab="sec-unidades" onclick="openTab('sec-unidades')">
            📚 Unidades & Entregables (${entregables.size()} Trabajos)
        </button>
        <button type="button" class="tab-link" data-tab="sec-metricas" onclick="openTab('sec-metricas')">
            📊 Avance Curricular
        </button>
        <button type="button" class="tab-link" data-tab="sec-admin" onclick="openTab('sec-admin')">
            ⚙️ ${not empty sessionScope.usuario ? 'Subir Nuevo Trabajo' : 'Información del Sistema'}
        </button>
    </nav>

    <!-- PESTAÑA 1: INICIO & PERFIL DE ALESSANDER MEZA GARAY -->
    <div id="sec-inicio" class="tab-pane" style="display: block;">
        <!-- TARJETA DEL ESTUDIANTE -->
        <div class="card">
            <div class="card-title-row">
                <h2>Estudiante Autor del Portafolio</h2>
                <span class="status-pill status-ok">Ingeniería de Sistemas y Computación</span>
            </div>

            <div class="profile-hero">
                <img src="${pageContext.request.contextPath}/img/alessander.jpg" alt="Alessander Meza Garay" class="profile-avatar-img">
                <div>
                    <h3 style="font-size: 1.4rem; font-weight: 800; color: #ffffff;">Alessander Meza Garay</h3>
                    <p style="color: var(--text-accent); font-size: 0.9rem; font-weight: 700;">Código Universitario: r03396b</p>
                    <p style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 0.25rem;">
                        Estudiante del VII Ciclo &bull; Universidad Peruana Los Andes (UPLA) &bull; Huancayo
                    </p>
                </div>
            </div>

            <div class="profile-meta-grid">
                <div class="info-box">
                    <div class="info-box-label">Correo Institucional</div>
                    <div class="info-box-value" style="color: var(--text-accent);">r03396b@ms.upla.edu.pe</div>
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

        <!-- TARJETA DOCENTE DE CÁTEDRA -->
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

    <!-- PESTAÑA 2: UNIDADES Y TABLA DE ENTREGABLES MÚLTIPLES -->
    <div id="sec-unidades" class="tab-pane" style="display: none;">
        <!-- RESUMEN DE LAS 4 UNIDADES -->
        <div class="card">
            <div class="card-title-row">
                <h2>Programación de Unidades Académicas (Sílabo Oficial)</h2>
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
                                <span>Progreso: ${Math.round((u.semanasCompletadas / 4.0) * 100)}%</span>
                                <span>${u.semanasCompletadas} Archivos Subidos</span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- TABLA CON SOPORTE PARA MÚLTIPLES TRABAJOS Y VISOR EN PANTALLA -->
        <div class="card" style="padding: 0; overflow: hidden;">
            <div style="padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border-card); display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h2 style="font-size: 1.1rem; font-weight: 800;">Lista de Trabajos y Entregables por Semana</h2>
                    <p style="font-size: 0.8rem; color: var(--text-secondary);">Puedes subir más de 1 trabajo por semana y verlos directamente en pantalla</p>
                </div>
                <button type="button" class="btn btn-primary btn-sm" onclick="openTab('sec-admin')">
                    ➕ Subir Nuevo Trabajo
                </button>
            </div>

            <div class="table-container">
                <table class="clean-table">
                    <thead>
                        <tr>
                            <th>Semana</th>
                            <th>Tema del Sílabo</th>
                            <th>Título del Trabajo / Archivo</th>
                            <th>Estado</th>
                            <th style="text-align: right;">Acciones de Visualización</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="semIndex" begin="1" end="16">
                            <c:set var="tieneArchivos" value="false" />
                            <c:forEach var="e" items="${entregables}">
                                <c:if test="${e.semana == semIndex}">
                                    <c:set var="tieneArchivos" value="true" />
                                    <tr>
                                        <td>
                                            <strong style="color: var(--text-accent);">Semana ${e.semana}</strong>
                                        </td>
                                        <td>
                                            <span style="font-size: 0.85rem; font-weight: 600;">${RepositorioDAO.getTemaSemana(e.semana)}</span>
                                        </td>
                                        <td>
                                            <div style="font-weight: 700; color: #ffffff;">📌 ${e.tituloTrabajo}</div>
                                            <div style="font-size: 0.775rem; color: var(--text-secondary);">📄 ${e.nombreArchivo}</div>
                                        </td>
                                        <td>
                                            <span class="status-pill status-ok">✓ Disponible</span>
                                        </td>
                                        <td style="text-align: right;">
                                            <div style="display: flex; gap: 0.4rem; justify-content: flex-end;">
                                                <!-- BOTÓN VISTA PREVIA EN PANTALLA -->
                                                <button type="button" class="btn btn-primary btn-sm" onclick="openDocViewer('${e.archivoUrl}', '${e.tituloTrabajo}')">
                                                    👁️ Ver en Pantalla
                                                </button>
                                                <!-- BOTÓN DESCARGAR -->
                                                <a href="${e.archivoUrl}" target="_blank" class="btn btn-secondary btn-sm" title="Descargar archivo">
                                                    ⬇️ Descargar
                                                </a>
                                                <!-- BOTÓN ELIMINAR (SI HAY SESIÓN) -->
                                                <c:if test="${not empty sessionScope.usuario}">
                                                    <form action="${pageContext.request.contextPath}/upload" method="post" style="display: inline;" onsubmit="return confirm('¿Eliminar el trabajo \'${e.tituloTrabajo}\'?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${e.id}">
                                                        <button type="submit" class="btn btn-danger btn-sm">
                                                            🗑️ Eliminar
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:forEach>

                            <!-- SI LA SEMANA NO TIENE TRABAJOS AÚN -->
                            <c:if test="${not tieneArchivos}">
                                <tr>
                                    <td>
                                        <span style="color: var(--text-muted);">Semana ${semIndex}</span>
                                    </td>
                                    <td>
                                        <span style="font-size: 0.85rem; color: var(--text-secondary);">${RepositorioDAO.getTemaSemana(semIndex)}</span>
                                    </td>
                                    <td colspan="2">
                                        <span class="status-pill status-wait">⌛ Sin entregables aún</span>
                                    </td>
                                    <td style="text-align: right;">
                                        <button type="button" class="btn btn-secondary btn-sm" onclick="openTab('sec-admin')">
                                            ➕ Agregar Trabajo
                                        </button>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- PESTAÑA 3: MÉTRICAS Y GRÁFICO DE AVANCE -->
    <div id="sec-metricas" class="tab-pane" style="display: none;">
        <div class="card">
            <div class="card-title-row">
                <h2>Gráfico de Progreso de Entregables</h2>
                <span style="font-size: 0.8rem; color: var(--text-accent);">Estadísticas dinámicas con Chart.js</span>
            </div>

            <div style="position: relative; height: 300px; width: 100%;">
                <canvas id="unidadesChart"></canvas>
            </div>

            <div style="margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid rgba(255,255,255,0.08); display: flex; justify-content: space-between; align-items: center;">
                <span style="color: var(--text-secondary);">Total de archivos cargados al repositorio:</span>
                <strong style="color: var(--text-accent); font-size: 1.1rem;">${entregables.size()} Archivos Subidos</strong>
            </div>
        </div>
    </div>

    <!-- PESTAÑA 4: FORMULARIO DE SUBIDA CON NOMBRE DE TRABAJO -->
    <div id="sec-admin" class="tab-pane" style="display: none;">
        <c:choose>
            <c:when test="${not empty sessionScope.usuario}">
                <div class="card">
                    <div class="card-title-row">
                        <h2>Formulario de Carga de Trabajos</h2>
                        <span class="status-pill status-ok">Usuario: Alessander Meza Garay</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/upload" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="form-label">Seleccionar Semana del Sílabo (1 al 16):</label>
                            <select name="semana" class="form-control" required>
                                <c:forEach var="w" begin="1" end="16">
                                    <option value="${w}">
                                        Semana ${w}: ${RepositorioDAO.getTemaSemana(w)}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Nombre / Título del Trabajo (Ej: "Informe de Casos de Uso - Semana 6"):</label>
                            <input type="text" name="tituloTrabajo" class="form-control" placeholder="Escribe el nombre o título de la actividad..." required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Adjuntar Archivo o Imagen (PDF, PNG, JPG, DOCX, ZIP):</label>
                            <input type="file" name="archivo" class="form-control" required>
                        </div>

                        <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">
                            📤 Cargar Trabajo al Repositorio Supabase
                        </button>
                    </form>
                </div>
            </c:when>

            <c:otherwise>
                <div class="card" style="text-align: center; padding: 3rem 1.5rem;">
                    <h2 style="font-size: 1.3rem; margin-bottom: 0.75rem;">Acceso para Modificar Trabajos</h2>
                    <p style="color: var(--text-secondary); max-width: 500px; margin: 0 auto 1.5rem auto;">
                        Debes iniciar sesión como alumno administrador para subir nuevos archivos, asignar nombres a tus trabajos o eliminar entregables.
                    </p>
                    <a href="${pageContext.request.contextPath}/auth" class="btn btn-primary">
                        🔐 Iniciar Sesión como Alessander Meza Garay
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- VISOR FLOTANTE PARA VER ARCHIVOS E IMÁGENES EN PANTALLA SIN DESCARGAR -->
    <div id="docViewerModal" class="modal-backdrop">
        <div class="modal-window">
            <div class="modal-header">
                <h3 id="modalDocTitle" style="font-size: 1rem; color: #ffffff;">Visor de Documentos UPLA</h3>
                <button type="button" class="btn btn-secondary btn-sm" onclick="closeDocViewer()">✕ Cerrar Visor</button>
            </div>
            <div class="modal-body" id="modalDocContainer">
                <!-- Se inyecta dinámicamente el visor -->
            </div>
        </div>
    </div>

    <!-- FOOTER INSTITUCIONAL -->
    <footer class="footer">
        <p><strong>UNIVERSIDAD PERUANA LOS ANDES &bull; FACULTAD DE INGENIERÍA</strong></p>
        <p>Portafolio Digital de Arquitectura de Software 2026-I &bull; Desarrollado por <strong>Alessander Meza Garay</strong> (Código: r03396b &bull; Correo: r03396b@ms.upla.edu.pe)</p>
    </footer>
</div>

<script>
    function openTab(tabId) {
        if (!tabId) return;
        
        // Ocultar todos los paneles de pestañas
        const panes = document.querySelectorAll('.tab-pane');
        panes.forEach(function(pane) {
            pane.style.display = 'none';
        });

        // Desactivar todos los botones
        const buttons = document.querySelectorAll('.tab-link');
        buttons.forEach(function(btn) {
            btn.classList.remove('active');
        });

        // Mostrar la pestaña seleccionada
        const targetPane = document.getElementById(tabId);
        if (targetPane) {
            targetPane.style.display = 'block';
        }

        // Activar el botón correspondiente
        buttons.forEach(function(btn) {
            if (btn.getAttribute('data-tab') === tabId || btn.getAttribute('onclick')?.includes(tabId)) {
                btn.classList.add('active');
            }
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        const tabButtons = document.querySelectorAll(".tab-link");
        tabButtons.forEach(function(btn) {
            btn.addEventListener("click", function(e) {
                e.preventDefault();
                const tabId = this.getAttribute("data-tab");
                if (tabId) {
                    openTab(tabId);
                }
            });
        });
    });

    // VISOR DE IMÁGENES Y DOCUMENTOS EN PANTALLA SIN DESCARGAR
    function openDocViewer(url, title) {
        const modal = document.getElementById("docViewerModal");
        const modalTitle = document.getElementById("modalDocTitle");
        const container = document.getElementById("modalDocContainer");

        modalTitle.textContent = "📖 Viendo: " + title;

        if (url.match(/\.(jpeg|jpg|gif|png|webp)$/i)) {
            container.innerHTML = `<img src="${url}" alt="${title}" style="max-width: 100%; max-height: 520px; object-fit: contain;">`;
        } else if (url.match(/\.pdf$/i) || url.includes("pdf")) {
            container.innerHTML = `<object data="${url}" type="application/pdf" width="100%" height="520px">
                <iframe src="https://docs.google.com/viewer?url=${encodeURIComponent(url)}&embedded=true" width="100%" height="520px"></iframe>
            </object>`;
        } else {
            container.innerHTML = `<iframe src="https://docs.google.com/viewer?url=${encodeURIComponent(url)}&embedded=true" width="100%" height="520px"></iframe>`;
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
        const canvas = document.getElementById('unidadesChart');
        if (!canvas) return;
        
        try {
            const ctx = canvas.getContext('2d');
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
                        label: 'Archivos Entregados por Unidad',
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
        } catch (e) {
            console.log("Chart initialization skipped: ", e);
        }
    });
</script>

</body>
</html>
