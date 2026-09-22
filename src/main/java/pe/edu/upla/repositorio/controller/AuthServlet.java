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
 * Controlador de Autenticación: AuthServlet
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas)
 * Curso: Arquitectura de Software
 */
@WebServlet(name = "AuthServlet", urlPatterns = {"/auth"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 20    // 20MB
)
public class AuthServlet extends HttpServlet {
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
        String action = request.getParameter("action");

        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/index?msg=logged_out");
            return;
        }

        // Mostrar vista de autenticación
        request.getRequestDispatcher("/auth.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("register".equalsIgnoreCase(action)) {
            procesarRegistro(request, response);
        } else {
            procesarLogin(request, response);
        }
    }

    private void procesarLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String user = request.getParameter("usuario");
        String pass = request.getParameter("clave");

        Usuario usuarioAutenticado = repositorioDAO.autenticar(user, pass);

        if (usuarioAutenticado != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", usuarioAutenticado);
            response.sendRedirect(request.getContextPath() + "/index?msg=login_success");
        } else {
            request.setAttribute("error", "Credenciales incorrectas. Verifique su usuario y contraseña.");
            request.getRequestDispatcher("/auth.jsp").forward(request, response);
        }
    }

    private void procesarRegistro(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String nombre = request.getParameter("nombre");
        String user = request.getParameter("usuario");
        String pass = request.getParameter("clave");

        // Subir Foto de Perfil a Supabase Storage Bucket 'profiles'
        String fotoUrl = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80";
        try {
            Part fotoPart = request.getPart("fotoPerfil");
            if (fotoPart != null && fotoPart.getSize() > 0) {
                String originalFilename = fotoPart.getSubmittedFileName();
                String contentType = fotoPart.getContentType();
                try (InputStream is = fotoPart.getInputStream()) {
                    fotoUrl = SupabaseStorageService.uploadFile("profiles", originalFilename, is, contentType);
                }
            }
        } catch (Exception e) {
            // Ignorar excepción si el formulario no envió archivo y mantener foto por defecto
        }

        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setNombre(nombre);
        nuevoUsuario.setUsuario(user);
        nuevoUsuario.setClave(pass);
        nuevoUsuario.setFotoUrl(fotoUrl);

        boolean registrado = repositorioDAO.registrarUsuario(nuevoUsuario);

        if (registrado) {
            HttpSession session = request.getSession(true);
            session.setAttribute("usuario", nuevoUsuario);
            response.sendRedirect(request.getContextPath() + "/index?msg=register_success");
        } else {
            request.setAttribute("error", "No se pudo registrar el usuario. El nombre de usuario ya podría existir.");
            request.getRequestDispatcher("/auth.jsp").forward(request, response);
        }
    }
}
