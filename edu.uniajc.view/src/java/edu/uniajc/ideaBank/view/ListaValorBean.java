/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.interfaces.IListaValor;
import edu.uniajc.ideaBank.interfaces.model.ListaValor;
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
 * @author rlara
 */
@ManagedBean(name = "listaValorBean")
@ViewScoped
public class ListaValorBean implements Serializable {

    private ListaValor listaValor;
    private String listaValorConfirm;

    public ListaValorBean() {
        listaValor = new ListaValor();
    }
    
    public ListaValor getListaValor() {
        return listaValor;
    }

    public void setListaValor(ListaValor listaValor) {
        this.listaValor = listaValor;
    }

    public String getListaValorConfirm() {
        return listaValorConfirm;
    }

    public void setListaValorConfirm(String listaValorConfirm) {
        this.listaValorConfirm = listaValorConfirm;
    }

    public void newListaValor() {
        IListaValor listaValorDao =null;
        boolean confirmListaValor;
        FacesContext context = FacesContext.getCurrentInstance();
        
        try {
            InitialContext ctx = getContext();
            listaValorDao = (IListaValor) ctx.lookup("java:global/edu.uniajc.view/ListaValorService!edu.uniajc.ideaBank.interfaces.IListaValor");
        } catch (Exception e) {
        }
        /*
        if (listaValor.getValor().equals(this.getListaValorConfirm())) {
            if (listaValor.getContrasena().equals(this.getPasswordConfirm())) {
                confirmListaValor = uDao.createListaValor(this.listaValor);
                if (confirmListaValor == false) {
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
        */
    }

    public void linkListaValor() {
        FacesContext context = FacesContext.getCurrentInstance();
        try {
            context.getExternalContext().redirect("listaValor.xhtml");
        } catch (Exception e) {
        }
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
            Logger.getLogger(ListaValorBean.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    public boolean isChecked() {
        return listaValor.getEstado() != 0;
    }

    public void setChecked(boolean checked) {
        listaValor.setEstado(checked ? 1 : 0);
    }
}
