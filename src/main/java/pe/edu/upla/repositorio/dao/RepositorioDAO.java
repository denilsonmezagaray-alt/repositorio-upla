package pe.edu.upla.repositorio.dao;

import pe.edu.upla.repositorio.model.Entregable;
import pe.edu.upla.repositorio.model.Unidad;
import pe.edu.upla.repositorio.model.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO con JDBC Puro a Supabase PostgreSQL y Almacenamiento en Memoria
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander Meza Garay (Código: r03396b)
 * Docente: Mg. Raúl Enrique Fernández Bejarano
 * Curso: Arquitectura de Software (Código: 332181)
 */
public class RepositorioDAO {
    private static final Logger LOGGER = Logger.getLogger(RepositorioDAO.class.getName());

    private static List<Entregable> MEMORIA_ENTREGABLES = null;
    private static final java.util.Map<Integer, ArchivoData> MEMORIA_ARCHIVOS = new java.util.concurrent.ConcurrentHashMap<>();
    private static final AtomicInteger AUTO_ID = new AtomicInteger(100);
    private static volatile String ultimoErrorBD = null;

    public static String getUltimoErrorBD() {
        return ultimoErrorBD;
    }

    private static final String[] TEMAS_SILABO = {
        "Semana 01: Introducción a la Arquitectura de Software y Conceptos Fundamentales",
        "Semana 02: Principios, Atributos de Calidad (ISO/IEC 25010) y Estándares",
        "Semana 03: Estilos y Patrones Arquitectónicos (Capas, MVC, Cliente-Servidor)",
        "Semana 04: Documentación y Representación Arquitectónica (Modelos 4+1 Vistas)",
        "Semana 05: Principios de Programación Orientada a Objetos aplicados a la Arquitectura",
        "Semana 06: Modelado Arquitectónico con UML (Casos de Uso, Clases y Paquetes)",
        "Semana 07: Diseño físico de la base de datos de la aplicación en un repositorio (Ejemplo: Ms. Azure)",
        "Semana 08: Diseño del front-end utilizando una herramienta (Ejemplo: Figma)",
        "Semana 09: Fundamentos de la Comunicación entre Arquitecturas de Software",
        "Semana 10: Métodos y Tecnologías para Integración de Sistemas (APIs RESTful)",
        "Semana 11: Diseño de Interfaces de Comunicación y Transmisión de Datos (JSON/XML)",
        "Semana 12: Implementación y Validación de la Comunicación Arquitectónica",
        "Semana 13: Fundamentos de Frameworks de Arquitectura de Software",
        "Semana 14: Normas y Buenas Prácticas en Arquitectura (Escalabilidad y Seguridad)",
        "Semana 15: Implementación de la Arquitectura con Frameworks (Java EE MVC & Servlets)",
        "Semana 16: Evaluación, Optimización y Despliegue Cloud en Render & Docker"
    };

    private synchronized static List<Entregable> getMemoriaEntregables() {
        if (MEMORIA_ENTREGABLES == null) {
            MEMORIA_ENTREGABLES = new ArrayList<>();
            String[] nombresUnidad = {
                "Fundamentos y Estándares de Arquitectura",
                "Modelado de Arquitecturas con POO y Vistas 4+1",
                "Comunicación, Integración y Servicios Web REST",
                "Frameworks Modernos y Despliegue en Cloud"
            };

            // Trabajo Semana 1
            Entregable e1 = new Entregable();
            e1.setId(1);
            e1.setSemana(1);
            e1.setUnidadId(1);
            e1.setUnidadNumero(1);
            e1.setNombreUnidad(nombresUnidad[0]);
            e1.setTituloTrabajo("Trabajo Semana 1 - Arquitectura de Software: Fundamentos y Elementos");
            e1.setNombreArchivo("Semana_01_Arquitectura_de_Software_Alessander.pdf");
            e1.setArchivoUrl("docs/Semana_01_Arquitectura_de_Software_Alessander.pdf");
            e1.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e1);

            // Trabajo Semana 2
            Entregable e2 = new Entregable();
            e2.setId(2);
            e2.setSemana(2);
            e2.setUnidadId(1);
            e2.setUnidadNumero(1);
            e2.setNombreUnidad(nombresUnidad[0]);
            e2.setTituloTrabajo("Trabajo Semana 2 - Estándares Internacionales en Arquitectura de Software");
            e2.setNombreArchivo("Semana_02_Estandares_Internacionales_Alessander.pdf");
            e2.setArchivoUrl("docs/Semana_02_Estandares_Internacionales_Alessander.pdf");
            e2.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e2);

            // Trabajo Semana 3
            Entregable e3 = new Entregable();
            e3.setId(3);
            e3.setSemana(3);
            e3.setUnidadId(1);
            e3.setUnidadNumero(1);
            e3.setNombreUnidad(nombresUnidad[0]);
            e3.setTituloTrabajo("Trabajo Semana 3 - Estilos y Patrones Arquitectónicos de Software");
            e3.setNombreArchivo("Semana_03_Estilos_y_Patrones_Arquitectonicos_Alessander.jpg");
            e3.setArchivoUrl("img/Semana_03_Estilos_y_Patrones_Arquitectonicos_Alessander.jpg");
            e3.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e3);

            // Trabajo Semana 4
            Entregable e4 = new Entregable();
            e4.setId(4);
            e4.setSemana(4);
            e4.setUnidadId(1);
            e4.setUnidadNumero(1);
            e4.setNombreUnidad(nombresUnidad[0]);
            e4.setTituloTrabajo("Trabajo Semana 4 - Arquitectura de Software: Estándares ISO 42010, ISO 25010, Modelos C4 y 4+1");
            e4.setNombreArchivo("Semana_04_Arquitectura_de_Software_Alessander.pdf");
            e4.setArchivoUrl("docs/Semana_04_Arquitectura_de_Software_Alessander.pdf");
            e4.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e4);

            // Trabajo Semana 5
            Entregable e5 = new Entregable();
            e5.setId(5);
            e5.setSemana(5);
            e5.setUnidadId(2);
            e5.setUnidadNumero(2);
            e5.setNombreUnidad(nombresUnidad[1]);
            e5.setTituloTrabajo("Trabajo Semana 5 - Informe de Diseño Arquitectónico y Modelado UML (Pequeños Exploradores LMS)");
            e5.setNombreArchivo("Semana_05_Informe_Pequenos_Exploradores_LMS.pdf");
            e5.setArchivoUrl("docs/Semana_05_Informe_Pequenos_Exploradores_LMS.pdf");
            e5.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e5);

            // Trabajo Semana 6
            Entregable e6 = new Entregable();
            e6.setId(6);
            e6.setSemana(6);
            e6.setUnidadId(2);
            e6.setUnidadNumero(2);
            e6.setNombreUnidad(nombresUnidad[1]);
            e6.setTituloTrabajo("Trabajo Semana 6 - Infografía: Requisitos Funcionales y No Funcionales por Rol (LMS Pequeños Exploradores)");
            e6.setNombreArchivo("Semana_06_Infografia_Requisitos_LMS_Alessander.jpg");
            e6.setArchivoUrl("img/Semana_06_Infografia_Requisitos_LMS_Alessander.jpg");
            e6.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e6);

            // Trabajo Semana 7 (Principal) - Diseño Físico de Base de Datos para Microsoft Azure SQL Database
            Entregable e7 = new Entregable();
            e7.setId(7);
            e7.setSemana(7);
            e7.setUnidadId(2);
            e7.setUnidadNumero(2);
            e7.setNombreUnidad(nombresUnidad[1]);
            e7.setTituloTrabajo("Trabajo Semana 7 - Diseño Físico de Base de Datos para Microsoft Azure SQL Database");
            e7.setNombreArchivo("Semana_07_Diseno_Fisico_Base_Datos_Azure.pdf");
            e7.setArchivoUrl("docs/Semana_07_Diseno_Fisico_Base_Datos_Azure.pdf");
            e7.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e7);

            // Trabajo Semana 7 (Anexo Técnico) - Script T-SQL DDL/DML Azure SQL
            Entregable e7sql = new Entregable();
            e7sql.setId(8);
            e7sql.setSemana(7);
            e7sql.setUnidadId(2);
            e7sql.setUnidadNumero(2);
            e7sql.setNombreUnidad(nombresUnidad[1]);
            e7sql.setTituloTrabajo("Trabajo Semana 7 - Script T-SQL DDL/DML Azure SQL (Pequenos_Exploradores_AzureSQL.sql)");
            e7sql.setNombreArchivo("Semana_07_Pequenos_Exploradores_AzureSQL.sql");
            e7sql.setArchivoUrl("docs/Semana_07_Pequenos_Exploradores_AzureSQL.sql");
            e7sql.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e7sql);

            // Trabajo Semana 7 (Complementario) - Infografía Diagrama Causal
            Entregable e7info = new Entregable();
            e7info.setId(9);
            e7info.setSemana(7);
            e7info.setUnidadId(2);
            e7info.setUnidadNumero(2);
            e7info.setNombreUnidad(nombresUnidad[1]);
            e7info.setTituloTrabajo("Trabajo Semana 7 - Infografía: Diagrama Causal de la Problemática Educativa");
            e7info.setNombreArchivo("Semana_07_Infografia_Diagrama_Causal_Alessander.jpg");
            e7info.setArchivoUrl("img/Semana_07_Infografia_Diagrama_Causal_Alessander.jpg");
            e7info.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e7info);

            // Trabajo Semana 8 - Diseño del Front-end de la Aplicación mediante Figma
            Entregable e8 = new Entregable();
            e8.setId(10);
            e8.setSemana(8);
            e8.setUnidadId(2);
            e8.setUnidadNumero(2);
            e8.setNombreUnidad(nombresUnidad[1]);
            e8.setTituloTrabajo("Trabajo Semana 8 - Diseño del Front-end de la Aplicación mediante Figma (Pequeños Exploradores LMS)");
            e8.setNombreArchivo("Semana_08_Diseno_Frontend_Figma.pdf");
            e8.setArchivoUrl("docs/Semana_08_Diseno_Frontend_Figma.pdf");
            e8.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
            MEMORIA_ENTREGABLES.add(e8);
        }
        return MEMORIA_ENTREGABLES;
    }

    public Usuario autenticar(String username, String password) {
        String sql = "SELECT id, nombre, usuario, clave, foto_url, fecha_registro FROM usuarios WHERE usuario = ? AND clave = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setNombre(rs.getString("nombre"));
                    u.setUsuario(rs.getString("usuario"));
                    u.setClave(rs.getString("clave"));
                    u.setFotoUrl(rs.getString("foto_url"));
                    u.setFechaRegistro(rs.getTimestamp("fecha_registro"));
                    return u;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Conexión a BD no disponible o error al autenticar: " + e.getMessage());
            if ("alessander".equalsIgnoreCase(username) && "upla2026".equals(password)) {
                Usuario u = new Usuario();
                u.setId(1);
                u.setNombre("Alessander Meza Garay (Código: r03396b)");
                u.setUsuario("alessander");
                u.setClave("upla2026");
                u.setFotoUrl("img/alessander.jpg");
                return u;
            }
        }
        return null;
    }

    public boolean registrarUsuario(Usuario usuario) {
        String sql = "INSERT INTO usuarios (nombre, usuario, clave, foto_url) VALUES (?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getUsuario());
            ps.setString(3, usuario.getClave());
            ps.setString(4, usuario.getFotoUrl());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al registrar usuario: " + e.getMessage(), e);
            return false;
        }
    }

    public static class ArchivoData {
        private final String nombreArchivo;
        private final String contentType;
        private final byte[] contenido;

        public ArchivoData(String nombreArchivo, String contentType, byte[] contenido) {
            this.nombreArchivo = nombreArchivo;
            this.contentType = contentType;
            this.contenido = contenido;
        }

        public String getNombreArchivo() { return nombreArchivo; }
        public String getContentType() { return contentType; }
        public byte[] getContenido() { return contenido; }
    }

    private void asegurarTablaArchivos(Connection con) {
        String ddl = "CREATE TABLE IF NOT EXISTS entregables_archivos (" +
                     "entregable_id INTEGER PRIMARY KEY, " +
                     "nombre_archivo TEXT NOT NULL, " +
                     "content_type TEXT, " +
                     "contenido BYTEA NOT NULL, " +
                     "fecha_subida TIMESTAMP DEFAULT CURRENT_TIMESTAMP)";
        try (PreparedStatement ps = con.prepareStatement(ddl)) {
            ps.execute();
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "No se pudo asegurar tabla entregables_archivos: " + e.getMessage());
        }
    }

    private void asegurarUnidadesBase(Connection con) {
        try (PreparedStatement check = con.prepareStatement("SELECT COUNT(*) FROM unidades");
             ResultSet rs = check.executeQuery()) {
            if (rs.next() && rs.getInt(1) == 0) {
                String sql = "INSERT INTO unidades (numero, nombre, descripcion) VALUES (?, ?, ?)";
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    Object[][] data = {
                        {1, "Fundamentos y Estándares de Arquitectura", "Introducción, ISO/IEC 25010, Estilos y Vistas 4+1"},
                        {2, "Modelado de Arquitecturas con POO y Vistas 4+1", "Principios POO, Diagramas UML y Componentes"},
                        {3, "Comunicación, Integración y Servicios Web REST", "Protocolos de Integración, REST APIs y JSON/XML"},
                        {4, "Frameworks Modernos y Despliegue en Cloud", "Patrón Java EE MVC, Tomcat 9, Docker y Render"}
                    };
                    for (Object[] row : data) {
                        ps.setInt(1, (Integer) row[0]);
                        ps.setString(2, (String) row[1]);
                        ps.setString(3, (String) row[2]);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error al asegurar unidades base: " + e.getMessage());
        }
    }

    private synchronized void sembrarEntregablesIniciales(Connection con) {
        asegurarUnidadesBase(con);
        String insertSql = "INSERT INTO entregables (semana, unidad_id, titulo_trabajo, nombre_archivo, archivo_url, fecha_subida) " +
                           "VALUES (?, (SELECT id FROM unidades WHERE numero = ? LIMIT 1), ?, ?, ?, CURRENT_TIMESTAMP)";
        List<Entregable> base = getMemoriaEntregables();
        try (PreparedStatement ps = con.prepareStatement(insertSql)) {
            for (Entregable e : base) {
                ps.setInt(1, e.getSemana());
                ps.setInt(2, e.getUnidadNumero());
                ps.setString(3, e.getTituloTrabajo());
                ps.setString(4, e.getNombreArchivo());
                ps.setString(5, e.getArchivoUrl());
                ps.addBatch();
            }
            ps.executeBatch();
            LOGGER.info("Se sembraron " + base.size() + " entregables iniciales (Semanas 1-8) en Supabase.");
        } catch (Exception ex) {
            LOGGER.log(Level.WARNING, "Error al sembrar entregables iniciales en Supabase: " + ex.getMessage());
        }
    }

    public List<Entregable> obtenerEntregables() {
        List<Entregable> lista = new ArrayList<>();
        String sql = "SELECT e.id, e.semana, e.unidad_id, COALESCE(u.numero, ((e.semana - 1) / 4) + 1) AS unidad_numero, " +
                     "COALESCE(u.nombre, 'Fundamentos de Arquitectura') AS nombre_unidad, " +
                     "e.titulo_trabajo, e.nombre_archivo, e.archivo_url, e.fecha_subida " +
                     "FROM entregables e " +
                     "LEFT JOIN unidades u ON e.unidad_id = u.id " +
                     "ORDER BY e.semana ASC, e.id ASC";

        Exception ultimoError = null;
        for (int intento = 1; intento <= 2; intento++) {
            lista.clear();
            try (Connection con = ConexionDB.getConexion();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Entregable ent = new Entregable();
                    ent.setId(rs.getInt("id"));
                    ent.setSemana(rs.getInt("semana"));
                    ent.setUnidadId(rs.getInt("unidad_id"));
                    ent.setUnidadNumero(rs.getInt("unidad_numero"));
                    ent.setNombreUnidad(rs.getString("nombre_unidad"));
                    ent.setTituloTrabajo(rs.getString("titulo_trabajo"));
                    ent.setNombreArchivo(rs.getString("nombre_archivo"));
                    ent.setArchivoUrl(rs.getString("archivo_url"));
                    ent.setFechaSubida(rs.getTimestamp("fecha_subida"));
                    lista.add(ent);
                }

                // Si no hay ningún entregable de las Semanas 1-8 en Supabase, sembrar los 10 entregables base
                boolean tieneBase1a8 = false;
                for (Entregable item : lista) {
                    if (item.getSemana() >= 1 && item.getSemana() <= 8) {
                        tieneBase1a8 = true;
                        break;
                    }
                }
                if (!tieneBase1a8) {
                    sembrarEntregablesIniciales(con);
                    lista.clear();
                    try (PreparedStatement ps2 = con.prepareStatement(sql);
                         ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            Entregable ent = new Entregable();
                            ent.setId(rs2.getInt("id"));
                            ent.setSemana(rs2.getInt("semana"));
                            ent.setUnidadId(rs2.getInt("unidad_id"));
                            ent.setUnidadNumero(rs2.getInt("unidad_numero"));
                            ent.setNombreUnidad(rs2.getString("nombre_unidad"));
                            ent.setTituloTrabajo(rs2.getString("titulo_trabajo"));
                            ent.setNombreArchivo(rs2.getString("nombre_archivo"));
                            ent.setArchivoUrl(rs2.getString("archivo_url"));
                            ent.setFechaSubida(rs2.getTimestamp("fecha_subida"));
                            lista.add(ent);
                        }
                    }
                    if (lista.isEmpty()) {
                        return getMemoriaEntregables();
                    }
                }

                ultimoErrorBD = null;
                return lista;
            } catch (Exception e) {
                ultimoError = e;
                ultimoErrorBD = e.getClass().getSimpleName() + ": " + e.getMessage();
                LOGGER.log(Level.WARNING, "Intento " + intento + " de conexión a BD falló: " + e.getMessage());
                if (intento == 1) {
                    try { Thread.sleep(600); } catch (InterruptedException ignored) {}
                }
            }
        }

        LOGGER.log(Level.WARNING, "Conexión a BD falló tras reintentos, usando datos en memoria: " +
                (ultimoError != null ? ultimoError.getMessage() : "desconocido"));
        return getMemoriaEntregables();
    }

    /**
     * Permite subir MÚLTIPLES archivos por semana con su TÍTULO PERSONALIZADO.
     */
    public boolean guardarEntregable(int semana, String tituloTrabajo, String nombreArchivo, String archivoUrl) {
        return guardarEntregable(semana, tituloTrabajo, nombreArchivo, archivoUrl, null, null);
    }

    /**
     * Guarda el entregable en PostgreSQL y también persiste el binario en entregables_archivos
     * para que nunca se pierda al reiniciar o redesplegar Render.
     */
    public boolean guardarEntregable(int semana, String tituloTrabajo, String nombreArchivo, String archivoUrl,
                                     byte[] contenidoArchivo, String contentType) {
        int unidadNum = ((semana - 1) / 4) + 1;
        String tituloFinal = (tituloTrabajo != null && !tituloTrabajo.trim().isEmpty()) ? tituloTrabajo : nombreArchivo;
        String urlInicial = (archivoUrl != null && !archivoUrl.trim().isEmpty()) ? archivoUrl : "archivo?id=0";

        String sql = "INSERT INTO entregables (semana, unidad_id, titulo_trabajo, nombre_archivo, archivo_url, fecha_subida) " +
                     "VALUES (?, COALESCE((SELECT id FROM unidades WHERE numero = ? LIMIT 1), ?), ?, ?, ?, CURRENT_TIMESTAMP) RETURNING id";

        boolean ok = false;
        int generatedId = -1;
        try (Connection con = ConexionDB.getConexion()) {
            asegurarUnidadesBase(con);
            asegurarTablaArchivos(con);

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, semana);
                ps.setInt(2, unidadNum);
                ps.setInt(3, unidadNum);
                ps.setString(4, tituloFinal);
                ps.setString(5, nombreArchivo);
                ps.setString(6, urlInicial);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                        ok = true;
                    }
                }
            }

            if (ok && generatedId > 0) {
                // Si no había URL pública de Supabase Storage, apuntar al servlet local respaldado por PostgreSQL
                if (archivoUrl == null || archivoUrl.trim().isEmpty()) {
                    urlInicial = "archivo?id=" + generatedId;
                    try (PreparedStatement psUpd = con.prepareStatement("UPDATE entregables SET archivo_url = ? WHERE id = ?")) {
                        psUpd.setString(1, urlInicial);
                        psUpd.setInt(2, generatedId);
                        psUpd.executeUpdate();
                    } catch (Exception updEx) {
                        LOGGER.log(Level.WARNING, "No se pudo actualizar archivo_url (id=" + generatedId + "): " + updEx.getMessage());
                    }
                }

                if (contenidoArchivo != null && contenidoArchivo.length > 0) {
                    MEMORIA_ARCHIVOS.put(generatedId, new ArchivoData(nombreArchivo, contentType, contenidoArchivo));
                    String sqlArchivo = "INSERT INTO entregables_archivos (entregable_id, nombre_archivo, content_type, contenido) " +
                                        "VALUES (?, ?, ?, ?) " +
                                        "ON CONFLICT (entregable_id) DO UPDATE SET nombre_archivo = EXCLUDED.nombre_archivo, " +
                                        "content_type = EXCLUDED.content_type, contenido = EXCLUDED.contenido";
                    try (PreparedStatement psArch = con.prepareStatement(sqlArchivo)) {
                        psArch.setInt(1, generatedId);
                        psArch.setString(2, nombreArchivo);
                        psArch.setString(3, contentType != null ? contentType : "application/octet-stream");
                        psArch.setBytes(4, contenidoArchivo);
                        psArch.executeUpdate();
                    } catch (Exception archEx) {
                        LOGGER.log(Level.SEVERE, "Error al guardar binario en entregables_archivos (id=" + generatedId + "): " + archEx.getMessage(), archEx);
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al guardar entregable en BD: " + e.getMessage(), e);
        }

        // Sincronizar en memoria compartida (respaldo si BD no responde)
        String[] nombresUnidad = {
            "Fundamentos y Estándares de Arquitectura",
            "Modelado de Arquitecturas con POO y Vistas 4+1",
            "Comunicación, Integración y Servicios Web REST",
            "Frameworks Modernos y Despliegue en Cloud"
        };

        int finalId = generatedId > 0 ? generatedId : AUTO_ID.incrementAndGet();
        if (contenidoArchivo != null && contenidoArchivo.length > 0) {
            MEMORIA_ARCHIVOS.putIfAbsent(finalId, new ArchivoData(nombreArchivo, contentType, contenidoArchivo));
            if (archivoUrl == null || archivoUrl.trim().isEmpty()) {
                urlInicial = "archivo?id=" + finalId;
            }
        }

        Entregable nuevo = new Entregable();
        nuevo.setId(finalId);
        nuevo.setSemana(semana);
        nuevo.setUnidadId(unidadNum);
        nuevo.setUnidadNumero(unidadNum);
        nuevo.setNombreUnidad(nombresUnidad[unidadNum - 1]);
        nuevo.setTituloTrabajo(tituloFinal);
        nuevo.setNombreArchivo(nombreArchivo);
        nuevo.setArchivoUrl(urlInicial);
        nuevo.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));

        getMemoriaEntregables().add(nuevo);
        return ok;
    }

    public ArchivoData obtenerArchivoPorId(int entregableId) {
        String sql = "SELECT nombre_archivo, content_type, contenido FROM entregables_archivos WHERE entregable_id = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, entregableId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ArchivoData(
                            rs.getString("nombre_archivo"),
                            rs.getString("content_type"),
                            rs.getBytes("contenido")
                    );
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error al obtener archivo de BD (id=" + entregableId + "): " + e.getMessage());
        }
        return MEMORIA_ARCHIVOS.get(entregableId);
    }

    /**
     * Elimina un archivo específico por su ID único.
     */
    public boolean eliminarEntregable(int id) {
        try (Connection con = ConexionDB.getConexion()) {
            try (PreparedStatement psArch = con.prepareStatement("DELETE FROM entregables_archivos WHERE entregable_id = ?")) {
                psArch.setInt(1, id);
                psArch.executeUpdate();
            } catch (Exception ignored) {}

            try (PreparedStatement ps = con.prepareStatement("DELETE FROM entregables WHERE id = ?")) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar entregable en BD: " + e.getMessage());
        }

        MEMORIA_ARCHIVOS.remove(id);
        List<Entregable> memoria = getMemoriaEntregables();
        memoria.removeIf(e -> e.getId() == id);
        return true;
    }

    public List<Unidad> obtenerResumenUnidades(List<Entregable> entregables) {
        List<Unidad> unidades = new ArrayList<>();
        unidades.add(new Unidad(1, 1, "Fundamentos y Estándares de Arquitectura", "Introducción, ISO/IEC 25010, Estilos y Vistas 4+1"));
        unidades.add(new Unidad(2, 2, "Modelado de Arquitecturas con POO y Vistas 4+1", "Principios POO, Diagramas UML y Componentes"));
        unidades.add(new Unidad(3, 3, "Comunicación, Integración y Servicios Web REST", "Protocolos de Integración, REST APIs y JSON/XML"));
        unidades.add(new Unidad(4, 4, "Frameworks Modernos y Despliegue en Cloud", "Patrón Java EE MVC, Tomcat 9, Docker y Render"));

        for (Unidad u : unidades) {
            java.util.Set<Integer> semanasUnicas = new java.util.HashSet<>();
            for (Entregable e : entregables) {
                if (e.getUnidadNumero() == u.getNumero() && e.isCompletado()) {
                    semanasUnicas.add(e.getSemana());
                }
            }
            u.setTotalSemanas(4);
            u.setSemanasCompletadas(semanasUnicas.size());
        }
        return unidades;
    }

    public static String getTemaSemana(int semana) {
        if (semana >= 1 && semana <= 16) {
            return TEMAS_SILABO[semana - 1];
        }
        return "Semana " + semana;
    }
}
