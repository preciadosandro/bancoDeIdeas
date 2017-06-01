/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;


import edu.uniajc.ideaBank.interfaces.IV_rolrequest;
import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.ideaBank.interfaces.model.V_rolrequest;

import edu.uniajc.ideaBank.logic.services.V_rolrequestService;
import static edu.uniajc.ideaBank.view.UserManagerBean.getContext;
import java.io.Serializable;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.primefaces.context.RequestContext;
import org.primefaces.event.RowEditEvent;


/**
 *
 * @author jorge.castaño
 */
@ManagedBean(name =  "role_requestBean")
@ViewScoped
public class RolerequestBean implements Serializable{

    
    
    private V_rolrequest userrolre;
    
    private List<V_rolrequest> filteredV_rolrequest;
    private List<V_rolrequest> rolrequestsList2 ;
    IV_rolrequest VuDao = null;

    
    private V_rolrequest selectV_rolrequest;
   

   private V_rolrequestService rolrequest2 = new V_rolrequestService();

   
   public void init(){
     rolrequestsList2 = rolrequest2.getRolrequests2();   
   }

    public V_rolrequest getUserrolre() {
        return userrolre;
    }

    public void setUserrolre(V_rolrequest userrolre) {
        this.userrolre = userrolre;
    }


    
        public List<V_rolrequest> getRolrequestsList2() {
        if ( rolrequestsList2 == null ){
            init();
        }
        return rolrequestsList2;
    }
        


    public V_rolrequest getSelectV_rolrequest() {
        return selectV_rolrequest;
    }
        

        public void updateUserROL() {
        
        int validator;
        FacesContext context = FacesContext.getCurrentInstance();


            InitialContext ctx = getContext();
        try {
            VuDao = (IV_rolrequest) ctx.lookup("java:global/edu.uniajc.view/V_rolrequestService!edu.uniajc.ideaBank.interfaces.IV_rolrequest");
        } catch (NamingException ex) {
            Logger.getLogger(RolerequestBean.class.getName()).log(Level.SEVERE, null, ex);
        }

        validator = VuDao.updateUserRol(this.userrolre);
        switch (validator) {
            case -1:
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_FATAL,
                        "Los datos no fueron guardados. 'Problemas en el V_rolrequestDAO (methodo updateUserRol)'", ""));
                break;
            case 0:
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                        "Los datos fueron guardados.", ""));
                RequestContext.getCurrentInstance().execute("PF('dialogUpdateUserRol').hide()");
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
        
        
        
        
 
        
    


    public void setFilteredV_rolrequest(List<V_rolrequest> filteredV_rolrequest) {
        this.filteredV_rolrequest = filteredV_rolrequest;
    }

    public void setSelectV_rolrequest(V_rolrequest selectV_rolrequest) {
        this.selectV_rolrequest = selectV_rolrequest;
    }
    
    

    
    
}
