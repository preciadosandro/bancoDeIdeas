/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces.model;

import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author Nathalia Riascos
 * @author LMIRANDA
 */
public class Idea implements Serializable {
    private int id;
    private int idUsuario;
    private int idEstadoidea;
    private String titulo;
    private String descripcion;
    private String ideaPrivada;
    private String palabrasClaves;
    private String creadoPor;
    private Date creadoEn;
    private String modificadoPor;
    private Date modificadoEn;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getidUsuario() {
        return idUsuario;
    }

    public void setidUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getidEstadoidea() {
        return idEstadoidea;
    }

    public void setidEstadoidea(int idEstadoidea) {
        this.idEstadoidea = idEstadoidea;
    }

     public String gettitulo() {
        return titulo;
    }

    public void settitulo(String titulo) {
        this.titulo = titulo;
    }

     public String getdescripcion() {
        return descripcion;
    }

    public void setdescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

     public String getideaPrivada() {
        return ideaPrivada;
    }

    public void setideaPrivada(String ideaPrivada) {
        this.ideaPrivada = ideaPrivada;
    }
     public String getpalabrasClaves() {
        return palabrasClaves;
    }

    public void setpalabrasClaves(String palabrasClaves) {
        this.palabrasClaves = palabrasClaves;
    }
     public String getcreadoPor() {
        return creadoPor;
    }

    public void setcreadoPor(String creadoPor) {
        this.creadoPor = creadoPor;
    }
     public Date getcreadoEn() {
        return creadoEn;
    }

    public void setcreadoEn(Date creadoEn) {
        this.creadoEn = creadoEn;
    }
     public String getmodificadoPor() {
        return modificadoPor;
    }

    public void setmodificadoPor(String modificadoPor) {
        this.modificadoPor = modificadoPor;
    }
     public Date getmodificadoEn() {
        return modificadoEn;
    }

    public void setmodificadoEn(Date modificadoEn) {
        this.modificadoEn = modificadoEn;
    }

}
