/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import java.io.Serializable;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;

/**
 *
 * @author Lenovo
 */

@ManagedBean(name = "IdeaNewBean")
@ViewScoped
public class IdeaNewBean implements Serializable{
     //private String titleIdea;
     private boolean PrivateIdea;
     //private String description;
     //private String Objetivos;
     //private String palabrasClave;
     
     
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
    
}
