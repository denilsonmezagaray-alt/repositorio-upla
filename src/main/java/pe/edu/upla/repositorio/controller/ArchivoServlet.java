package pe.edu.upla.repositorio.controller;

import pe.edu.upla.repositorio.dao.RepositorioDAO;
import pe.edu.upla.repositorio.dao.RepositorioDAO.ArchivoData;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Servlet para servir archivos almacenados en PostgreSQL (PDF, imágenes, SQL, etc.)
 * con cabecera Content-Disposition: inline para visualización directa en el navegador.
 */
@WebServlet(name = "ArchivoServlet", urlPatterns = {"/archivo"})
public class ArchivoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RepositorioDAO repositorioDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.repositorioDAO = new RepositorioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Falta el parámetro id");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID inválido");
            return;
        }

        ArchivoData archivo = repositorioDAO.obtenerArchivoPorId(id);
        if (archivo == null || archivo.getContenido() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Archivo no encontrado");
            return;
        }

        String contentType = resolverContentType(archivo.getNombreArchivo(), archivo.getContentType());
        boolean descargar = "1".equals(request.getParameter("download")) || "true".equalsIgnoreCase(request.getParameter("download"));
        String disposition = descargar ? "attachment" : "inline";
        String encodedName = URLEncoder.encode(archivo.getNombreArchivo(), StandardCharsets.UTF_8.name()).replace("+", "%20");

        response.setContentType(contentType);
        response.setContentLength(archivo.getContenido().length);
        response.setHeader("Content-Disposition", disposition + "; filename=\"" + archivo.getNombreArchivo().replace("\"", "") + "\"; filename*=UTF-8''" + encodedName);
        response.setHeader("Cache-Control", "public, max-age=3600");

        try (OutputStream out = response.getOutputStream()) {
            out.write(archivo.getContenido());
            out.flush();
        }
    }

    private String resolverContentType(String nombreArchivo, String contentTypeGuardado) {
        if (nombreArchivo != null) {
            String lower = nombreArchivo.toLowerCase();
            if (lower.endsWith(".pdf")) return "application/pdf";
            if (lower.endsWith(".png")) return "image/png";
            if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) return "image/jpeg";
            if (lower.endsWith(".gif")) return "image/gif";
            if (lower.endsWith(".webp")) return "image/webp";
            if (lower.endsWith(".sql") || lower.endsWith(".txt")) return "text/plain; charset=UTF-8";
        }
        return (contentTypeGuardado != null && !contentTypeGuardado.trim().isEmpty())
                ? contentTypeGuardado
                : "application/octet-stream";
    }
}
