package pe.edu.upla.repositorio.model;

import java.io.Serializable;

/**
 * Modelo de Dominio: Unidad
 * Institución: Universidad Peruana Los Andes (UPLA)
 * Autor / Estudiante: Alessander (Ingeniería de Sistemas)
 * Curso: Arquitectura de Software
 */
public class Unidad implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int numero;
    private String nombre;
    private String descripcion;
    private int totalSemanas;
    private int semanasCompletadas;

    public Unidad() {
    }

    public Unidad(int id, int numero, String nombre, String descripcion) {
        this.id = id;
        this.numero = numero;
        this.nombre = nombre;
        this.descripcion = descripcion;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getTotalSemanas() {
        return totalSemanas;
    }

    public void setTotalSemanas(int totalSemanas) {
        this.totalSemanas = totalSemanas;
    }

    public int getSemanasCompletadas() {
        return semanasCompletadas;
    }

    public void setSemanasCompletadas(int semanasCompletadas) {
        this.semanasCompletadas = semanasCompletadas;
    }
}
