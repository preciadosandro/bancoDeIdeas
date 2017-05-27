/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.interfaces.IUser;
import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.ideaBank.logic.services.UserService;
import edu.uniajc.security.view.Constants;
import edu.uniajc.security.view.ManagerBean;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ViewScoped;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.primefaces.context.RequestContext;
import org.primefaces.event.SelectEvent;

/**
 *
 * @author Bladimir Morales
 */
@ManagedBean(name = "userBean")
@ViewScoped
public class UserBean extends ManagerBean implements Serializable {

    private User user;     
    private String userConfirm;
    private String passwordConfirm;
    private Date currentDate = new Date();
    private InitialContext ctx;
     
    IUser uDao = null;

    public UserBean() {     
        super();
        ctx = ManagerBean.getContext();
        user = new User();
    }
 
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getUserConfirm() {
        return userConfirm;
    }

    public void setUserConfirm(String userConfirm) {
        this.userConfirm = userConfirm;
    }

    public String getPasswordConfirm() {
        return passwordConfirm;
    }

    public void setPasswordConfirm(String passwordConfirm) {
        this.passwordConfirm = passwordConfirm;
    }

    public Date getCurrentDate() {
        return currentDate;
    }

    public void newUser() {

        int validator;

        try {            
            uDao = (IUser) ctx.lookup("java:global/edu.uniajc.view/UserService!edu.uniajc.ideaBank.interfaces.IUser");
        } catch (Exception e) {
            Logger.getLogger(UserBean.class.getName()).log(Level.SEVERE, null, e);
        }

        if (user.getUsuario().equals(this.getUserConfirm())) {
            if (user.getContrasena().equals(this.getPasswordConfirm())) {
                validator = uDao.createUser(this.user);
                switch (validator) {
                    case -1:
                        super.showMessage(FacesMessage.SEVERITY_INFO, 
                                "Los datos no fueron guardados. 'Problemas en el userDAO'");
                        break; 
                    case 0:
                        RequestContext.getCurrentInstance().execute("PF('dialogOk').show()");
                        break;
                    case -2:
                        super.showMessage(FacesMessage.SEVERITY_INFO, "Numero de identificación ya se encuentra registrado.");
                        break;
                    case -3:
                        super.showMessage(FacesMessage.SEVERITY_INFO, "Usuario y/o correo ya se encuentra registrado.");
                        break;
                    default:
                        break;
                }
            } else {
                super.showMessage(FacesMessage.SEVERITY_INFO, "Las contraseñas no corresponden.");
            }
        } else {
            super.showMessage(FacesMessage.SEVERITY_INFO, "Los correos electronicos no son iguales.");
        }
    }    

    public void linklogin() {
        FacesContext context = FacesContext.getCurrentInstance();
        try {
            context.getExternalContext().redirect("login.xhtml");
        } catch (Exception e) {
            Logger.getLogger(UserBean.class.getName()).log(Level.SEVERE, null, e);
        }
    }

    public void onDateSelect(SelectEvent event) {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
        facesContext.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                "Date Selected", format.format(event.getObject())));
    }

    public void click() {
        RequestContext requestContext = RequestContext.getCurrentInstance();
        requestContext.update("form:display");
        requestContext.execute("PF('dlg').show()");
    }
}
