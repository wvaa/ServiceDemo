package com.ejemplo.serviciodummy;

public class Estado {

    private String mensaje;
    private boolean activo;
    private String fechaConsulta;

    // Constructor
    public Estado(String mensaje, boolean activo, String fechaConsulta) {
        this.mensaje = mensaje;
        this.activo = activo;
        this.fechaConsulta = fechaConsulta;
    }

    // Getters y Setters (Necesarios para la serialización a JSON)
    // Spring/Jackson usará estos métodos para construir el JSON

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public boolean isActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    public String getFechaConsulta() {
        return fechaConsulta;
    }

    public void setFechaConsulta(String fechaConsulta) {
        this.fechaConsulta = fechaConsulta;
    }
}
