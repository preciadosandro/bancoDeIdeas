/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.interfaces.IUser;
import edu.uniajc.ideaBank.interfaces.model.User;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ViewScoped;
import javax.faces.bean.ManagedBean;
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
public class UserBean implements Serializable {

    private User user;
    private String userConfirm;
    private String passwordConfirm;

    public UserBean() {
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

    public void newUser() {
        IUser uDao =null;
        boolean confirmUser;
        FacesContext context = FacesContext.getCurrentInstance();
        
        try {
            InitialContext ctx = getContext();
            uDao = (IUser) ctx.lookup("java:global/edu.uniajc.view/UserService!edu.uniajc.ideaBank.interfaces.IUser");
            //Borrate esto!!
        } catch (Exception e) {
        }
        
        if (user.getUsuario().equals(this.getUserConfirm())) {
            if (user.getContrasena().equals(this.getPasswordConfirm())) {
                confirmUser = uDao.createUser(this.user);
                if (confirmUser == false) {
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                            "Los datos no fueron guardados.", ""));
                } else {
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                            "Los datos fueron guardados.", ""));
                    RequestContext.getCurrentInstance().execute("PF('dialogOk').show()");
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

    public void linklogin() {
        FacesContext context = FacesContext.getCurrentInstance();
        try {
            context.getExternalContext().redirect("login.xhtml");
        } catch (Exception e) {
        }
    }

    public void onDateSelect(SelectEvent event) {
        FacesContext facesContext = FacesContext.getCurrentInstance();
        SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
        facesContext.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO, "Date Selected", format.format(event.getObject())));
    }

    public void click() {
        RequestContext requestContext = RequestContext.getCurrentInstance();
        requestContext.update("form:display");
        requestContext.execute("PF('dlg').show()");
    }

    public static InitialContext getContext() {
        try {
            Properties props = new Properties();
            props.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.enterprise.naming.SerialInitContextFactory");
            props.setProperty("org.omg.CORBA.ORBInitialHost", "localhost");
            // glassfish default port value will be 3700,
            props.setProperty("org.omg.CORBA.ORBInitialPort", "3700");
            InitialContext ctx = new InitialContext(props);
            return ctx;
        } catch (NamingException ex) {
            Logger.getLogger(UserBean.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
}
