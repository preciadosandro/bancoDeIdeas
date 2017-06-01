/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;
import edu.uniajc.security.interfaces.IToken;
import static edu.uniajc.ideaBank.view.UserBean.getContext;
import java.io.IOException;
import java.io.Serializable;
import java.net.UnknownHostException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Felipe
 */
@ManagedBean(name = "TokenBean")
@ViewScoped
public class TokenBean extends ManagerBean{
    private String user;
    private final InitialContext ctx;

    public TokenBean() {
        super();
        ctx = super.getContext();
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }
    
    @SuppressWarnings("null")
    public void forgotPass() throws UnknownHostException, InterruptedException {
        FacesContext context = FacesContext.getCurrentInstance();
        // Se halla URL del servidor ==>> PROTOCOLO://SERVER:PORT
        // la cual se envía al generador de token para que envie el correo
        HttpServletRequest request = (HttpServletRequest)context.getExternalContext().getRequest();
        String urlServer = String.format( "%s://%s:%s", request.getScheme(),request.getServerName(), request.getServerPort() );
        System.out.println("URL DEL SERVIDOR : " + urlServer);        
        IToken uToken =null;
        try {            
            uToken = (IToken) ctx.lookup("java:global/edu.uniajc.view/TokenService!edu.uniajc.security.interfaces.IToken");
        } catch (Exception e) {
            Logger.getLogger(TokenBean.class.getName()).log(Level.SEVERE, null, e);  
            super.showMessage(FacesMessage.SEVERITY_WARN, "Error en lookup " + e);        
        }
        // Se valida si el usuario existe en la tabla de usuarios
        if(uToken.validateUser(this.user.trim())){
            // Se manda a crear el token
            if (uToken.createToken(this.user.trim(), urlServer)){                
                this.user = " ";               
                try {                
                    context.getExternalContext().redirect("../faces/confirmationToken.xhtml");
                } catch (IOException ex) {                        
                    Logger.getLogger(TokenBean.class.getName()).log(Level.SEVERE, null, ex);
                }            
            }else{
                super.showMessage(FacesMessage.SEVERITY_WARN, "Falló el envío de correo");               
            }            
        }else{
            super.showMessage(FacesMessage.SEVERITY_WARN, "Usuario no existe.");
        }
    }  
    
    public void confirmation() {
        FacesContext context = FacesContext.getCurrentInstance();
        try {
            context.getExternalContext().redirect("login.xhtml");
        } catch (Exception e) {
            Logger.getLogger(TokenBean.class.getName()).log(Level.SEVERE, null, e);
        }
    }
}
