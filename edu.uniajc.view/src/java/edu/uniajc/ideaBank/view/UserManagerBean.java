/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.interfaces.IUser;
import edu.uniajc.ideaBank.interfaces.model.User;
import static edu.uniajc.ideaBank.view.UserBean.getContext;
import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.primefaces.context.RequestContext;

/**
 *
 * @author Lenovo
 */
@ManagedBean(name = "userManagerBean")
@SessionScoped
public class UserManagerBean implements Serializable{
    
    private User user;
    private List<User> listUser;
    IUser uDao = null;
    private Date currentDate = new Date();
    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
    public List<User> getListUser() {
        try {
            InitialContext ctx = getContext();
            uDao = (IUser) ctx.lookup("java:global/edu.uniajc.view/UserService!edu.uniajc.ideaBank.interfaces.IUser");
        } catch (Exception e) {
        }
        listUser = uDao.listaUser();
        return listUser;
    }

    public void setListUser(List<User> listUser) {
        this.listUser = listUser;
    }

    public Date getCurrentDate() {
        return currentDate;
    }

    public void setCurrentDate(Date currentDate) {
        this.currentDate = currentDate;
    }
    
    
    
    public void updateUser() {
        
        int validator;
        FacesContext context = FacesContext.getCurrentInstance();

        try {
            InitialContext ctx = getContext();
            uDao = (IUser) ctx.lookup("java:global/edu.uniajc.view/UserService!edu.uniajc.ideaBank.interfaces.IUser");
        } catch (Exception e) {
        }
        validator = uDao.updateUser(this.user);
        switch (validator) {
            case -1:
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_FATAL,
                        "Los datos no fueron guardados. 'Problemas en el userDAO (methodo updateUser)'", ""));
                break;
            case 0:
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                        "Los datos fueron guardados.", ""));
                RequestContext.getCurrentInstance().execute("PF('dialogUpdateUser').hide()");
                break;
            default:
                break;
        }
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
