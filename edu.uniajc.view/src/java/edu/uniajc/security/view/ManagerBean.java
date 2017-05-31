/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;

import edu.uniajc.ideaBank.view.UserBean;
import java.io.Serializable;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.primefaces.context.RequestContext;

/**
 * <h1>Manager para Beans</h1>
 * Clase padre para las clase ManagedBean.
 * 
 * @author shpreciado
 * @version 1.0
 * @since 2017-05-25
 */
public class ManagerBean implements Serializable {
    
    /**
     * Constructor por defecto.
     */
    public ManagerBean() {
    }

    /**
     * Inicializa el contexto para manejo de corba.
     * @return Context Contexto de la aplicación.
     */
    public static InitialContext getContext() {
        try {
            Properties props = new Properties();
            props.put(Context.INITIAL_CONTEXT_FACTORY, Constants.CORBA_CONTEXT_FACTORY);
            props.setProperty(Constants.CORBA_HOST, Constants.CORBA_HOST_VALUE);
            props.setProperty(Constants.CORBA_PORT, Constants.CORBA_PORT_VALUE);
            InitialContext ctx = new InitialContext(props);
            return ctx;
        } catch (NamingException ex) {
            Logger.getLogger(UserBean.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    /**
     * Agrega objetos a la sesión.
     * @param key Llave del objeto a poner en sesión.
     * @param value Objeto a poner en sesión.
     */
    public void addToSession(String key, Object value) {
        FacesContext.getCurrentInstance().getExternalContext().getSessionMap().put(key, value);
    }

    /**
     * Obtiene objetos de la sesión.
     * @param key Llave del objeto en sesión.
     * @return Objeto en la sesión.
     */
    public Object getFromSession(String key) {
        return FacesContext.getCurrentInstance().getExternalContext().getSessionMap().get(key);
    }

    /**
     * Muestra mensaje de texto.
     * @param type Tipo de mensaje FacesMessage.SEVERITY_INFO | FacesMessage.SEVERITY_WARN | FacesMessage.SEVERITY_ERROR.
     * @param text Texto a mostrar.
     * @code showMessage(FacesMessage.SEVERITY_ERROR, "Se presentó un error!!!");
     */
    public void showMessage(FacesMessage.Severity type, String text) {
        FacesMessage message = new FacesMessage(type, text, null);
        FacesContext.getCurrentInstance().addMessage(null, message);
    }
    
    /**
     * Muestra mensaje de texto usando una ventana de dialogo.
     * @param type Tipo de mensaje FacesMessage.SEVERITY_INFO | FacesMessage.SEVERITY_WARN | FacesMessage.SEVERITY_ERROR.
     * @param title Título de la ventana.
     * @param text Texto a mostrar.
     * @code showMessageDialog(FacesMessage.SEVERITY_ERROR, "Errores", "Se presentó un error!!!");
     */
    public void showMessageDialog(FacesMessage.Severity type, String title, String text) {
        FacesMessage message = new FacesMessage(type, title, text);
        RequestContext.getCurrentInstance().showMessageInDialog(message);
    }
}
