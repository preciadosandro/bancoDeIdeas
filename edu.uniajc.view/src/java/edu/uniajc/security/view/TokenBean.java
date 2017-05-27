/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;
import edu.uniajc.security.interfaces.IToken;
import static edu.uniajc.ideaBank.view.UserBean.getContext;
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
public class TokenBean implements Serializable {
    private String user;

    public TokenBean() {
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }
    
    public void forgotPass() throws UnknownHostException {
        FacesContext context = FacesContext.getCurrentInstance();

        // Se halla URL del servidor ==>> PROTOCOLO://SERVER:PORT
        // la cual se envía al generador de token para que envie el correo
        HttpServletRequest request = (HttpServletRequest)context.getExternalContext().getRequest();
        String urlServer = String.format( "%s://%s:%s", request.getScheme(),request.getServerName(), request.getServerPort() );
        System.out.println("URL DEL SERVIDOR : " + urlServer);

        IToken uToken =null;
        try {
            InitialContext ctx = getContext();
            uToken = (IToken) ctx.lookup("java:global/edu.uniajc.view/TokenService!edu.uniajc.security.interfaces.IToken");
        } catch (Exception e) {
            Logger.getLogger(TokenBean.class.getName()).log(Level.SEVERE, null, e);    
            context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                                    "Error con lookup.", ""));
        }
        if(uToken.validateUser(user.trim())){
            if (uToken.createToken(user.trim(), urlServer)){
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                                    "Correo enviado correctamente.", ""));
                user = " ";
            }else{
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
                            "Falló el envío de correo", ""));
            }            
        }else{
            context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_WARN,
                            "Usuario no existe.", ""));
        }
            
        
        
    }
    
    
    
}
