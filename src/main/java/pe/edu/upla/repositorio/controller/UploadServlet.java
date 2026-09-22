package pe.edu.upla.repositorio.controller;

import pe.edu.upla.repositorio.dao.RepositorioDAO;
import pe.edu.upla.repositorio.model.Usuario;
import pe.edu.upla.repositorio.service.SupabaseStorageService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;

/**
 * Controlador de Gestión de Archivos / Entregables: UploadServlet
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas)
 * Curso: Arquitectura de Software
 */
@WebServlet(name = "UploadServlet", urlPatterns = {"/upload"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 25,      // 25MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private RepositorioDAO repositorioDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.repositorioDAO = new RepositorioDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Seguridad: Verificar que el usuario tenga sesión activa para editar
        HttpSession session = request.getSession(false);
        Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/auth?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equalsIgnoreCase(action)) {
            procesarEliminacion(request, response);
        } else {
            procesarSubida(request, response);
        }
    }

    private void procesarSubida(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int semana = Integer.parseInt(request.getParameter("semana"));
            Part archivoPart = request.getPart("archivo");

            if (archivoPart != null && archivoPart.getSize() > 0) {
                String originalFilename = archivoPart.getSubmittedFileName();
                String contentType = archivoPart.getContentType();

                // Subir archivo al bucket 'assignments' en Supabase Storage
                String archivoUrl;
                try (InputStream is = archivoPart.getInputStream()) {
                    archivoUrl = SupabaseStorageService.uploadFile("assignments", originalFilename, is, contentType);
                }

                // Guardar/Actualizar en la base de datos PostgreSQL
                repositorioDAO.guardarEntregable(semana, originalFilename, archivoUrl);
                response.sendRedirect(request.getContextPath() + "/index?msg=upload_success&week=" + semana);
            } else {
                response.sendRedirect(request.getContextPath() + "/index?error=no_file_selected");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/index?error=upload_failed");
        }
    }

    private void procesarEliminacion(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int semana = Integer.parseInt(request.getParameter("semana"));
            repositorioDAO.eliminarEntregable(semana);
            response.sendRedirect(request.getContextPath() + "/index?msg=delete_success&week=" + semana);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/index?error=delete_failed");
        }
    }
}
