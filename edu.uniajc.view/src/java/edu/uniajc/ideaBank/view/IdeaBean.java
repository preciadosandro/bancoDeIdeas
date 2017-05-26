/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.DAO.IdeaDAO;
import edu.uniajc.ideaBank.interfaces.model.IdeasObjetivos;
import java.util.List;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;

/**
 *
 * @author LMIRANDA
 */
@ManagedBean
@RequestScoped
public class IdeaBean {

    private IdeasObjetivos IdeasObjetivos = new IdeasObjetivos();
    private List<IdeasObjetivos> lstIdeas;
    private IdeasObjetivos IdeasObjetivosXid = new IdeasObjetivos();
    private List<IdeasObjetivos> LstIdeasXid;
    private Integer idSelected = 0;
    IdeaDAO dao;

    public IdeasObjetivos getIdeasObjetivos() {
        return IdeasObjetivos;
    }

    public void setIdeasObjetivos(IdeasObjetivos IdeasObjetivos) {
        this.IdeasObjetivos = IdeasObjetivos;
    }

    public IdeasObjetivos getIdeasObjetivosXid() {
        return IdeasObjetivosXid;
    }

    public void setIdeasObjetivosXid(IdeasObjetivos IdeasObjetivosXid) {
        this.IdeasObjetivosXid = IdeasObjetivosXid;
    }

    public List<IdeasObjetivos> getLstIdeas() {
        listar();
        return lstIdeas;
    }

    public void setLstIdeas(List<IdeasObjetivos> lstIdeas) {
        this.lstIdeas = lstIdeas;
    }

    public Integer getIdSelected() {
        return idSelected;
    }

    public void setIdSelected(Integer idSelected) {
        this.idSelected = idSelected;
    }

    public List<IdeasObjetivos> getLstIdeasXid() {
        listarxid(idSelected);
        return LstIdeasXid;
    }

    public void setLstIdeasXid(List<IdeasObjetivos> LstIdeasXid) {
        this.LstIdeasXid = LstIdeasXid;
    }

    public void listar() {

        try {
            if (dao == null) {
                dao = new IdeaDAO();
            }
            lstIdeas = dao.listar();
            int a = 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

    public void listarxid(int id) {

        try {
            System.out.println("---id---" + id);
            if (id != 0) {
                if (dao == null) {
                    dao = new IdeaDAO();
                }
                LstIdeasXid = dao.listarxid(id);
            }
            int a = 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

}
