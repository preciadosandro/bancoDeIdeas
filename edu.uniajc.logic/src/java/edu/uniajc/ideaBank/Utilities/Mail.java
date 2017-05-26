/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.Utilities;

import java.io.File;
import java.util.Arrays;
import java.util.Properties;
import javax.activation.*;
import javax.mail.*;
import javax.mail.internet.*;
/**
 *
 * @author Felipe
 */
public class Mail {
    private String subject = null;
    protected String usuario = null;
    protected String password = null;
    private String html = null;
    private File[] archivos = null;
    private boolean insistente = true;
    private String replyTo = null;
    private String bcc = null;
    
    protected String servidor = "smtp.gmail.com";
    protected int port = 465;
    private int intentosMaximos = 1;
    
    public Mail() {
        
    }
    
    public Mail(String usuario, String password) {
        this.usuario = usuario;
        this.password = password;
    }
    
    public void setHost(String servidor) {
        this.servidor = servidor;
    }
    
    public void setPort(int port) {
        this.port = port;
    }
    
    public void setIntentosMaximos(int numero) {
        this.intentosMaximos = numero;
    }
    
    public void setSubject(String subject){
        this.subject = subject;
    }
    
    public void setHtml(String html){
        this.html = html;
    }
    
    public void addArchivo(File archivo){
        if(archivos == null)archivos = new File[0];
        archivos = Arrays.copyOf(archivos, archivos.length + 1);
        archivos[archivos.length - 1] = archivo;
    }
    
    public void setInsistente(boolean insistente) {
        this.insistente = insistente;
    }
    
    public void setReplyTo(String replyTo) {
        if (replyTo == null) {
            return;
        }
        if (replyTo.trim().replace(",", "").isEmpty()) {
            return;
        }
        this.replyTo = replyTo;
    }
    
    public void setBcc(String bcc) {
        if (bcc == null) {
            return;
        }
        if (bcc.trim().replace(",", "").isEmpty()) {
            return;
        }
        this.bcc = bcc;
    }
    
    public boolean mail(String para) {
        
        if (para == null && bcc == null) {
            return false;
        }
        
        para = para.trim();
        para = para.replace(" ", "");
        
        if (para.replace(",", "").trim().isEmpty() && bcc == null) {
            return false;
        }
            
        Properties props = new Properties();
        props.put("mail.smtp.host", servidor);
        props.put("mail.smtp.socketFactory.port", port);
        props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", port);
        Session session = Session.getInstance(props,
          new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(usuario, password);
                }
          });
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(usuario));
            if (bcc != null) {
                message.setRecipients(Message.RecipientType.BCC,
                        InternetAddress.parse(bcc));
            }
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(para));
            message.setSubject(subject);
            if (replyTo != null) {
                message.setReplyTo(new javax.mail.Address[] {
                    new javax.mail.internet.InternetAddress(replyTo)
                });
            }
            Multipart parts = new MimeMultipart();
            
            if (html != null) {
                BodyPart body = new MimeBodyPart();
                body.setContent(html, "text/html");
                parts.addBodyPart(body);
            }
            
            if (archivos != null) {
                for (int i = 0; i < archivos.length; i++) {
                    BodyPart body = new MimeBodyPart();
                    DataSource source = new FileDataSource(archivos[i]);
                    body.setDataHandler(new DataHandler(source));
                    body.setFileName(archivos[i].getName());
                    parts.addBodyPart(body);
                }
            }
            
            message.setContent(parts);
            boolean envio = false;
            int intentos = 0;
            
            //do {
                try {
                    Transport.send(message);
                    envio = true;
                 //   break;
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("Error enviando mensaje para " + para + ", error: " + e.getMessage());
                   // System.out.println("Esperando 5 segundos para intentar de nuevo");
                }
              //  Thread.sleep(5000);
               // intentos++;
            //} while (!envio && insistente && (intentos < intentosMaximos));
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    } 
}
