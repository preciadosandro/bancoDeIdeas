/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces.model;

import java.util.Date;

/**
 *
 * @author jorge.castaño
 */
public class V_rolrequest {
    
    private int id_sol_rol;
    private int id;
    private String descripcion;
    private String usuario;
    private int estado;
    private Date fechasolicitud;
    private int id_t_rol;
    private String primernombre;
    private String primerapellido;


    public int getId_t_rol() {
        return id_t_rol;
    }

    public void setId_t_rol(int id_t_rol) {
        this.id_t_rol = id_t_rol;
    } 

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    public Date getFechasolicitud() {
        return fechasolicitud;
    }

    public void setFechasolicitud(Date fechasolicitud) {
        this.fechasolicitud = fechasolicitud;
    }

    public String getPrimernombre() {
        return primernombre;
    }

    public void setPrimernombre(String primernombre) {
        this.primernombre = primernombre;
    }

    public String getPrimerapellido() {
        return primerapellido;
    }

    public void setPrimerapellido(String primerapellido) {
        this.primerapellido = primerapellido;
    }

    public int getId_sol_rol() {
        return id_sol_rol;
    }

    public void setId_sol_rol(int id_sol_rol) {
        this.id_sol_rol = id_sol_rol;
    }
    
    
    
}
