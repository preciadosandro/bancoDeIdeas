/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.Utilities.Utilities;
import edu.uniajc.ideaBank.interfaces.IUser;
import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.ideaBank.logic.services.UserService;
import java.io.Serializable;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ViewScoped;
import javax.faces.bean.ManagedBean;
import javax.faces.context.FacesContext;

/**
 *
 * @author Lenovo
 */
@ManagedBean(name = "loginBean")
@ViewScoped
public class LoginBean implements Serializable {

    private boolean typeProject;     
    private String email;
    private String password;

    public boolean isTypeProject() {
        return typeProject;
    }

    public void setTypeProject(boolean typeProject) {
        this.typeProject = typeProject;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    
    




    /*public void newLogin() {
        
        IUser uDao = new UserService();
        User userModel = new User();
        boolean validatorNumId;
        boolean validatorUser;
        FacesContext context = FacesContext.getCurrentInstance();
        if (this.getUser().equals(this.getUserConfirm())) {
            if (this.getPassword().equals(this.getPasswordConfirm())) {
                validatorNumId = this.getUserByNumId();
                validatorUser = this.getUserByUser();
                if (validatorUser == false && validatorNumId == false) {
                    password = Utilities.Encriptar(password);
                    userModel = uDao.createUser(idTypeUser, 1, idTypeId, numId, firstName,
                            secondName, lastName, lastName2, phone, cellPhone, user,
                            password);
                    if (userModel == null) {
                        context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                                "Los datos no fueron guardados.", ""));
                    } else {
                        context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                                "Los datos fueron guardados.", ""));
                        try {
                            context.getExternalContext().redirect("login.xhtml");
                            return;
                        } catch (Exception e) {
                        }
                    }
                } else if (validatorUser == true) {
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                            "El correo electronico ya se encuentra registrado.", ""));
                } else {
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                            "El numero de identificación ya se encuentra registrado.", ""));
                }

            } else {
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
                        "Las contraseñas no corresponden", ""));
            }

        } else {
            context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
                    "Los correos electronicos no son iguales", ""));
        }

    }

    public boolean getUserByUser() {
        IUser uDao = new UserService();
        boolean validator = uDao.getUserByUser(this.getUser());
        return validator;
    }

    public boolean getUserByNumId() {
        IUser uDao = new UserService();
        boolean validator = uDao.getUserByNumId(this.getNumId());
        return validator;
    }*/
}
