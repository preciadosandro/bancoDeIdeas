/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;

import edu.uniajc.ideaBank.interfaces.model.User;
import javax.inject.Named;

import java.io.Serializable;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;

/**
 *
 * @author Lenovo
 */
@ManagedBean(name = "TempletePrincipalBean")

//@Named(value = "templetePrincipalBean")
@ViewScoped
public class TempletePrincipalBean extends ManagerBean implements Serializable {

    /**
     * Creates a new instance of TempletePrincipalBean
     */
    private User user;
    private boolean enableMenuTop;
    private boolean enableCloseSession;
    public TempletePrincipalBean() {        
        this.user = (User) super.getFromSession(Constants.SESSION_KEY_USER);
        
        if (this.user == null || this.user.getId() == 0) {
            System.out.println("NOOOOOOO");
            // No esta autenticado ==> direccionar a pantalla login
            this.enableMenuTop = true;
            this.enableCloseSession = false;
        } else {
            System.out.println("SIIIIII"); 
            this.enableMenuTop = false;
            this.enableCloseSession = true;
        }
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public boolean isEnableMenuTop() {
        return enableMenuTop;
    }

    public void setEnableMenuTop(boolean enableMenuTop) {
        this.enableMenuTop = enableMenuTop;
    }

    public boolean isEnableCloseSession() {          
        return enableCloseSession;
    }

    public void setEnableCloseSession(boolean enableCloseSession) {
        this.enableCloseSession = enableCloseSession;
    }
    
    public void closeSession(){
        System.out.println("Cerrando session");
        User user=new User();
        user=null;
        super.addToSession(Constants.SESSION_KEY_USER, user);  
        linklogin();
    }
    
    public void linklogin() {
        FacesContext context = FacesContext.getCurrentInstance();
        try {
            context.getExternalContext().redirect("login.xhtml");
        } catch (Exception e) {
            Logger.getLogger(NewPasswordBean.class.getName()).log(Level.SEVERE, null, e);
        }
    }
}
