/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.interfaces.IIdeasObjetivos;
import edu.uniajc.ideaBank.interfaces.model.IdeasObjetivos;
import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.security.view.Constants;
import edu.uniajc.security.view.ManagerBean;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.naming.InitialContext;

/**
 *
 * @author LMIRANDA
 */
@ManagedBean
@ViewScoped
public class IdeaListBean extends ManagerBean {

    private IdeasObjetivos IdeasObjetivos = new IdeasObjetivos();
    private List<IdeasObjetivos> lstIdeas;
    private IdeasObjetivos IdeasObjetivosXid = new IdeasObjetivos();
    private List<IdeasObjetivos> LstIdeasXid;
    private Integer idSelected = 0;
    private User user;
    private InitialContext ctx;

    public IdeaListBean() {
        super();
        ctx = super.getContext();
        // obtiene objeto de la sesion
        user = (User) super.getFromSession(Constants.SESSION_KEY_USER);
        if (user == null || user.getId()== 0) {
            // No esta autenticado ==> direccionar a pantalla login
            super.redirect("login.xhtml");
        }
    }    

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
            IIdeasObjetivos userService = (IIdeasObjetivos) ctx.lookup("java:global/edu.uniajc.view/IdeasObjetivosService!edu.uniajc.ideaBank.interfaces.IIdeasObjetivos");
            lstIdeas = userService.lista();            
        } catch (Exception e) {
            Logger.getLogger(IdeaListBean.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            super.showMessage(FacesMessage.SEVERITY_ERROR, e.toString());
        }

    }

    public void listarxid(int id) {

        try {
            IIdeasObjetivos userService = (IIdeasObjetivos) ctx.lookup("java:global/edu.uniajc.view/IdeasObjetivosService!edu.uniajc.ideaBank.interfaces.IIdeasObjetivos");
            LstIdeasXid = userService.listarXid(id);
        } catch (Exception e) {
            Logger.getLogger(IdeaListBean.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            super.showMessage(FacesMessage.SEVERITY_ERROR, e.toString());
        }

    }

}
