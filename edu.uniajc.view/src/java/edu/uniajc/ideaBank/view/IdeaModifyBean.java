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
@ManagedBean(name = "IdeaModifyBean")
@ViewScoped
public class IdeaModifyBean implements Serializable{
     private String titleIdea;
     private boolean PrivateIdea;
     
        public String gettitleIdea() {
        return titleIdea;
    }
      
      public void settitleIdea(String titleIdea) {
        this.titleIdea = titleIdea;
    }
      
     public boolean getPrivateIdea() {
        return PrivateIdea;
    }
      
      public void setPrivateIdea(boolean  PrivateIdea) {
        this.PrivateIdea = PrivateIdea;
    }
      
      public void addMessage() {
        String summary = PrivateIdea ? "Checked" : "Unchecked";        
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(summary));
               
    }      
    
}
