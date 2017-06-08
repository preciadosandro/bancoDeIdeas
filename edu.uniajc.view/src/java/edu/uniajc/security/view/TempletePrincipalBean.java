/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;

import edu.uniajc.ideaBank.interfaces.model.User;
import javax.inject.Named;

import java.io.Serializable;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;

/**
 *
 * @author Lenovo
 */
@ManagedBean(name = "TempletePrincipalBean")

//@Named(value = "templetePrincipalBean")
@SessionScoped
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
    
}
