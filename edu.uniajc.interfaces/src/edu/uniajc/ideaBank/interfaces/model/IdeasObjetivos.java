/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces.model;

import java.util.Date;

/**
 *
 * @author LMIRANDA
 */
public class IdeasObjetivos {

    private int ID_ideas;
    private int ID_T_USUARIO_ideas;
    private String TITULO_ideas;
    private String DESCRIPCION_ideas;
    private int IDEAPRIVADA_ideas;
    private int ID_T_LV_ESTADOIDEA_ideas;
    private String PALABRASCLAVE_ideas;
    private String CREADOPOR_ideas;
    private Date CREADOEN_ideas;
    private String MODIFICADOPOR_ideas;
    private Date MODIFICADOEN_ideas;

    private int ID_objetivo;
    private int ID_T_IDEA_objetivo;
    private String DESCRIPCION_objetivo;
    private String CREADOPOR_objetivo;
    private Date CREADOEN_objetivo;
    private String MODIFICADOPOR_objetivo;
    private Date MODIFICADOEN_objetivo;

    public int getID_ideas() {
        return ID_ideas;
    }

    public void setID_ideas(int ID_ideas) {
        this.ID_ideas = ID_ideas;
    }

    public int getID_T_USUARIO_ideas() {
        return ID_T_USUARIO_ideas;
    }

    public void setID_T_USUARIO_ideas(int ID_T_USUARIO_ideas) {
        this.ID_T_USUARIO_ideas = ID_T_USUARIO_ideas;
    }

    public String getTITULO_ideas() {
        return TITULO_ideas;
    }

    public void setTITULO_ideas(String TITULO_ideas) {
        this.TITULO_ideas = TITULO_ideas;
    }

    public String getDESCRIPCION_ideas() {
        return DESCRIPCION_ideas;
    }

    public void setDESCRIPCION_ideas(String DESCRIPCION_ideas) {
        this.DESCRIPCION_ideas = DESCRIPCION_ideas;
    }

    public int getIDEAPRIVADA_ideas() {
        return IDEAPRIVADA_ideas;
    }

    public void setIDEAPRIVADA_ideas(int IDEAPRIVADA_ideas) {
        this.IDEAPRIVADA_ideas = IDEAPRIVADA_ideas;
    }

    public int getID_T_LV_ESTADOIDEA_ideas() {
        return ID_T_LV_ESTADOIDEA_ideas;
    }

    public void setID_T_LV_ESTADOIDEA_ideas(int ID_T_LV_ESTADOIDEA_ideas) {
        this.ID_T_LV_ESTADOIDEA_ideas = ID_T_LV_ESTADOIDEA_ideas;
    }

    public String getPALABRASCLAVE_ideas() {
        return PALABRASCLAVE_ideas;
    }

    public void setPALABRASCLAVE_ideas(String PALABRASCLAVE_ideas) {
        this.PALABRASCLAVE_ideas = PALABRASCLAVE_ideas;
    }

    public String getCREADOPOR_ideas() {
        return CREADOPOR_ideas;
    }

    public void setCREADOPOR_ideas(String CREADOPOR_ideas) {
        this.CREADOPOR_ideas = CREADOPOR_ideas;
    }

    public Date getCREADOEN_ideas() {
        return CREADOEN_ideas;
    }

    public void setCREADOEN_ideas(Date CREADOEN_ideas) {
        this.CREADOEN_ideas = CREADOEN_ideas;
    }

    public String getMODIFICADOPOR_ideas() {
        return MODIFICADOPOR_ideas;
    }

    public void setMODIFICADOPOR_ideas(String MODIFICADOPOR_ideas) {
        this.MODIFICADOPOR_ideas = MODIFICADOPOR_ideas;
    }

    public Date getMODIFICADOEN_ideas() {
        return MODIFICADOEN_ideas;
    }

    public void setMODIFICADOEN_ideas(Date MODIFICADOEN_ideas) {
        this.MODIFICADOEN_ideas = MODIFICADOEN_ideas;
    }

    public int getID_objetivo() {
        return ID_objetivo;
    }

    public void setID_objetivo(int ID_objetivo) {
        this.ID_objetivo = ID_objetivo;
    }

    public int getID_T_IDEA_objetivo() {
        return ID_T_IDEA_objetivo;
    }

    public void setID_T_IDEA_objetivo(int ID_T_IDEA_objetivo) {
        this.ID_T_IDEA_objetivo = ID_T_IDEA_objetivo;
    }

    public String getDESCRIPCION_objetivo() {
        return DESCRIPCION_objetivo;
    }

    public void setDESCRIPCION_objetivo(String DESCRIPCION_objetivo) {
        this.DESCRIPCION_objetivo = DESCRIPCION_objetivo;
    }

    public String getCREADOPOR_objetivo() {
        return CREADOPOR_objetivo;
    }

    public void setCREADOPOR_objetivo(String CREADOPOR_objetivo) {
        this.CREADOPOR_objetivo = CREADOPOR_objetivo;
    }

    public Date getCREADOEN_objetivo() {
        return CREADOEN_objetivo;
    }

    public void setCREADOEN_objetivo(Date CREADOEN_objetivo) {
        this.CREADOEN_objetivo = CREADOEN_objetivo;
    }

    public String getMODIFICADOPOR_objetivo() {
        return MODIFICADOPOR_objetivo;
    }

    public void setMODIFICADOPOR_objetivo(String MODIFICADOPOR_objetivo) {
        this.MODIFICADOPOR_objetivo = MODIFICADOPOR_objetivo;
    }

    public Date getMODIFICADOEN_objetivo() {
        return MODIFICADOEN_objetivo;
    }

    public void setMODIFICADOEN_objetivo(Date MODIFICADOEN_objetivo) {
        this.MODIFICADOEN_objetivo = MODIFICADOEN_objetivo;
    }

}
