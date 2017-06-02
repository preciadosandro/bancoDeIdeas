/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;

import edu.uniajc.ideaBank.interfaces.model.User;
import javax.inject.Named;
import javax.enterprise.context.SessionScoped;
import java.io.Serializable;

/**
 *
 * @author Lenovo
 */
@Named(value = "templetePrincipalBean")
@SessionScoped
public class TempletePrincipalBean extends ManagerBean implements Serializable {

    /**
     * Creates a new instance of TempletePrincipalBean
     */
    private User user;
    private boolean enableMenu;
    private boolean enableCloseSession;
    public TempletePrincipalBean() {
        
        user = (User) super.getFromSession(Constants.SESSION_KEY_USER);
        
        if (user == null || user.getId() == 0) {
            // No esta autenticado ==> direccionar a pantalla login
            enableMenu = true;
            enableCloseSession = false;
        } else {
            enableMenu = false;
            enableCloseSession = true;
        }
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public boolean isEnableMenu() {
        return enableMenu;
    }

    public void setEnableMenu(boolean enableMenu) {
        this.enableMenu = enableMenu;
    }

    public boolean isEnableCloseSession() {
        return enableCloseSession;
    }

    public void setEnableCloseSession(boolean enableCloseSession) {
        this.enableCloseSession = enableCloseSession;
    }
    
}
