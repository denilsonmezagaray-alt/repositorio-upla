<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/upla_logo.png">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/img/upla_logo.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=20261125d">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div id="greenLanternGlow"></div>

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

    <!-- ALERTAS DINÁMICAS DE ESTADO -->
    <c:if test="${not empty param.msg}">
        <div id="statusAlert" style="background: rgba(16, 185, 129, 0.15); border: 1px solid rgba(16, 185, 129, 0.4); color: #34d399; padding: 0.9rem 1.25rem; border-radius: 12px; margin-bottom: 1.25rem; display: flex; justify-content: space-between; align-items: center; font-size: 0.9rem; font-weight: 600;">
            <span>
                <c:choose>
                    <c:when test="${param.msg == 'upload_success'}">✅ Trabajo guardado correctamente en el repositorio (Semana ${param.week}).</c:when>
                    <c:when test="${param.msg == 'delete_success'}">🗑️ El entregable fue eliminado correctamente.</c:when>
                    <c:when test="${param.msg == 'login_success'}">🔐 Sesión iniciada correctamente. Ya puedes subir o administrar trabajos.</c:when>
                    <c:when test="${param.msg == 'logged_out'}">👋 Sesión cerrada correctamente.</c:when>
                    <c:otherwise>✅ Operación completada correctamente.</c:otherwise>
                </c:choose>
            </span>
            <button type="button" onclick="this.parentElement.remove()" style="background: transparent; border: none; color: #34d399; cursor: pointer; font-size: 1rem;">✕</button>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div id="errorAlert" style="background: rgba(239, 68, 68, 0.15); border: 1px solid rgba(239, 68, 68, 0.4); color: #f87171; padding: 0.9rem 1.25rem; border-radius: 12px; margin-bottom: 1.25rem; display: flex; justify-content: space-between; align-items: center; font-size: 0.9rem; font-weight: 600;">
            <span>
                <c:choose>
                    <c:when test="${param.error == 'upload_failed'}">⚠️ No se pudo subir el archivo. Verifica el tamaño o intenta nuevamente.</c:when>
                    <c:when test="${param.error == 'no_file_selected'}">⚠️ Debes seleccionar un archivo antes de subir.</c:when>
                    <c:when test="${param.error == 'delete_failed'}">⚠️ No se pudo eliminar el entregable.</c:when>
                    <c:otherwise>⚠️ Ocurrió un error al procesar la solicitud.</c:otherwise>
                </c:choose>
            </span>
            <button type="button" onclick="this.parentElement.remove()" style="background: transparent; border: none; color: #f87171; cursor: pointer; font-size: 1rem;">✕</button>
        </div>
    </c:if>

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

    <!-- PESTAÑA 2: UNIDADES (4 MÓDULOS COMO ATAJOS) Y VISTA DEDICADA POR MÓDULO -->
    <div id="sec-unidades" class="tab-pane" style="display: none;">
        <!-- VISTA 1: LOS 4 MÓDULOS / UNIDADES COMO ATAJOS -->
        <div id="unitsOverview" class="card">
            <div class="card-title-row">
                <div>
                    <h2>Módulos Académicos del Curso (Sílabo Oficial)</h2>
                    <p style="font-size: 0.82rem; color: var(--text-secondary); margin-top: 0.2rem;">Haz clic en cualquier módulo para abrir su ventana con sus 4 semanas, introducción, video guía y entregables.</p>
                </div>
                <span style="font-size: 0.8rem; color: var(--text-secondary);">4 Módulos &bull; 16 Semanas</span>
            </div>

            <div class="units-grid">
                <c:forEach var="u" items="${unidades}">
                    <div class="unit-card" onclick="openUnitModule(${u.numero})" title="Abrir Módulo ${u.numero}">
                        <div>
                            <span class="unit-badge">MÓDULO ${u.numero} &bull; SEMANAS ${((u.numero-1)*4)+1}-${u.numero*4}</span>
                            <h3 style="font-size: 0.95rem; font-weight: 700; margin-bottom: 0.4rem;">${u.nombre}</h3>
                            <p style="font-size: 0.8rem; color: var(--text-secondary);">${u.descripcion}</p>
                        </div>
                        <div>
                            <div class="progress-track">
                                <div class="progress-fill" style="width: ${(u.semanasCompletadas / 4.0) * 100}%;"></div>
                            </div>
                            <div style="display: flex; justify-content: space-between; font-size: 0.775rem; color: var(--text-accent); font-weight: 700;">
                                <span>Progreso: ${Math.round((u.semanasCompletadas / 4.0) * 100)}%</span>
                                <span>${u.semanasCompletadas} / 4 Semanas</span>
                            </div>
                            <div class="unit-shortcut-hint">↘ Abrir ventana del Módulo ${u.numero}</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- VISTA 2: VENTANA DEDICADA DEL MÓDULO SELECCIONADO (4 SEMANAS) -->
        <div id="unitModuleView" class="card" style="padding: 0; overflow: hidden; display: none;">
            <div class="module-nav-bar">
                <div style="display: flex; align-items: center; gap: 0.85rem; flex-wrap: wrap;">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="closeUnitModule()">
                        ← Volver a los 4 Módulos
                    </button>
                    <div>
                        <h2 id="moduleViewTitle" style="font-size: 1.15rem; font-weight: 800; color: #ffffff;">Módulo 1</h2>
                        <p id="moduleViewSubtitle" style="font-size: 0.8rem; color: var(--text-secondary);">Semanas 1 a 4</p>
                    </div>
                </div>

                <div class="module-pills">
                    <button type="button" class="module-pill" data-module="1" onclick="openUnitModule(1)">Módulo 1</button>
                    <button type="button" class="module-pill" data-module="2" onclick="openUnitModule(2)">Módulo 2</button>
                    <button type="button" class="module-pill" data-module="3" onclick="openUnitModule(3)">Módulo 3</button>
                    <button type="button" class="module-pill" data-module="4" onclick="openUnitModule(4)">Módulo 4</button>
                </div>
            </div>

            <div style="padding: 1rem 1.5rem; border-bottom: 1px solid var(--border-card); display: flex; flex-wrap: wrap; gap: 0.75rem; justify-content: space-between; align-items: center;">
                <div style="display: flex; flex-wrap: wrap; gap: 0.6rem; align-items: center;">
                    <input type="text" id="searchEntregables" class="form-control" placeholder="🔍 Buscar en este módulo..." oninput="filterEntregables()" style="width: 240px; padding: 0.45rem 0.75rem; font-size: 0.85rem;">
                    <select id="filterEstado" class="form-control" onchange="filterEntregables()" style="width: 170px; padding: 0.45rem 0.75rem; font-size: 0.85rem;">
                        <option value="all">Todas las semanas</option>
                        <option value="done">Solo disponibles</option>
                        <option value="pending">Sin entregables</option>
                    </select>
                </div>
                <button type="button" class="btn btn-primary btn-sm" onclick="openTab('sec-admin')">
                    ➕ Subir Nuevo Trabajo
                </button>
            </div>

            <div class="weeks-stack" id="weeksStack">
                <c:forEach var="semIndex" begin="1" end="16">
                    <c:set var="unitNum" value="${semIndex <= 4 ? 1 : (semIndex <= 8 ? 2 : (semIndex <= 12 ? 3 : 4))}" />
                    <c:set var="ytId" value="${RepositorioDAO.getVideoIdSemana(semIndex)}" />
                    <c:set var="tieneArchivos" value="false" />
                    <c:set var="countSemana" value="0" />
                    <c:set var="fechaSemana" value="" />
                    <c:forEach var="e" items="${entregables}">
                        <c:if test="${e.semana == semIndex}">
                            <c:set var="tieneArchivos" value="true" />
                            <c:set var="countSemana" value="${countSemana + 1}" />
                            <c:if test="${empty fechaSemana && not empty e.fechaSubida}">
                                <c:set var="fechaSemana" value="${e.fechaSubida}" />
                            </c:if>
                        </c:if>
                    </c:forEach>

                    <div class="week-hud-card" id="semana-${semIndex}" data-unit="${unitNum}" data-status="${tieneArchivos ? 'done' : 'pending'}">
                        <div class="week-hud-header">
                            <div>
                                <div class="week-hud-title">Semana ${semIndex}</div>
                                <div class="week-hud-meta">
                                    <span>📅</span>
                                    <c:choose>
                                        <c:when test="${not empty fechaSemana}">
                                            <span><fmt:formatDate value="${fechaSemana}" pattern="yyyy-MM-dd" /></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>2026-I &bull; Pendiente</span>
                                        </c:otherwise>
                                    </c:choose>
                                    <span>&bull;</span>
                                    <span>${countSemana} ${countSemana == 1 ? 'archivo' : 'archivos'}</span>
                                </div>
                            </div>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="openUploadForWeek(${semIndex})">
                                ➕ Agregar Trabajo
                            </button>
                        </div>

                        <div class="week-top-grid">
                            <div>
                                <p class="week-hud-desc" style="margin-bottom: 0.65rem; font-weight: 600; color: #f1f5f9;">${RepositorioDAO.getTemaSemana(semIndex)}</p>
                                <div class="week-intro-box" style="margin-bottom: 0;">
                                    💡 <strong>Introducción:</strong> ${RepositorioDAO.getIntroduccionSemana(semIndex)}
                                </div>
                            </div>

                            <!-- CUADRO CON MINIATURA DEL VIDEO DE YOUTUBE -->
                            <div class="yt-thumb-card"
                                 data-videoid="${ytId}"
                                 data-title="Semana ${semIndex} - Video Guía"
                                 onclick="openVideoModalFromBtn(this)"
                                 title="Reproducir video relacionado de YouTube">
                                <img src="https://img.youtube.com/vi/${ytId}/hqdefault.jpg" alt="Video Semana ${semIndex}" loading="lazy">
                                <div class="yt-play-badge">▶</div>
                                <div class="yt-thumb-caption">🎬 Video Guía &bull; Semana ${semIndex}</div>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${tieneArchivos}">
                                <div class="attachments-label">
                                    <span>📎</span>
                                    <span>ARCHIVOS ADJUNTOS</span>
                                </div>

                                <div class="attachments-grid">
                                    <c:forEach var="e" items="${entregables}">
                                        <c:if test="${e.semana == semIndex}">
                                            <c:set var="fullUrl" value="${e.archivoUrl.startsWith('http://') || e.archivoUrl.startsWith('https://') || e.archivoUrl.startsWith('/') ? e.archivoUrl : pageContext.request.contextPath.concat('/').concat(e.archivoUrl)}" />
                                            <c:set var="downloadUrl" value="${fn:contains(fullUrl, 'archivo?id=') ? fullUrl.concat('&download=1') : fullUrl}" />
                                            <c:set var="lowerName" value="${fn:toLowerCase(e.nombreArchivo)}" />
                                            <c:set var="isImage" value="${fn:endsWith(lowerName, '.jpg') || fn:endsWith(lowerName, '.jpeg') || fn:endsWith(lowerName, '.png') || fn:endsWith(lowerName, '.gif') || fn:endsWith(lowerName, '.webp')}" />
                                            <c:set var="isPdf" value="${fn:endsWith(lowerName, '.pdf')}" />
                                            <c:set var="isSql" value="${fn:endsWith(lowerName, '.sql')}" />

                                            <div class="attachment-card">
                                                <!-- MINIATURA / VISTA PREVIA -->
                                                <div class="attachment-thumb"
                                                     data-url="${fn:escapeXml(fullUrl)}"
                                                     data-title="${fn:escapeXml(e.tituloTrabajo)}"
                                                     data-filename="${fn:escapeXml(e.nombreArchivo)}"
                                                     onclick="openDocViewerFromBtn(this)">
                                                    <c:choose>
                                                        <c:when test="${isImage}">
                                                            <img src="${fn:escapeXml(fullUrl)}" alt="${fn:escapeXml(e.tituloTrabajo)}" loading="lazy">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="attachment-thumb-doc">
                                                                <span class="doc-badge ${isPdf ? 'pdf' : (isSql ? 'sql' : '')}">
                                                                    ${isPdf ? 'PDF' : (isSql ? 'SQL' : 'ARCHIVO')}
                                                                </span>
                                                                <span class="doc-filename">${fn:escapeXml(e.nombreArchivo)}</span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- TÍTULO DEL TRABAJO -->
                                                <div class="attachment-title" title="${fn:escapeXml(e.tituloTrabajo)}">
                                                    ${fn:escapeXml(e.tituloTrabajo)}
                                                </div>

                                                <!-- BOTONES VER Y DESCARGAR -->
                                                <div class="attachment-actions">
                                                    <button type="button"
                                                            class="btn-hud btn-hud-view"
                                                            data-url="${fn:escapeXml(fullUrl)}"
                                                            data-title="${fn:escapeXml(e.tituloTrabajo)}"
                                                            data-filename="${fn:escapeXml(e.nombreArchivo)}"
                                                            onclick="openDocViewerFromBtn(this)">
                                                        👁️ VER
                                                    </button>
                                                    <a href="${fn:escapeXml(downloadUrl)}"
                                                       target="_blank"
                                                       class="btn-hud btn-hud-download"
                                                       download="${fn:escapeXml(e.nombreArchivo)}">
                                                        ⬇️ DESCARGAR
                                                    </a>
                                                </div>

                                                <!-- ACCIONES EXTRA (FIGMA / ELIMINAR) -->
                                                <c:if test="${e.semana == 8 || fn:contains(fn:toLowerCase(e.tituloTrabajo), 'figma') || not empty sessionScope.usuario}">
                                                    <div class="attachment-extra-actions">
                                                        <c:if test="${e.semana == 8 || fn:contains(fn:toLowerCase(e.tituloTrabajo), 'figma')}">
                                                            <a href="https://www.figma.com/design/kpkKx5iSVkcJjIFDCHov37/Sin-t%C3%ADtulo?node-id=2-3&t=NW402MHREiENVPpl-0" target="_blank" rel="noopener noreferrer" class="btn btn-sm" style="flex:1; justify-content:center; background: linear-gradient(135deg, #a259ff, #f24e1e); color: #fff; font-weight: 700; border: none; text-decoration: none;">
                                                                🎨 Prototipo Figma
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${not empty sessionScope.usuario}">
                                                            <form action="${pageContext.request.contextPath}/upload" method="post" style="display: inline;" onsubmit="return confirm('¿Eliminar el trabajo?');">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="id" value="${e.id}">
                                                                <button type="submit" class="btn btn-danger btn-sm" title="Eliminar trabajo">
                                                                    🗑️
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="week-empty-box">
                                    <span class="status-pill status-wait">⌛ Sin entregables aún para esta semana</span>
                                    <button type="button" class="btn btn-primary btn-sm" onclick="openUploadForWeek(${semIndex})">
                                        ➕ Subir Entregable
                                    </button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:forEach>
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
                            <label class="form-label">Adjuntar Archivo(s) o Imagen(es) (PDF, PNG, JPG, SQL, DOCX, ZIP — puedes seleccionar varios a la vez):</label>
                            <input type="file" name="archivo" class="form-control" multiple required>
                        </div>

                        <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">
                            📤 Cargar Trabajo(s) al Repositorio Supabase
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
    <div id="docViewerModal" class="modal-backdrop" onclick="if (event.target === this) closeDocViewer();">
        <div class="modal-window">
            <div class="modal-header">
                <h3 id="modalDocTitle" style="font-size: 1rem; color: #ffffff; margin: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 65%;">Visor de Documentos UPLA</h3>
                <div style="display: flex; gap: 0.5rem; align-items: center;">
                    <a id="modalOpenNewTab" href="#" target="_blank" rel="noopener noreferrer" class="btn btn-primary btn-sm" style="text-decoration: none;">
                        ↗️ Abrir en Pestaña
                    </a>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="closeDocViewer()">✕ Cerrar Visor</button>
                </div>
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
        <p style="margin-top: 0.5rem; font-size: 0.78rem;">
            <c:set var="dbErr" value="${RepositorioDAO.getUltimoErrorBD()}" />
            <c:choose>
                <c:when test="${empty dbErr}">
                    <span style="color: #34d399;">🟢 Conectado a Supabase PostgreSQL (Persistencia activa)</span>
                </c:when>
                <c:otherwise>
                    <span style="color: #f87171;">🔴 Modo Memoria Temporal (Sin conexión a Supabase: ${fn:escapeXml(dbErr)})</span>
                </c:otherwise>
            </c:choose>
        </p>
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
    function openDocViewerFromBtn(btn) {
        const url = btn.getAttribute("data-url") || "";
        const title = btn.getAttribute("data-title") || "Documento";
        const filename = btn.getAttribute("data-filename") || url;
        openDocViewer(url, title, filename);
    }

    function openDocViewer(url, title, filename) {
        const modal = document.getElementById("docViewerModal");
        const modalTitle = document.getElementById("modalDocTitle");
        const openNewTabLink = document.getElementById("modalOpenNewTab");
        const container = document.getElementById("modalDocContainer");

        modalTitle.textContent = "📖 Viendo: " + title;
        if (openNewTabLink) {
            openNewTabLink.href = url;
        }

        const refName = (filename || url || "").toLowerCase();

        if (/\.(jpeg|jpg|gif|png|webp)$/i.test(refName)) {
            container.innerHTML = '';
            const img = document.createElement("img");
            img.src = url;
            img.alt = title;
            img.style.maxWidth = "100%";
            img.style.maxHeight = "540px";
            img.style.objectFit = "contain";
            img.style.borderRadius = "8px";
            container.appendChild(img);
        } else if (/\.sql$/i.test(refName)) {
            container.innerHTML = '<div style="text-align:center; padding: 2rem; color: #94a3b8;">Cargando script SQL...</div>';
            fetch(url)
                .then(r => r.text())
                .then(sql => {
                    const escaped = sql.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                    container.innerHTML = '<pre style="max-height: 540px; width: 100%; overflow: auto; background: #0f172a; padding: 1.25rem; border-radius: 8px; color: #38bdf8; font-family: monospace; font-size: 0.85rem; line-height: 1.5; text-align: left; border: 1px solid rgba(255,255,255,0.1); white-space: pre-wrap; word-break: break-all;"><code>' + escaped + '</code></pre>';
                })
                .catch(() => {
                    container.innerHTML = '<iframe src="' + url + '" width="100%" height="550px" style="border:none; border-radius: 8px;"></iframe>';
                });
        } else if (/\.pdf$/i.test(refName) || url.toLowerCase().includes("pdf") || url.includes("archivo?id=")) {
            container.innerHTML = '';
            const iframe = document.createElement("iframe");
            iframe.src = url + (url.includes("#") ? "" : "#view=FitH");
            iframe.title = title;
            iframe.style.width = "100%";
            iframe.style.height = "550px";
            iframe.style.border = "none";
            iframe.style.borderRadius = "8px";
            iframe.style.background = "#ffffff";
            container.appendChild(iframe);
        } else {
            container.innerHTML = '<div style="text-align:center; padding: 2.5rem; color: #cbd5e1;">' +
                '<p style="margin-bottom: 1rem;">Este formato de archivo no admite vista previa directa en el navegador.</p>' +
                '<a href="' + url + '" target="_blank" class="btn btn-primary">⬇️ Descargar o Abrir Archivo</a>' +
                '</div>';
        }

        modal.classList.add("active");
    }

    function closeDocViewer() {
        const modal = document.getElementById("docViewerModal");
        const container = document.getElementById("modalDocContainer");
        container.innerHTML = "";
        modal.classList.remove("active");
    }

    var myChart = null;

    function renderChart() {
        const canvas = document.getElementById('unidadesChart');
        if (!canvas) return;

        if (myChart) {
            myChart.destroy();
        }
        
        try {
            const ctx = canvas.getContext('2d');
            const labels = [];
            const dataCompletadas = [];
            
            <c:forEach var="u" items="${unidades}">
                labels.push('Unidad ${u.numero}');
                dataCompletadas.push(${u.semanasCompletadas});
            </c:forEach>

            myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Semanas Completadas por Unidad',
                        data: dataCompletadas,
                        backgroundColor: [
                            'rgba(18, 140, 112, 0.85)',
                            'rgba(210, 105, 30, 0.85)',
                            'rgba(230, 174, 39, 0.85)',
                            'rgba(161, 73, 125, 0.85)'
                        ],
                        borderColor: [
                            '#2aa889',
                            '#d2691e',
                            '#e6ae27',
                            '#a1497d'
                        ],
                        borderWidth: 2,
                        borderRadius: 8
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
            console.log("Error rendering chart:", e);
        }
    }

    var currentModule = 0;

    const MODULE_NAMES = {
        1: "Módulo 1: Fundamentos y Estándares de Arquitectura",
        2: "Módulo 2: Modelado de Arquitecturas con POO y Vistas 4+1",
        3: "Módulo 3: Comunicación, Integración y Servicios Web REST",
        4: "Módulo 4: Frameworks Modernos y Despliegue en Cloud"
    };

    function openUnitModule(unitNum) {
        currentModule = Number(unitNum);
        const overview = document.getElementById("unitsOverview");
        const moduleView = document.getElementById("unitModuleView");
        const titleEl = document.getElementById("moduleViewTitle");
        const subEl = document.getElementById("moduleViewSubtitle");

        if (overview) overview.style.display = "none";
        if (moduleView) moduleView.style.display = "block";

        const startWeek = (currentModule - 1) * 4 + 1;
        const endWeek = currentModule * 4;
        if (titleEl) titleEl.textContent = MODULE_NAMES[currentModule] || ("Módulo " + currentModule);
        if (subEl) subEl.textContent = "Semanas " + startWeek + " a " + endWeek + " • Introducción, Video Guía y Entregables";

        document.querySelectorAll(".module-pill").forEach(function(pill) {
            pill.classList.toggle("active", Number(pill.getAttribute("data-module")) === currentModule);
        });

        const search = document.getElementById("searchEntregables");
        const filter = document.getElementById("filterEstado");
        if (search) search.value = "";
        if (filter) filter.value = "all";

        filterEntregables();
        window.scrollTo({ top: 0, behavior: "smooth" });
    }

    function closeUnitModule() {
        currentModule = 0;
        const overview = document.getElementById("unitsOverview");
        const moduleView = document.getElementById("unitModuleView");
        if (moduleView) moduleView.style.display = "none";
        if (overview) overview.style.display = "block";
    }

    function openVideoModalFromBtn(btn) {
        const videoId = btn.getAttribute("data-videoid");
        const title = btn.getAttribute("data-title") || "Video relacionado";
        openVideoModal(videoId, title);
    }

    function openVideoModal(videoId, title) {
        const modal = document.getElementById("docViewerModal");
        const modalTitle = document.getElementById("modalDocTitle");
        const openNewTabLink = document.getElementById("modalOpenNewTab");
        const container = document.getElementById("modalDocContainer");

        const watchUrl = "https://www.youtube.com/watch?v=" + videoId;
        const embedUrl = "https://www.youtube.com/embed/" + videoId + "?autoplay=1&rel=0";

        modalTitle.textContent = "🎬 " + title;
        if (openNewTabLink) {
            openNewTabLink.href = watchUrl;
        }

        container.innerHTML = "";
        const iframe = document.createElement("iframe");
        iframe.src = embedUrl;
        iframe.title = title;
        iframe.allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture";
        iframe.allowFullscreen = true;
        iframe.style.width = "100%";
        iframe.style.height = "550px";
        iframe.style.border = "none";
        iframe.style.borderRadius = "8px";
        container.appendChild(iframe);

        modal.classList.add("active");
    }

    function openUploadForWeek(semana) {
        openTab('sec-admin');
        const select = document.querySelector('#sec-admin select[name="semana"]');
        if (select) {
            select.value = String(semana);
        }
    }

    function filterEntregables() {
        const query = (document.getElementById("searchEntregables")?.value || "").toLowerCase().trim();
        const estado = document.getElementById("filterEstado")?.value || "all";
        const cards = document.querySelectorAll(".week-hud-card");

        cards.forEach(function(card) {
            const cardUnit = Number(card.getAttribute("data-unit"));
            if (currentModule > 0 && cardUnit !== currentModule) {
                card.style.display = "none";
                return;
            }
            const text = card.textContent.toLowerCase();
            const cardStatus = card.getAttribute("data-status");
            const matchesText = !query || text.includes(query);
            const matchesEstado = estado === "all" || cardStatus === estado;
            card.style.display = (matchesText && matchesEstado) ? "" : "none";
        });
    }

    document.addEventListener("DOMContentLoaded", function() {
        renderChart();
        const params = new URLSearchParams(window.location.search);
        const msg = params.get("msg");
        const err = params.get("error");
        const weekParam = Number(params.get("week") || 0);
        if (msg === "upload_success" || msg === "delete_success" || err === "upload_failed" || err === "delete_failed" || err === "no_file_selected") {
            openTab("sec-unidades");
            if (weekParam >= 1 && weekParam <= 16) {
                const targetUnit = Math.ceil(weekParam / 4);
                openUnitModule(targetUnit);
            }
        }

        // Halo de linterna verde siguiendo suavemente al mouse
        const glow = document.getElementById("greenLanternGlow");
        if (glow) {
            let targetX = window.innerWidth / 2, targetY = window.innerHeight / 2;
            let currentX = targetX, currentY = targetY;
            let animating = false;

            function updateGlow() {
                currentX += (targetX - currentX) * 0.16;
                currentY += (targetY - currentY) * 0.16;
                glow.style.setProperty("--mx", currentX + "px");
                glow.style.setProperty("--my", currentY + "px");
                if (Math.abs(targetX - currentX) > 0.5 || Math.abs(targetY - currentY) > 0.5) {
                    requestAnimationFrame(updateGlow);
                } else {
                    animating = false;
                }
            }

            document.addEventListener("mousemove", function(e) {
                targetX = e.clientX;
                targetY = e.clientY;
                glow.style.opacity = "1";
                if (!animating) {
                    animating = true;
                    requestAnimationFrame(updateGlow);
                }
            });

            document.addEventListener("mouseleave", function() {
                glow.style.opacity = "0";
            });
        }
    });
</script>

</body>
</html>
