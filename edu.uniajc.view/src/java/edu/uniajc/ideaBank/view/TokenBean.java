/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import static com.sun.faces.facelets.util.Path.context;
import edu.uniajc.ideaBank.Utilities.SendMail;
import java.io.Serializable;
import java.net.InetAddress;
import java.net.UnknownHostException;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;

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
        InetAddress address = InetAddress.getLocalHost();
        String hostname,mensaje;
        FacesContext context = FacesContext.getCurrentInstance();
        SendMail obj=new SendMail();        
        
        byte[] bIPAddress = address.getAddress();       
        String sIPAddress = "";
        for (int x=0; x<bIPAddress.length; x++) {
          if (x > 0) {            
            sIPAddress += ".";
          }          
          sIPAddress += bIPAddress[x] & 255;	   
        }
        //sacar puerto
        mensaje="<html>"
        +"<head>"
        +"<title>Restablece tu contraseña</title>"
        +"</head>"
        +"<body>"
        +"<p>Hemos recibido una petición para restablecer la contraseña de tu cuenta.</p>"
        +"<p>Si hiciste esta petición, haz clic en el siguiente enlace,"
        +" si no hiciste esta petición puedes ignorar este correo.</p>"
        +"<p>"
        +"<strong>Enlace para restablecer tu contraseña</strong><br>"        
        +"<a href='http://"+sIPAddress+":39865/ideaBank/LinkPaswd?TOKEN=123456633'"/* poner aqui el link de natalia*/
        +"target='_blank+'>Pulsa Aqui para recuperar tu contraseña</a>"
        +"</p>"
        +"</body>"        
        +"</html>";        
        obj.enviar_correo(this.getUser(),"IRIS - Solicitud cambio contraseña",mensaje);
        
        context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                                "Correo enviado correctamente.", ""));
    }
    
    
    
}
