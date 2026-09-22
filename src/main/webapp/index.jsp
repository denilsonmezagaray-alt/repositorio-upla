<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="pe.edu.upla.repositorio.dao.RepositorioDAO" %>
<!--
  =============================================================================
  REPOSITORIO UNIVERSITARIO UPLA - ARQUITECTURA DE SOFTWARE 2026-I
  Estudiante / Autor: Alessander (Ingeniería de Sistemas y Computación)
  Docente: Mg. Raúl Enrique Fernández Bejarano
  Vista Principal: index.jsp (Cyberpunk Neon Academic Glassmorphism System)
  =============================================================================
-->
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portafolio Académico Digital | Arquitectura de Software 2026-I - UPLA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<div class="container">
    <!-- TOP BAR DE NAVEGACIÓN Y ESTADO DEL SISTEMA -->
    <header class="top-bar">
        <div class="top-brand">
            <div class="upla-hexagon-logo">UPLA</div>
            <div class="top-brand-text">
                <h1>UNIVERSIDAD PERUANA LOS ANDES</h1>
                <p>FACULTAD DE INGENIERÍA // EPISC &bull; ARQUITECTURA DE SOFTWARE 2026-I</p>
            </div>
        </div>

        <div class="system-status-pills">
            <span class="status-tag status-cyan">
                <span style="width: 8px; height: 8px; background: var(--neon-cyan); border-radius: 50%; display: inline-block;"></span>
                ARCHIVOS EN BD: ${totalSubidos} / 16
            </span>
            <span class="status-tag status-cyan">PORT: 8080</span>
            
            <c:choose>
                <c:when test="${not empty sessionScope.usuario}">
                    <span class="status-tag status-pink">⚡ MODO EDICIÓN (ALUMNO)</span>
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline" style="padding: 0.35rem 0.8rem; font-size: 0.75rem;">Cerrar Sesión</a>
                </c:when>
                <c:otherwise>
                    <span class="status-tag status-cyan">👁️ MODO AUDITOR (LECTURA)</span>
                    <a href="${pageContext.request.contextPath}/auth" class="btn btn-pink" style="padding: 0.4rem 0.9rem; font-size: 0.775rem;">
                        ⚡ ACCESO ALUMNO (MODIFICAR)
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <!-- ALERTAS Y MENSAJES -->
    <c:if test="${param.msg == 'login_success'}">
        <div style="background: rgba(0, 255, 157, 0.15); border: 1px solid var(--neon-mint); color: var(--neon-mint); padding: 1rem 1.25rem; border-radius: 14px; margin-bottom: 1.5rem; font-size: 0.9rem;">
            ⚡ Bienvenido de nuevo, <strong>${sessionScope.usuario.nombre}</strong>. Has iniciado sesión con permisos de edición completa.
        </div>
    </c:if>
    <c:if test="${param.msg == 'upload_success'}">
        <div style="background: rgba(0, 242, 254, 0.15); border: 1px solid var(--neon-cyan); color: var(--neon-cyan); padding: 1rem 1.25rem; border-radius: 14px; margin-bottom: 1.5rem; font-size: 0.9rem;">
            🚀 ¡Entregable cargado exitosamente a Supabase Storage para la <strong>Semana ${param.week}</strong>!
        </div>
    </c:if>
    <c:if test="${param.msg == 'delete_success'}">
        <div style="background: rgba(255, 0, 127, 0.15); border: 1px solid var(--neon-pink); color: var(--neon-pink); padding: 1rem 1.25rem; border-radius: 14px; margin-bottom: 1.5rem; font-size: 0.9rem;">
            🗑️ Entregable de la <strong>Semana ${param.week}</strong> eliminado exitosamente.
        </div>
    </c:if>

    <!-- HEADER BANNER PRINCIPAL OFICIAL DEL CURSO -->
    <section class="header-banner">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
                <div class="banner-subhead">
                    <span style="display: inline-block; width: 6px; height: 6px; background: var(--neon-cyan); border-radius: 50%;"></span>
                    // PORTAFOLIO ACADÉMICO DIGITAL OFICIAL
                </div>
                <h1 class="banner-title">ARQUITECTURA DE SOFTWARE 2026–I</h1>
                <p class="banner-desc">
                    Evidencias de aprendizaje, requerimientos de calidad (ISO/IEC 25010), modelos de 4+1 vistas, diseño por capas, APIs RESTful en Jakarta EE / Java EE y persistencia relacional PostgreSQL con Supabase.
                </p>
                <div class="meta-tags-row">
                    <span class="meta-pill">📇 Código: <strong>332181</strong></span>
                    <span class="meta-pill">📜 Plan: <strong>2022</strong></span>
                    <span class="meta-pill">⭐ Créditos: <strong>02</strong></span>
                    <span class="meta-pill">⏱️ Horas: <strong>04 Prácticas</strong></span>
                    <span class="meta-pill">📍 Modalidad: <strong>Presencial</strong></span>
                    <span class="meta-pill">🎓 Facultad: <strong>Ingeniería // EPISC</strong></span>
                </div>
            </div>

            <!-- LOGO INSIGNIA UPLA EN HEADER -->
            <div style="text-align: center; background: rgba(0, 0, 0, 0.4); padding: 1.2rem; border-radius: 18px; border: 1px solid var(--border-glow);">
                <div class="upla-hexagon-logo" style="width: 64px; height: 64px; font-size: 1.35rem; margin: 0 auto 0.5rem auto;">UPLA</div>
                <div style="font-family: 'JetBrains Mono', monospace; font-size: 0.7rem; color: var(--neon-cyan); font-weight: 700;">UPLA &bull; HUANCAYO</div>
            </div>
        </div>
    </section>

    <!-- TARJETAS DE INFORMACIÓN: ALUMNO Y DOCENTE -->
    <div class="info-cards-grid">
        <!-- TARJETA ESTUDIANTE AUTOR -->
        <div class="cyber-card">
            <div class="card-header-user">
                <img src="${not empty sessionScope.usuario ? sessionScope.usuario.fotoUrl : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80'}" alt="Foto Perfil Estudiante" class="avatar-neon">
                <div class="user-title-block">
                    <p>// ESTUDIANTE AUTOR &bull; INGENIERÍA DE SISTEMAS</p>
                    <h3>${not empty sessionScope.usuario ? sessionScope.usuario.nombre : 'Alessander'}</h3>
                    <div style="font-size: 0.8rem; color: var(--text-secondary);">UNIVERSIDAD PERUANA LOS ANDES &bull; HUANCAYO</div>
                </div>
            </div>

            <div class="grid-details-2col">
                <div class="detail-item-box">
                    <div class="detail-label">CARRERA PROFESIONAL</div>
                    <div class="detail-value">Ingeniería de Sistemas y Computación</div>
                </div>
                <div class="detail-item-box">
                    <div class="detail-label">CORREO INSTITUCIONAL</div>
                    <div class="detail-value" style="color: var(--neon-cyan);">s01269h@upla.edu.pe</div>
                </div>
                <div class="detail-item-box">
                    <div class="detail-label">SEMESTRE ACADÉMICO</div>
                    <div class="detail-value">2026-I &bull; Plan de Estudios 2022</div>
                </div>
                <div class="detail-item-box">
                    <div class="detail-label">ROL EN EL SISTEMA</div>
                    <div class="detail-value" style="color: var(--neon-pink);">
                        ${not empty sessionScope.usuario ? 'Administrador / Edición' : 'Modo Auditoria Académica'}
                    </div>
                </div>
            </div>
        </div>

        <!-- TARJETA DOCENTE CÁTEDRA -->
        <div class="cyber-card">
            <div class="card-header-user">
                <div style="width: 68px; height: 68px; border-radius: 50%; background: linear-gradient(135deg, #7928ca, #ff007f); display: flex; align-items: center; justify-content: center; font-size: 2rem; border: 2px solid var(--neon-pink); box-shadow: 0 0 15px var(--neon-pink);">
                    👨‍🏫
                </div>
                <div class="user-title-block">
                    <p>// DIRECCIÓN DOCENTE &bull; CÁTEDRA DE ARQUITECTURA</p>
                    <h3>Mg. Raúl Enrique Fernández Bejarano</h3>
                    <div style="font-size: 0.8rem; color: var(--neon-pink); font-weight: 700;">DOCENTE TITULAR DE LA ASIGNATURA</div>
                </div>
            </div>

            <div class="grid-details-2col">
                <div class="detail-item-box">
                    <div class="detail-label">CORREO OFICIAL CÁTEDRA</div>
                    <div class="detail-value" style="color: var(--neon-cyan);">d.rfernandezb@ms.upla.edu.pe</div>
                </div>
                <div class="detail-item-box">
                    <div class="detail-label">CÓDIGO & CRÉDITOS</div>
                    <div class="detail-value">332181 &bull; 02 Créditos</div>
                </div>
                <div class="detail-item-box">
                    <div class="detail-label">CARGA HORARIA SEMANAL</div>
                    <div class="detail-value">04 Horas Prácticas</div>
                </div>
                <div class="detail-item-box">
                    <div class="detail-label">PERÍODO ACADÉMICO</div>
                    <div class="detail-value">2026-I (06 Abr – 26 Jul 2026)</div>
                </div>
                <div class="detail-item-box">
                    <div class="detail-label">MODALIDAD & FACULTAD</div>
                    <div class="detail-value">Presencial &bull; Pabellón EPISC</div>
                </div>
                <div class="detail-item-box">
                    <div class="detail-label">ESPECIALIDAD DOCENTE</div>
                    <div class="detail-value" style="color: var(--neon-mint);">Arquitectura Cloud & Microservicios</div>
                </div>
            </div>

            <div style="margin-top: 1rem;">
                <a href="mailto:d.rfernandezb@ms.upla.edu.pe" class="btn btn-outline" style="width: 100%; justify-content: center; font-size: 0.825rem;">
                    ✉️ Enviar Consulta al Mg. Raúl Fernández
                </a>
            </div>
        </div>
    </div>

    <!-- SECCIÓN DE REACTORES DE CAPACIDADES (4 UNIDADES CURRICULARES) -->
    <section class="reactors-section">
        <div class="reactors-title-row">
            <div style="font-family: 'JetBrains Mono', monospace; font-size: 0.775rem; color: var(--neon-cyan); letter-spacing: 0.1em; text-transform: uppercase;">
                // PROGRAMACIÓN DE CAPACIDADES
            </div>
            <h2>Reactores de Avance Curricular (4 Unidades Temáticas)</h2>
        </div>

        <div class="reactors-grid">
            <c:forEach var="u" items="${unidades}">
                <div class="reactor-card">
                    <div>
                        <span class="unit-tag-pink">UNIDAD ${u.numero} &bull; SEM ${((u.numero-1)*4)+1}-${u.numero*4}</span>
                        <h4 class="reactor-name">${u.nombre}</h4>
                        <p style="font-size: 0.775rem; color: var(--text-secondary); margin-bottom: 1rem;">${u.descripcion}</p>
                    </div>

                    <div>
                        <div class="reactor-progress-bar">
                            <div class="reactor-progress-fill" style="width: ${(u.semanasCompletadas / 4.0) * 100}%;"></div>
                        </div>
                        <div class="reactor-avance-text">
                            <span>AVANCE: ${Math.round((u.semanasCompletadas / 4.0) * 100)}%</span>
                            <span>${u.semanasCompletadas} / 4 SEMANAS</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- GRID INFERIOR: GRÁFICO CYBER CHART.JS & FORMULARIO SUBIDA -->
    <div class="info-cards-grid">
        <!-- GRÁFICO CHART.JS CON COLORES CYBER NEON -->
        <div class="cyber-card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h3 style="font-size: 1.1rem; font-weight: 800;">Métricas de Avance Curricular</h3>
                <span class="status-tag status-cyan">CHART.JS LIVE</span>
            </div>
            <div style="position: relative; height: 230px; width: 100%;">
                <canvas id="unidadesChart"></canvas>
            </div>
            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 1rem; font-size: 0.85rem;">
                <span style="color: var(--text-secondary);">Progreso Total del Semestre:</span>
                <strong style="color: var(--neon-cyan); font-family: 'JetBrains Mono', monospace; font-size: 1rem;">${porcentajeProgreso}% (${totalSubidos} de 16 Entregables)</strong>
            </div>
        </div>

        <!-- FORMULARIO DE SUBIDA DE ENTREGABLES (SOLO MODO EDICIÓN) O PANEL DE AUDITORÍA -->
        <c:choose>
            <c:when test="${not empty sessionScope.usuario}">
                <div class="cyber-card" style="border-color: var(--neon-pink);">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 800; color: var(--neon-pink);">Gestor de Carga de Entregables</h3>
                        <span class="status-tag status-pink">SUPABASE STORAGE</span>
                    </div>

                    <form action="${pageContext.request.contextPath}/upload" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="form-label">Seleccionar Semana del Sílabo (1 a 16):</label>
                            <select name="semana" class="form-control" required>
                                <c:forEach var="item" items="${entregables}">
                                    <option value="${item.semana}">
                                        Semana ${item.semana}: ${RepositorioDAO.getTemaSemana(item.semana)} - [${item.completado ? 'Completado' : 'Pendiente'}]
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Adjuntar Documento o Evidencia (PDF, ZIP, DOCX, PNG):</label>
                            <input type="file" name="archivo" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-pink" style="width: 100%; justify-content: center; margin-top: 0.5rem;">
                            ⚡ Cargar Entregable a Supabase Cloud
                        </button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cyber-card" style="display: flex; flex-direction: column; justify-content: space-between;">
                    <div>
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                            <h3 style="font-size: 1.1rem; font-weight: 800;">Panel de Lectura y Auditoría UPLA</h3>
                            <span class="status-tag status-cyan">SOLO LECTURA</span>
                        </div>
                        <p style="font-size: 0.875rem; color: var(--text-secondary); margin-bottom: 1.25rem;">
                            Este portafolio digital contiene todas las evidencias de aprendizaje, informes arquitectónicos y diagramas de la asignatura <strong>Arquitectura de Software (2026-I)</strong>.
                        </p>
                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 0.75rem; text-align: center;">
                            <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); padding: 0.85rem; border-radius: 12px;">
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--neon-cyan);">4</div>
                                <div style="font-size: 0.7rem; color: var(--text-muted);">UNIDADES</div>
                            </div>
                            <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); padding: 0.85rem; border-radius: 12px;">
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--neon-pink);">16</div>
                                <div style="font-size: 0.7rem; color: var(--text-muted);">SEMANAS</div>
                            </div>
                            <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); padding: 0.85rem; border-radius: 12px;">
                                <div style="font-size: 1.5rem; font-weight: 800; color: var(--neon-mint);">${totalSubidos}</div>
                                <div style="font-size: 0.7rem; color: var(--text-muted);">EVIDENCIAS</div>
                            </div>
                        </div>
                    </div>
                    <div style="margin-top: 1.5rem;">
                        <a href="${pageContext.request.contextPath}/auth" class="btn btn-cyan" style="width: 100%; justify-content: center;">
                            🔐 Acceso Alumno para Modificar (Alessander)
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- TABLA DE LAS 16 SEMANAS DEL SÍLABO OFICIAL -->
    <div class="table-card">
        <div style="padding: 1.5rem 1.5rem 1rem 1.5rem; display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h2 style="font-size: 1.2rem; font-weight: 800; color: var(--text-primary);">Programación de las 16 Semanas Académicas</h2>
                <p style="font-size: 0.8rem; color: var(--text-secondary);">Sílabo de la Asignatura Arquitectura de Software &bull; Modalidad Presencial UPLA</p>
            </div>
            <span class="status-tag status-cyan">
                ${not empty sessionScope.usuario ? 'MODO ALUMNO (EDICIÓN ACTIVA)' : 'MODO AUDITOR (LECTURA PÚBLICA)'}
            </span>
        </div>

        <div style="overflow-x: auto;">
            <table class="weeks-table">
                <thead>
                    <tr>
                        <th>Sem.</th>
                        <th>Tema del Sílabo Oficial</th>
                        <th>Unidad</th>
                        <th>Estado</th>
                        <th>Archivo Adjunto</th>
                        <th style="text-align: right;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="e" items="${entregables}">
                        <tr>
                            <td>
                                <span class="week-num-badge">Sem ${e.semana}</span>
                            </td>
                            <td>
                                <strong style="color: var(--text-primary); font-size: 0.875rem;">
                                    ${RepositorioDAO.getTemaSemana(e.semana)}
                                </strong>
                            </td>
                            <td>
                                <span style="font-family: 'JetBrains Mono', monospace; font-size: 0.75rem; color: var(--text-muted);">
                                    Unidad ${e.unidadNumero}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${e.completado}">
                                        <span class="status-pill-completed">✓ Completado</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill-pending">⌛ Pendiente</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${e.completado}">
                                        <span style="font-size: 0.825rem; color: var(--neon-cyan); word-break: break-all;">
                                            📄 ${e.nombreArchivo}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="font-size: 0.8rem; color: var(--text-muted); font-style: italic;">Sin entregables</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: right;">
                                <div style="display: flex; gap: 0.4rem; justify-content: flex-end;">
                                    <c:if test="${e.completado}">
                                        <a href="${e.archivoUrl}" target="_blank" class="btn btn-outline" style="padding: 0.35rem 0.75rem; font-size: 0.775rem;">
                                            ⬇️ Descargar
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty sessionScope.usuario and e.completado}">
                                        <form action="${pageContext.request.contextPath}/upload" method="post" style="display: inline;" onsubmit="return confirm('¿Eliminar la evidencia de la Semana ${e.semana}?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="semana" value="${e.semana}">
                                            <button type="submit" class="btn btn-danger-sm">
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

    <!-- PIE DE PÁGINA -->
    <footer class="footer">
        <p><strong>UNIVERSIDAD PERUANA LOS ANDES &bull; FACULTAD DE INGENIERÍA // EPISC</strong></p>
        <p>Portafolio Académico Digital de Arquitectura de Software 2026-I &bull; Desarrollado por <strong>Alessander</strong></p>
    </footer>
</div>

<!-- GRÁFICO CHART.JS CON ESTILO CYBER NEON -->
<script>
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
                    label: 'Semanas Completadas (de 4)',
                    data: dataCompletadas,
                    backgroundColor: [
                        'rgba(0, 242, 254, 0.85)',
                        'rgba(0, 255, 157, 0.85)',
                        'rgba(157, 0, 255, 0.85)',
                        'rgba(255, 0, 127, 0.85)'
                    ],
                    borderColor: [
                        '#00f2fe',
                        '#00ff9d',
                        '#9d00ff',
                        '#ff007f'
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
                        max: 4,
                        ticks: {
                            stepSize: 1,
                            color: '#a0aec0',
                            font: { family: 'JetBrains Mono' }
                        },
                        grid: { color: 'rgba(255, 255, 255, 0.06)' }
                    },
                    x: {
                        ticks: {
                            color: '#a0aec0',
                            font: { family: 'Plus Jakarta Sans', weight: '700' }
                        },
                        grid: { display: false }
                    }
                },
                plugins: {
                    legend: {
                        labels: {
                            color: '#ffffff',
                            font: { family: 'Plus Jakarta Sans', weight: '700' }
                        }
                    }
                }
            }
        });
    });
</script>

</body>
</html>
