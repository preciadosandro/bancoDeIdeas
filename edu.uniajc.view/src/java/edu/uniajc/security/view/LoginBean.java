/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;



import edu.uniajc.ideaBank.Utilities.Utilities;
import edu.uniajc.ideaBank.interfaces.ILogin;
import edu.uniajc.ideaBank.interfaces.model.User;
import static edu.uniajc.ideaBank.view.UserBean.getContext;
import edu.uniajc.security.view.ManagerBean;
import java.io.Serializable;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ViewScoped;
import javax.faces.bean.ManagedBean;
import javax.faces.context.FacesContext;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

/**
 *
 * @author Hector-laptop
 */

@ManagedBean(name = "loginBean")
@ViewScoped
public class LoginBean extends ManagerBean {

    private String password;
    private String user;
    private boolean cookiesCheck=false;
    private String virtualCheck;
    

    public String getVirtualCheck() {
        return virtualCheck;
    }
    public void setVirtualCheck(String virtualCheck) {
        this.virtualCheck = virtualCheck;
    }
    public boolean isCookiesCheck() {
        return cookiesCheck;
    }
    public void setCookiesCheck(boolean cookiesCheck) {
        this.cookiesCheck = cookiesCheck;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getUser() {
        return user;
    }
    public void setUser(String user) {
        this.user = user;
    }

    
    
    public LoginBean (){  
        super();
        InitialContext ctx = super.getContext();
        isChecked();
    }   
       
    
    
    
    
    public void newLogin() {  

        String temp=Utilities.Encriptar(this.password);
        ILogin lDao =null;
        User validator;
        FacesContext context = FacesContext.getCurrentInstance();
        
       try {
            InitialContext ctx = getContext();
            lDao = (ILogin) ctx.lookup("java:global/edu.uniajc.view/LoginService!edu.uniajc.ideaBank.interfaces.ILogin");
        } catch (Exception e) {
        }        

       if(user!=null){
           String password=Utilities.Encriptar(this.password);
           
            validator = lDao.newLogin(this.user, password);
                if( validator!=null && validator.getId()>0 ){

                    if(cookiesCheck == true) {
                    virtualCheck = "true";
                    Cookie cUserId = new Cookie("cUserId", user);
                    Cookie cPassword = new Cookie("cPassword", password);
                    Cookie cVirtualCheck = new Cookie("cVirtualCheck", virtualCheck);
                    cUserId.setMaxAge(3600);
                    cPassword.setMaxAge(3600);
                    cVirtualCheck.setMaxAge(3600);
                    ((HttpServletResponse)(context.getExternalContext().getResponse())).addCookie(cUserId);
                    ((HttpServletResponse)(context.getExternalContext().getResponse())).addCookie(cPassword);
                    ((HttpServletResponse)(context.getExternalContext().getResponse())).addCookie(cVirtualCheck);            
                    // se llama clase que coloca user en session
                    super.addToSession(Constants.SESSION_KEY_USER, validator);   
                    User xxx = (User) super.getFromSession(Constants.SESSION_KEY_USER);
                    System.out.println("XXXX "+xxx.getUsuario());    
                    super.redirect("managerUser.xhtml");


                    } else {
                        virtualCheck = "false";
                        Cookie cVirtualCheck = new Cookie("cVirtualCheck", virtualCheck);
                        ((HttpServletResponse)(context.getExternalContext().getResponse())).addCookie(cVirtualCheck);
                        super.addToSession(Constants.SESSION_KEY_USER, validator);   
                        User xxx = (User) super.getFromSession(Constants.SESSION_KEY_USER);
                        System.out.println("zzzzz "+xxx.getUsuario());                          
                        super.redirect("listofideas.xhtml");          
                    }
                                                            
                }else{
                    context.addMessage(null, new FacesMessage("Su intento para conectarse no tuvo éxito. Causa: Usuario o Contraseña inválido, por favor revise los datos ingresados"));
                }
            }
       }
    
    
    public void isChecked() {
        FacesContext fc = FacesContext.getCurrentInstance();
        Cookie[] cookiesArr = ((HttpServletRequest)(fc.getExternalContext().getRequest())).getCookies();
        if(cookiesArr != null && cookiesArr.length > 0)
            for(int i =0; i < cookiesArr.length; i++) {
                String cName = cookiesArr[i].getName();
                String cValue= cookiesArr[i].getValue();
                System.out.println("***cValue***"+cValue);
                if(cName.equals("cUserId")) {
                    setUser(cValue);
                } else if(cName.equals("cPassword")) {
                    setPassword(cValue);
                } else if(cName.equals("cVirtualCheck")) {
                    setVirtualCheck(cValue);
                    if(getVirtualCheck().equals("false")) {
                        setCookiesCheck(false);
                        setUser(null);
                        setPassword(null);
                    } else if(getVirtualCheck().equals("true")) {
                        System.out.println("Here in doLogin() line 99");
                        setCookiesCheck(true);
                    }
                }
            }
    }
    
    
    
    
    public String doRemenber() {
        FacesContext fc = FacesContext.getCurrentInstance();
                return "success";
    }
    
        /*public static InitialContext getContext() {
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
    }*/
    
    
    
 
    
    
    
    
    
     
    
    
    
    
   } 

    
    
      


 
