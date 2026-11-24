package pe.edu.upla.repositorio.service;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servicio de Almacenamiento Supabase Storage (REST API)
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas)
 * Curso: Arquitectura de Software
 */
public class SupabaseStorageService {
    private static final Logger LOGGER = Logger.getLogger(SupabaseStorageService.class.getName());

    // Configuración de Supabase Storage vía Variables de Entorno
    private static final String SUPABASE_URL = System.getenv("SUPABASE_URL") != null ? System.getenv("SUPABASE_URL") : "https://ymicgxwxvpzzhvcyjnxc.supabase.co";
    private static final String SUPABASE_SERVICE_KEY = System.getenv("SUPABASE_KEY") != null ? System.getenv("SUPABASE_KEY") : "YOUR_SUPABASE_SECRET_KEY";

    /**
     * Subes un archivo (entregable o foto de perfil) a un bucket de Supabase Storage.
     * Retorna la URL pública del archivo en Supabase Storage o una URL representativa.
     */
    public static String uploadFile(String bucketName, String originalFilename, InputStream inputStream, String contentType) {
        try {
            byte[] fileBytes = readAllBytes(inputStream);
            return uploadBytes(bucketName, originalFilename, fileBytes, contentType);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Excepción al procesar subida a Supabase Storage: " + e.getMessage(), e);
            return null;
        }
    }

    /**
     * Lee todos los bytes de un InputStream de forma segura en Java 11.
     */
    public static byte[] readAllBytes(InputStream inputStream) throws java.io.IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        int nRead;
        byte[] data = new byte[8192];
        while ((nRead = inputStream.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, nRead);
        }
        buffer.flush();
        return buffer.toByteArray();
    }

    /**
     * Sube un arreglo de bytes a Supabase Storage.
     * Retorna la URL pública real si tiene éxito, o null si no está configurado o falla.
     */
    public static String uploadBytes(String bucketName, String originalFilename, byte[] fileBytes, String contentType) {
        try {
            if (!SUPABASE_URL.startsWith("http")
                    || SUPABASE_SERVICE_KEY == null
                    || SUPABASE_SERVICE_KEY.trim().isEmpty()
                    || SUPABASE_SERVICE_KEY.contains("YOUR_SUPABASE_SECRET_KEY")
                    || SUPABASE_SERVICE_KEY.contains("dummykey")) {
                LOGGER.info("SUPABASE_KEY no configurada; se omitirá Supabase Storage y se usará almacenamiento en BD.");
                return null;
            }

            String cleanFileName = originalFilename.replaceAll("[^a-zA-Z0-9\\.\\-_]", "_");
            String fileName = UUID.randomUUID().toString().substring(0, 8) + "_" + cleanFileName;

            String targetUrl = SUPABASE_URL + "/storage/v1/object/" + bucketName + "/" + fileName;
            URL url = new URL(targetUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(20000);
            conn.setDoOutput(true);
            conn.setRequestProperty("Authorization", "Bearer " + SUPABASE_SERVICE_KEY);
            conn.setRequestProperty("apiKey", SUPABASE_SERVICE_KEY);
            conn.setRequestProperty("Content-Type", contentType != null ? contentType : "application/octet-stream");

            try (OutputStream os = conn.getOutputStream()) {
                os.write(fileBytes);
                os.flush();
            }

            int responseCode = conn.getResponseCode();
            if (responseCode == 200 || responseCode == 201) {
                return SUPABASE_URL + "/storage/v1/object/public/" + bucketName + "/" + fileName;
            } else {
                LOGGER.warning("Error al subir archivo a Supabase Storage API. Código HTTP: " + responseCode);
                return null;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Excepción al subir a Supabase Storage: " + e.getMessage());
            return null;
        }
    }
}
