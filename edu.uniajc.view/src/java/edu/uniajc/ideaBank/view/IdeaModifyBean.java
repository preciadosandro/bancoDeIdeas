/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.security.view.Constants;
import edu.uniajc.security.view.ManagerBean;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.naming.InitialContext;

/**
 *
 * @author Lenovo
 */
@ManagedBean(name = "IdeaModifyBean")
@ViewScoped
public class IdeaModifyBean extends ManagerBean {
     private String titleIdea;
     private boolean PrivateIdea;

    private User user;
    private InitialContext ctx;

    public IdeaModifyBean() {
        super();
        ctx = super.getContext();
        // obtiene objeto de la sesion
        user = (User) super.getFromSession(Constants.SESSION_KEY_USER);
        if (user == null || user.getId()== 0) {
            // No esta autenticado ==> direccionar a pantalla login
            super.redirect("login.xhtml");
        }
    }    
     
    public String gettitleIdea() {
        return titleIdea;
    }

    public void settitleIdea(String titleIdea) {
        this.titleIdea = titleIdea;
    }

    public boolean getPrivateIdea() {
        return PrivateIdea;
    }

    public void setPrivateIdea(boolean PrivateIdea) {
        this.PrivateIdea = PrivateIdea;
    }

    public void addMessage() {
        String summary = PrivateIdea ? "Checked" : "Unchecked";
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(summary));

    }

}
