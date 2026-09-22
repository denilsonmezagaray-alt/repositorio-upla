package pe.edu.upla.repositorio.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Modelo de Dominio: Entregable (Soporta Múltiples Archivos por Semana)
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander Meza Garay (Código: r03396b)
 * Curso: Arquitectura de Software
 */
public class Entregable implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int semana;
    private int unidadId;
    private int unidadNumero;
    private String nombreUnidad;
    private String tituloTrabajo; // Nombre personalizado del trabajo
    private String nombreArchivo; // Nombre del archivo subido
    private String archivoUrl;    // URL en Supabase Storage
    private Timestamp fechaSubida;

    public Entregable() {
    }

    public Entregable(int id, int semana, int unidadId, String nombreUnidad, String tituloTrabajo, String nombreArchivo, String archivoUrl, Timestamp fechaSubida) {
        this.id = id;
        this.semana = semana;
        this.unidadId = unidadId;
        this.nombreUnidad = nombreUnidad;
        this.tituloTrabajo = tituloTrabajo;
        this.nombreArchivo = nombreArchivo;
        this.archivoUrl = archivoUrl;
        this.fechaSubida = fechaSubida;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSemana() {
        return semana;
    }

    public void setSemana(int semana) {
        this.semana = semana;
    }

    public int getUnidadId() {
        return unidadId;
    }

    public void setUnidadId(int unidadId) {
        this.unidadId = unidadId;
    }

    public int getUnidadNumero() {
        return unidadNumero;
    }

    public void setUnidadNumero(int unidadNumero) {
        this.unidadNumero = unidadNumero;
    }

    public String getNombreUnidad() {
        return nombreUnidad;
    }

    public void setNombreUnidad(String nombreUnidad) {
        this.nombreUnidad = nombreUnidad;
    }

    public String getTituloTrabajo() {
        if (tituloTrabajo == null || tituloTrabajo.trim().isEmpty()) {
            return nombreArchivo != null ? nombreArchivo : "Trabajo de la Semana " + semana;
        }
        return tituloTrabajo;
    }

    public void setTituloTrabajo(String tituloTrabajo) {
        this.tituloTrabajo = tituloTrabajo;
    }

    public String getNombreArchivo() {
        return nombreArchivo;
    }

    public void setNombreArchivo(String nombreArchivo) {
        this.nombreArchivo = nombreArchivo;
    }

    public String getArchivoUrl() {
        return archivoUrl;
    }

    public void setArchivoUrl(String archivoUrl) {
        this.archivoUrl = archivoUrl;
    }

    public Timestamp getFechaSubida() {
        return fechaSubida;
    }

    public void setFechaSubida(Timestamp fechaSubida) {
        this.fechaSubida = fechaSubida;
    }

    public boolean isCompletado() {
        return archivoUrl != null && !archivoUrl.trim().isEmpty();
    }
}
