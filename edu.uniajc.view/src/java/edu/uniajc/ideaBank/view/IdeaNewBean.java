/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.interfaces.IIdea;
import edu.uniajc.ideaBank.interfaces.model.Idea;
import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.security.view.Constants;
import edu.uniajc.security.view.ManagerBean;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.naming.InitialContext;

/**
 *
 * @author Lenovo
 */

@ManagedBean(name = "IdeaNewBean")
@ViewScoped
public class IdeaNewBean extends ManagerBean {
     //private String titleIdea;
     private boolean PrivateIdea;
     //private String description;
     //private String Objetivos;
     //private String palabrasClave;
     
    private User user;
    private InitialContext ctx;

    public IdeaNewBean() {
        super();
        ctx = super.getContext();
        // obtiene objeto de la sesion
        user = (User) super.getFromSession(Constants.SESSION_KEY_USER);
        if (user == null || user.getId()== 0) {
            // No esta autenticado ==> direccionar a pantalla login
            super.redirect("login.xhtml");
        }
    }    
     
    /* public String gettitleIdea() {
        return titleIdea;
    }
      
      public void settitleIdea(String titleIdea) {
        this.titleIdea = titleIdea;
    }
    */
     public boolean getPrivateIdea() {
        return PrivateIdea;
    }
      
    public void setPrivateIdea(boolean  PrivateIdea) {
        this.PrivateIdea = PrivateIdea;
    }
      
    /*   public String getdescription() {
        return description;
    }
      
      public void setdescription(String description) {
        this.description = description;
    }
      
      public String getObjetivos() {
        return Objetivos;
    }
      
      public void setObjetivos(String Objetivos) {
        this.Objetivos = Objetivos;
    }
      
    
      public String getpalabrasClave() {
        return palabrasClave;
    }
      
      public void setpalabrasClave(String palabrasClave) {
        this.palabrasClave = palabrasClave;
    }
      
      */
      
      public void addMessage() {
        String summary = PrivateIdea ? "Privada" : "Publica";        
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(summary));
               
    } 
      public void newIdea() {
        try {
            IIdea ideaService = (IIdea) ctx.lookup("java:global/edu.uniajc.view/IIdea!edu.uniajc.ideaBank.interfaces.IIdea");
            Idea idea = new Idea();
            /*
                llenar el objeto idea con los valores de la pantalla 
            */
            PrivateIdea = ideaService.createIdea(idea);
            super.showMessage(FacesMessage.SEVERITY_INFO, "Idea creada con éxito");
        } catch (Exception e) {
            Logger.getLogger(IdeaNewBean.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            super.showMessage(FacesMessage.SEVERITY_ERROR, e.toString());
        }

    }
    
}
