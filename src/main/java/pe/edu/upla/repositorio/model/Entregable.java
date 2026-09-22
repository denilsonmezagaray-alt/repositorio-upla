package pe.edu.upla.repositorio.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Modelo de Dominio: Entregable (Semana 1 a 16)
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas)
 * Curso: Arquitectura de Software
 */
public class Entregable implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int semana;
    private int unidadId;
    private int unidadNumero;
    private String nombreUnidad;
    private String nombreArchivo;
    private String archivoUrl;
    private Timestamp fechaSubida;

    public Entregable() {
    }

    public Entregable(int id, int semana, int unidadId, String nombreUnidad, String nombreArchivo, String archivoUrl, Timestamp fechaSubida) {
        this.id = id;
        this.semana = semana;
        this.unidadId = unidadId;
        this.nombreUnidad = nombreUnidad;
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
