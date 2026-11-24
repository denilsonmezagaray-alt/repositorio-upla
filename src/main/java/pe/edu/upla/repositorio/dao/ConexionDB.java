package pe.edu.upla.repositorio.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Patrón DAO / Conexión JDBC Puro a Supabase PostgreSQL
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas)
 * Curso: Arquitectura de Software
 */
public class ConexionDB {
    private static final Logger LOGGER = Logger.getLogger(ConexionDB.class.getName());

    // Configuración predeterminada IPv4 (Session Pooler de Supabase) o mediante Variables de Entorno (Render)
    private static final String DEFAULT_URL = "jdbc:postgresql://aws-0-sa-east-1.pooler.supabase.com:5432/postgres?sslmode=require";
    private static final String DEFAULT_USER = "postgres.ymicgxwxvpzzhvcyjnxc";
    private static final String DEFAULT_PASS = "Alessander260502";

    static {
        try {
            // Cargar el driver de PostgreSQL
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Driver de PostgreSQL no encontrado en el classpath", e);
        }
    }

    /**
     * Obtiene una conexión activa a la base de datos PostgreSQL en Supabase.
     * Lee variables de entorno si están disponibles en Render.
     */
    public static Connection getConexion() throws SQLException {
        String dbUrl = System.getenv("SUPABASE_DB_URL");
        String dbUser = System.getenv("SUPABASE_DB_USER");
        String dbPass = System.getenv("SUPABASE_DB_PASS");

        if (dbUrl == null || dbUrl.trim().isEmpty() || dbUrl.contains("db.ymicgxwxvpzzhvcyjnxc.supabase.co")) {
            dbUrl = DEFAULT_URL;
        }
        if (!dbUrl.contains("connectTimeout")) {
            dbUrl += (dbUrl.contains("?") ? "&" : "?") + "connectTimeout=10&socketTimeout=25";
        }
        if (dbUser == null || dbUser.trim().isEmpty() || "postgres".equals(dbUser.trim())) {
            dbUser = DEFAULT_USER;
        }
        if (dbPass == null || dbPass.trim().isEmpty()) {
            dbPass = DEFAULT_PASS;
        }

        return DriverManager.getConnection(dbUrl, dbUser, dbPass);
    }
}
