/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.interfaces.IListaValor;
import edu.uniajc.ideaBank.interfaces.model.ListaValor;
import java.io.Serializable;
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
 * @author rlara
 */

@ManagedBean(name = "listaValorBean")
@SessionScoped
public class ListaValorBean implements Serializable {

    private ListaValor listaValor;
     
    private String listaValorConfirm;
    
    IListaValor uDao = null;

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

        int validator;
        FacesContext context = FacesContext.getCurrentInstance();

        try {
            InitialContext ctx = getContext();
            uDao = (IListaValor) ctx.lookup("java:global/edu.uniajc.view/ListaValorService!edu.uniajc.ideaBank.interfaces.IListaValor");
        } catch (Exception e) {
            Logger.getLogger(ListaValorBean.class.getName()).log(Level.SEVERE, null, e);
        }

        if (listaValor.getAgrupacion().equals(this.getListaValorConfirm())) {
            
            validator = uDao.createListaValor(this.listaValor);
            switch (validator) {
                case -1:
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_FATAL,
                            "Los datos no fueron guardados. 'Problemas en el listaValorDAO'", ""));
                    break;
                case 0:
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                            "Los datos fueron guardados.", ""));
                    RequestContext.getCurrentInstance().execute("PF('dialogOk').show()");
                    break;
                case -2:
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                            "Numero de identificación ya se encuentra registrado.", ""));
                    break;
                case -3:
                    context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                            "Usuario y/o correo ya se encuentra registrado.", ""));
                    break;
                default:
                    break;
            }
        } else {
            context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
                    "Las contraseñas no corresponden", ""));
        }
        /*} else {
            context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
                    "Los correos electronicos no son iguales", ""));
        }*/
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
            
            props.setProperty("org.omg.CORBA.ORBInitialPort", "3700");
            InitialContext ctx = new InitialContext(props);
            return ctx;
        } catch (NamingException ex) {
            Logger.getLogger(ListaValorBean.class.getName()).log(Level.SEVERE, null, ex);            
            return null;
        }
    }
    
    public boolean isChecked() {
        return listaValor.getEstado()!= 0;
    }

    public void setChecked(boolean checked) {
        listaValor.setEstado(checked ? 1 : 0);
    }
}
