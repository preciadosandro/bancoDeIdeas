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
public class ObjetivoIdea implements Serializable {

    private int ID;
    private int ID_T_IDEA;
    private String DESCRIPCION;
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

    public int getID_T_IDEA() {
        return ID_T_IDEA;
    }

    public void setID_T_IDEA(int ID_T_IDEA) {
        this.ID_T_IDEA = ID_T_IDEA;
    }

    public String getDESCRIPCION() {
        return DESCRIPCION;
    }

    public void setDESCRIPCION(String DESCRIPCION) {
        this.DESCRIPCION = DESCRIPCION;
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
