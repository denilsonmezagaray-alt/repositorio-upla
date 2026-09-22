package pe.edu.upla.repositorio.controller;

import pe.edu.upla.repositorio.dao.RepositorioDAO;
import pe.edu.upla.repositorio.model.Entregable;
import pe.edu.upla.repositorio.model.Unidad;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Controlador Principal: IndexServlet (Carga datos para index.jsp)
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas)
 * Curso: Arquitectura de Software
 */
@WebServlet(name = "IndexServlet", urlPatterns = {"", "/index", "/home"})
public class IndexServlet extends HttpServlet {
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

        // 1. Obtener la lista de las 16 semanas con sus entregables
        List<Entregable> entregables = repositorioDAO.obtenerEntregables();

        // 2. Obtener resumen estadístico de las 4 unidades para Chart.js
        List<Unidad> unidades = repositorioDAO.obtenerResumenUnidades(entregables);

        // 3. Calcular totales para los badges métricos
        int totalSubidos = 0;
        for (Entregable e : entregables) {
            if (e.isCompletado()) {
                totalSubidos++;
            }
        }
        int porcentajeProgreso = (int) Math.round((totalSubidos / 16.0) * 100);

        // 4. Inyectar atributos a la solicitud HTTP para JSTL en index.jsp
        request.setAttribute("entregables", entregables);
        request.setAttribute("unidades", unidades);
        request.setAttribute("totalSubidos", totalSubidos);
        request.setAttribute("porcentajeProgreso", porcentajeProgreso);
        request.setAttribute("autorEstudiante", "Alessander");
        request.setAttribute("cursoNombre", "Arquitectura de Software");
        request.setAttribute("institucion", "Universidad Peruana Los Andes");

        // 5. Redireccionar internamente a la vista index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
