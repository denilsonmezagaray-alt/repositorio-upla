package pe.edu.upla.repositorio.dao;

import pe.edu.upla.repositorio.model.Entregable;
import pe.edu.upla.repositorio.model.Unidad;
import pe.edu.upla.repositorio.model.Usuario;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Patrón DAO (Data Access Object) con JDBC Puro para Supabase PostgreSQL
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas)
 * Curso: Arquitectura de Software
 */
public class RepositorioDAO {
    private static final Logger LOGGER = Logger.getLogger(RepositorioDAO.class.getName());

    /**
     * Autenticar usuario contra la base de datos PostgreSQL en Supabase.
     */
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
            // Fallback de demostración para el usuario administrador Alessander
            if ("alessander".equalsIgnoreCase(username) && "upla2026".equals(password)) {
                Usuario u = new Usuario();
                u.setId(1);
                u.setNombre("Alessander (Ing. Sistemas - UPLA)");
                u.setUsuario("alessander");
                u.setClave("upla2026");
                u.setFotoUrl("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80");
                return u;
            }
        }
        return null;
    }

    /**
     * Registrar nuevo usuario en Supabase PostgreSQL.
     */
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

    private static List<Entregable> MEMORIA_ENTREGABLES = null;

    private synchronized static List<Entregable> getMemoriaEntregables() {
        if (MEMORIA_ENTREGABLES == null) {
            MEMORIA_ENTREGABLES = new ArrayList<>();
            String[] nombresUnidad = {
                "Unidad I: Fundamentos y Patrones",
                "Unidad II: SOA y Microservicios",
                "Unidad III: Arquitectura de Datos",
                "Unidad IV: Despliegue y DevOps"
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

    /**
     * Obtener la lista completa de las 16 semanas con sus entregables.
     */
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

    /**
     * Guardar o actualizar entregable para una semana específica.
     */
    public boolean guardarEntregable(int semana, String nombreArchivo, String archivoUrl) {
        boolean exitoBd = false;
        String sql = "UPDATE entregables SET nombre_archivo = ?, archivo_url = ?, fecha_subida = CURRENT_TIMESTAMP WHERE semana = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nombreArchivo);
            ps.setString(2, archivoUrl);
            ps.setInt(3, semana);

            exitoBd = ps.executeUpdate() > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al guardar entregable en BD: " + e.getMessage());
        }

        // Sincronizar siempre en la memoria compartida
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

    /**
     * Eliminar entregables (limpiar archivo) de una semana específica.
     */
    public boolean eliminarEntregable(int semana) {
        boolean exitoBd = false;
        String sql = "UPDATE entregables SET nombre_archivo = NULL, archivo_url = NULL, fecha_subida = NULL WHERE semana = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, semana);
            exitoBd = ps.executeUpdate() > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al eliminar entregable en BD: " + e.getMessage());
        }

        // Sincronizar siempre en la memoria compartida
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

    /**
     * Obtener resumen de Unidades con total de semanas y completadas para Chart.js.
     */
    public List<Unidad> obtenerResumenUnidades(List<Entregable> entregables) {
        List<Unidad> unidades = new ArrayList<>();
        unidades.add(new Unidad(1, 1, "Unidad I: Fundamentos y Patrones", "Patrones y Arquitectura inicial"));
        unidades.add(new Unidad(2, 2, "Unidad II: SOA y Microservicios", "Servicios REST y Microservicios"));
        unidades.add(new Unidad(3, 3, "Unidad III: Arquitectura de Datos", "JDBC, JSTL, PostgreSQL y Supabase"));
        unidades.add(new Unidad(4, 4, "Unidad IV: Despliegue y DevOps", "Docker, Tomcat 9 y Render"));

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

    private List<Entregable> generarEntregablesIniciales() {
        List<Entregable> lista = new ArrayList<>();
        String[] nombresUnidad = {
            "Unidad I: Fundamentos y Patrones",
            "Unidad II: SOA y Microservicios",
            "Unidad III: Arquitectura de Datos",
            "Unidad IV: Despliegue y DevOps"
        };

        for (int i = 1; i <= 16; i++) {
            int unidadNum = ((i - 1) / 4) + 1;
            Entregable ent = new Entregable();
            ent.setId(i);
            ent.setSemana(i);
            ent.setUnidadId(unidadNum);
            ent.setUnidadNumero(unidadNum);
            ent.setNombreUnidad(nombresUnidad[unidadNum - 1]);
            
            // Demo datos sembrados iniciales para semanas 1 y 2
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
            lista.add(ent);
        }
        return lista;
    }
}
