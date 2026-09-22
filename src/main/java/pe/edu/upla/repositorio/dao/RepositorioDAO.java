package pe.edu.upla.repositorio.dao;

import pe.edu.upla.repositorio.model.Entregable;
import pe.edu.upla.repositorio.model.Unidad;
import pe.edu.upla.repositorio.model.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO con JDBC Puro a Supabase PostgreSQL y Almacenamiento en Memoria
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas y Computación)
 * Docente: Mg. Raúl Enrique Fernández Bejarano
 * Curso: Arquitectura de Software (Código: 332181)
 */
public class RepositorioDAO {
    private static final Logger LOGGER = Logger.getLogger(RepositorioDAO.class.getName());

    private static List<Entregable> MEMORIA_ENTREGABLES = null;

    /**
     * Nombres oficiales de las 16 Semanas según el Sílabo oficial UPLA 2026-I
     */
    private static final String[] TEMAS_SILABO = {
        "Semana 01: Introducción a la Arquitectura de Software y Conceptos Fundamentales",
        "Semana 02: Principios, Atributos de Calidad (ISO/IEC 25010) y Estándares",
        "Semana 03: Estilos y Patrones Arquitectónicos (Capas, MVC, Cliente-Servidor)",
        "Semana 04: Documentación y Representación Arquitectónica (Modelos 4+1 Vistas)",
        "Semana 05: Principios de Programación Orientada a Objetos aplicados a la Arquitectura",
        "Semana 06: Modelado Arquitectónico con UML (Casos de Uso, Clases y Paquetes)",
        "Semana 07: Diseño de Componentes, Cohesión, Acoplamiento y Capas de la Arquitectura",
        "Semana 08: Elaboración y Validación del Modelo Arquitectónico Integral",
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
                "Unidad I: Fundamentos y Estándares de Arquitectura",
                "Unidad II: Modelado de Arquitectura con POO y UML",
                "Unidad III: Comunicación e Integración con APIs REST",
                "Unidad IV: Frameworks y Despliegue Cloud (Tomcat & Render)"
            };

            for (int i = 1; i <= 16; i++) {
                int unidadNum = ((i - 1) / 4) + 1;
                Entregable ent = new Entregable();
                ent.setId(i);
                ent.setSemana(i);
                ent.setUnidadId(unidadNum);
                ent.setUnidadNumero(unidadNum);
                ent.setNombreUnidad(nombresUnidad[unidadNum - 1]);

                if (i == 1) {
                    ent.setNombreArchivo("Semana_01_Patrones_Arquitectonicos_Alessander.pdf");
                    ent.setArchivoUrl("https://upla.edu.pe/repositorio/docs/Semana_01_Patrones.pdf");
                } else if (i == 2) {
                    ent.setNombreArchivo("Semana_02_Diagrama_MVC_UPLA.png");
                    ent.setArchivoUrl("https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&auto=format&fit=crop&q=80");
                } else {
                    ent.setNombreArchivo(null);
                    ent.setArchivoUrl(null);
                }
                MEMORIA_ENTREGABLES.add(ent);
            }
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

    public List<Entregable> obtenerEntregables() {
        List<Entregable> lista = new ArrayList<>();
        String sql = "SELECT e.id, e.semana, e.unidad_id, u.numero AS unidad_numero, u.nombre AS nombre_unidad, " +
                     "e.nombre_archivo, e.archivo_url, e.fecha_subida " +
                     "FROM entregables e " +
                     "INNER JOIN unidades u ON e.unidad_id = u.id " +
                     "ORDER BY e.semana ASC";

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
                ent.setNombreArchivo(rs.getString("nombre_archivo"));
                ent.setArchivoUrl(rs.getString("archivo_url"));
                ent.setFechaSubida(rs.getTimestamp("fecha_subida"));
                lista.add(ent);
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Usando datos persistentes en memoria para entregables: " + e.getMessage());
            return getMemoriaEntregables();
        }

        if (lista.isEmpty()) {
            return getMemoriaEntregables();
        }

        return lista;
    }

    public boolean guardarEntregable(int semana, String nombreArchivo, String archivoUrl) {
        String sql = "UPDATE entregables SET nombre_archivo = ?, archivo_url = ?, fecha_subida = CURRENT_TIMESTAMP WHERE semana = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreArchivo);
            ps.setString(2, archivoUrl);
            ps.setInt(3, semana);

            ps.executeUpdate();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al guardar entregable en BD: " + e.getMessage());
        }

        List<Entregable> memoria = getMemoriaEntregables();
        for (Entregable e : memoria) {
            if (e.getSemana() == semana) {
                e.setNombreArchivo(nombreArchivo);
                e.setArchivoUrl(archivoUrl);
                e.setFechaSubida(new java.sql.Timestamp(System.currentTimeMillis()));
                break;
            }
        }

        return true;
    }

    public boolean eliminarEntregable(int semana) {
        String sql = "UPDATE entregables SET nombre_archivo = NULL, archivo_url = NULL, fecha_subida = NULL WHERE semana = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, semana);
            ps.executeUpdate();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar entregable en BD: " + e.getMessage());
        }

        List<Entregable> memoria = getMemoriaEntregables();
        for (Entregable e : memoria) {
            if (e.getSemana() == semana) {
                e.setNombreArchivo(null);
                e.setArchivoUrl(null);
                e.setFechaSubida(null);
                break;
            }
        }

        return true;
    }

    public List<Unidad> obtenerResumenUnidades(List<Entregable> entregables) {
        List<Unidad> unidades = new ArrayList<>();
        unidades.add(new Unidad(1, 1, "Fundamentos y Estándares de Arquitectura", "Introducción, ISO/IEC 25010, Estilos y Vistas 4+1"));
        unidades.add(new Unidad(2, 2, "Modelado de Arquitecturas con POO y Vistas 4+1", "Principios POO, Diagramas UML y Componentes"));
        unidades.add(new Unidad(3, 3, "Comunicación, Integración y Servicios Web REST", "Protocolos de Integración, REST APIs y JSON/XML"));
        unidades.add(new Unidad(4, 4, "Frameworks Modernos y Despliegue en Cloud", "Patrón Java EE MVC, Tomcat 9, Docker y Render"));

        for (Unidad u : unidades) {
            int completadas = 0;
            int total = 0;
            for (Entregable e : entregables) {
                if (e.getUnidadNumero() == u.getNumero()) {
                    total++;
                    if (e.isCompletado()) {
                        completadas++;
                    }
                }
            }
            u.setTotalSemanas(total > 0 ? total : 4);
            u.setSemanasCompletadas(completadas);
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
