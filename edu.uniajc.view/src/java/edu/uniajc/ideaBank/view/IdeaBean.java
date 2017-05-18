/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.DAO.IdeaDAO;
import edu.uniajc.ideaBank.interfaces.model.Idea;
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

    public IdeasObjetivos getIdeasObjetivos() {
        return IdeasObjetivos;
    }

    public void setIdeasObjetivos(IdeasObjetivos IdeasObjetivos) {
        this.IdeasObjetivos = IdeasObjetivos;
    }

    public List<IdeasObjetivos> getLstIdeas() {
        listar();
        return lstIdeas;
    }

    public void setLstIdeas(List<IdeasObjetivos> lstIdeas) {
        this.lstIdeas = lstIdeas;
    }

    public void listar() {
        IdeaDAO dao;

        try {
            dao = new IdeaDAO();
            lstIdeas = dao.listar();
            int a = 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

}
