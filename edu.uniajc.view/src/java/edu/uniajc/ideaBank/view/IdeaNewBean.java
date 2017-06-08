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
import java.io.Serializable;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.naming.InitialContext;

/**
 *
 * @author Nathalia Riascos
 */

@ManagedBean(name = "IdeaNewBean")
@ViewScoped
public class IdeaNewBean extends ManagerBean {
     
        
    private User user;
    private InitialContext ctx;
    IIdea uDao = null;
    private String titulo;
    private boolean privateIdea; 
    private String descripcion;
    private String objetivos;
    private String palabrasClaves;
    
    

    public IdeaNewBean() {
        super();
        ctx = super.getContext();
        // obtiene objeto de la sesion
        user = (User) super.getFromSession(Constants.SESSION_KEY_USER);
        ///*
        if (user == null || user.getId()== 0) {
            // No esta autenticado ==> direccionar a pantalla login
            super.redirect("login.xhtml");
        }
        //*/
    }    

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }
    
    public boolean getPrivateIdea() {
        return privateIdea;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getObjetivos() {
        return objetivos;
    }

    public void setObjetivos(String objetivos) {
        this.objetivos = objetivos;
    }

    public String getPalabrasClaves() {
        return palabrasClaves;
    }

    public void setPalabrasClaves(String palabrasClaves) {
        this.palabrasClaves = palabrasClaves;
    }
          
    public void setPrivateIdea(boolean privateIdea) {
        this.privateIdea = privateIdea;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
    
      public void addMessage() {
        String summary = privateIdea ? "Privada" : "Publica";
        super.showMessage(FacesMessage.SEVERITY_INFO, summary);               
    } 
      public void newIdea() {
          int validator;
        try {
            IIdea ideaService = (IIdea) ctx.lookup("java:global/edu.uniajc.view/IdeaService!edu.uniajc.ideaBank.interfaces.IIdea");
            Idea idea = new Idea();           
          
            idea.setidUsuario(user.getId());
            idea.setcreadoPor(user.getPrimerNombre() +"."+ user.getPrimerApellido());
            int p = privateIdea ? 1 : 0;
            idea.setideaPrivada(p);
            idea.setidEstadoidea(Constants.ESTADO_REGISTRADA);
            idea.settitulo(titulo);
            idea.setdescripcion(descripcion);
            idea.setpalabrasClaves(palabrasClaves);
          
            /*
                llenar el objeto idea con los valores de la pantalla 
            */
            boolean ok = ideaService.createIdea(idea);
            if (ok) {
                super.showMessage(FacesMessage.SEVERITY_INFO, "Idea creada con éxito");
                super.redirect("listofideas.xhtml");
            } else{
                super.showMessage(FacesMessage.SEVERITY_ERROR, "Error creando Idea");
            }
        } catch (Exception e) {
            Logger.getLogger(IdeaNewBean.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            super.showMessage(FacesMessage.SEVERITY_FATAL, e.toString());
        }

    }

}
