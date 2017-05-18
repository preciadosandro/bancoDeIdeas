/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;

import edu.uniajc.ideaBank.Utilities.Utilities;
import edu.uniajc.ideaBank.interfaces.IUser;
import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.ideaBank.logic.services.UserService;
import java.io.Serializable;
import java.sql.SQLException;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.naming.NamingException;

/**
 *
 * @author Lenovo
 */
@ManagedBean(name = "newPasswordBean")
@ViewScoped
public class NewPasswordBean implements Serializable  {
    
    private String token;
    private String password;
    private String passwordConfirm;

    /**
     * Creates a new instance of NewPasswordBean
     */
    public NewPasswordBean() {
        
    }
    
    public String gettoken() {
        return token;
    }

    public void settoken(String password) {
        this.token = token;
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
    
    public void newContraseña() throws NamingException, SQLException {
        IUser uDao = new UserService();
        User userModel = new User();
        
        
        FacesContext context = FacesContext.getCurrentInstance();    
        
        if (this.getPassword().equals(this.getPasswordConfirm())) {
             password = Utilities.Encriptar(password);
              /*userModel = uDao.createUser(idTypeUser, 1, idTypeId, numId, firstName,
                            secondName, lastName, lastName2, phone, cellPhone, user,
                            password);*/
             context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                                "La cotraseña fue cambiada con exito.", ""));
        }
        else {
              context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
                        "Las contraseñas no corresponden", ""));
        }
    }

}
