/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;

import edu.uniajc.ideaBank.Utilities.Utilities;
import edu.uniajc.ideaBank.interfaces.IUser;
import edu.uniajc.ideaBank.interfaces.model.User;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.naming.InitialContext;

/**
 *
 * @author Lenovo
 */
@ManagedBean(name = "newPasswordBean")
@ViewScoped
public class NewPasswordBean extends ManagerBean{
    
    private String password;
    private String passwordConfirm;
    private User user;
    private InitialContext ctx;

    /**
     * Creates a new instance of NewPasswordBean
     */
    public NewPasswordBean() {
        super();
        ctx = super.getContext();
        // obtiene objeto de la sesion
        user = (User) super.getFromSession(Constants.SESSION_KEY_USER);        
        if (user == null || user.getId()== 0) {
            // No esta autenticado ==> direccionar a pantalla login
            super.redirect("login.xhtml");
        }
    }
    
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPasswordConfirm() {
        return passwordConfirm;
    }

    public void setPasswordConfirm(String passwordConfirm) {
        this.passwordConfirm = passwordConfirm;
    }
    
    public void newPassword() {
        try {
            //IUser userService = new UserService();
            IUser userService = (IUser) ctx.lookup("java:global/edu.uniajc.view/UserService!edu.uniajc.ideaBank.interfaces.IUser");

            if ( user!=null && getPassword().equals(getPasswordConfirm())) {
                String pass = Utilities.Encriptar(password);
                user.setContrasena(pass);
                userService.newPassword(user);
                password = " ";
                passwordConfirm = " ";
                super.showMessage(FacesMessage.SEVERITY_INFO, "La contraseña fue cambiada con exito");
                // coloca objeto en la sesion
                super.addToSession(Constants.SESSION_KEY_USER, user);
            }
            else {
                super.showMessage(FacesMessage.SEVERITY_WARN, "Las contraseñas no corresponden");
            }
            
        } catch (Exception e) {
                Logger.getLogger(NewPasswordBean.class.getName()).log(Level.SEVERE, null, e);    
                super.showMessage(FacesMessage.SEVERITY_ERROR, e.toString());
        }
        

    }

}
