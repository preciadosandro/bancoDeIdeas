/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.Utilities;

import java.io.File;
/**
 *
 * @author Felipe
 */
public class SendMail {
    public void enviar_correo(String correo,String asunto,String mensaje){        
        Mail mail = new Mail("ideabank.uniajc@gmail.com", "1d34b4nk");       
        mail.setSubject(asunto);        
        mail.setHtml(mensaje);              
        mail.mail(correo); 
    }
}
