package pe.edu.upla.repositorio.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Modelo de Dominio: Usuario
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas)
 * Curso: Arquitectura de Software
 */
public class Usuario implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String nombre;
    private String usuario;
    private String clave;
    private String fotoUrl;
    private Timestamp fechaRegistro;

    public Usuario() {
    }

    public Usuario(int id, String nombre, String usuario, String clave, String fotoUrl, Timestamp fechaRegistro) {
        this.id = id;
        this.nombre = nombre;
        this.usuario = usuario;
        this.clave = clave;
        this.fotoUrl = fotoUrl;
        this.fechaRegistro = fechaRegistro;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public String getFotoUrl() {
        return fotoUrl;
    }

    public void setFotoUrl(String fotoUrl) {
        this.fotoUrl = fotoUrl;
    }

    public Timestamp getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Timestamp fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }
}
