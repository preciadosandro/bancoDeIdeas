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
 * @author LMIRANDA
 */
public class Idea implements Serializable {

    private int ID;
    private int ID_T_USUARIO;
    private String TITULO;
    private String DESCRIPCION;
    private int IDEAPRIVADA;
    private int ID_T_LV_ESTADOIDEA;
    private String PALABRASCLAVE;
    private String CREADOPOR;
    private Date CREADOEN;
    private String MODIFICADOPOR;
    private Date MODIFICADOEN;

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public int getID_T_USUARIO() {
        return ID_T_USUARIO;
    }

    public void setID_T_USUARIO(int ID_T_USUARIO) {
        this.ID_T_USUARIO = ID_T_USUARIO;
    }

    public String getTITULO() {
        return TITULO;
    }

    public void setTITULO(String TITULO) {
        this.TITULO = TITULO;
    }

    public String getDESCRIPCION() {
        return DESCRIPCION;
    }

    public void setDESCRIPCION(String DESCRIPCION) {
        this.DESCRIPCION = DESCRIPCION;
    }

    public int getIDEAPRIVADA() {
        return IDEAPRIVADA;
    }

    public void setIDEAPRIVADA(int IDEAPRIVADA) {
        this.IDEAPRIVADA = IDEAPRIVADA;
    }

    public int getID_T_LV_ESTADOIDEA() {
        return ID_T_LV_ESTADOIDEA;
    }

    public void setID_T_LV_ESTADOIDEA(int ID_T_LV_ESTADOIDEA) {
        this.ID_T_LV_ESTADOIDEA = ID_T_LV_ESTADOIDEA;
    }

    public String getPALABRASCLAVE() {
        return PALABRASCLAVE;
    }

    public void setPALABRASCLAVE(String PALABRASCLAVE) {
        this.PALABRASCLAVE = PALABRASCLAVE;
    }

    public String getCREADOPOR() {
        return CREADOPOR;
    }

    public void setCREADOPOR(String CREADOPOR) {
        this.CREADOPOR = CREADOPOR;
    }

    public Date getCREADOEN() {
        return CREADOEN;
    }

    public void setCREADOEN(Date CREADOEN) {
        this.CREADOEN = CREADOEN;
    }

    public String getMODIFICADOPOR() {
        return MODIFICADOPOR;
    }

    public void setMODIFICADOPOR(String MODIFICADOPOR) {
        this.MODIFICADOPOR = MODIFICADOPOR;
    }

    public Date getMODIFICADOEN() {
        return MODIFICADOEN;
    }

    public void setMODIFICADOEN(Date MODIFICADOEN) {
        this.MODIFICADOEN = MODIFICADOEN;
    }

}
