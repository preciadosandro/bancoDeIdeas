/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;



import edu.uniajc.ideaBank.interfaces.ILogin;
import static edu.uniajc.ideaBank.view.UserBean.getContext;
import java.io.Serializable;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ViewScoped;
import javax.faces.bean.ManagedBean;
import javax.faces.context.FacesContext;
import javax.naming.InitialContext;
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
public class LoginBean implements Serializable {

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

    public LoginBean(){  
        isChecked();
    }   
       
    public void newLogin() {  
        ILogin lDao =null;
        boolean validator;
        FacesContext context = FacesContext.getCurrentInstance();
        
       try {
            InitialContext ctx = getContext();
            lDao = (ILogin) ctx.lookup("java:global/edu.uniajc.view/LoginService!edu.uniajc.ideaBank.interfaces.ILogin");
        } catch (Exception e) {
        }        

       if(user!=null){
            validator = lDao.newLogin(this.user, this.password);
                if(validator==true){

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
                    linklogin(); 

                    } else {
                        virtualCheck = "false";
                        Cookie cVirtualCheck = new Cookie("cVirtualCheck", virtualCheck);
                        ((HttpServletResponse)(context.getExternalContext().getResponse())).addCookie(cVirtualCheck);
                    linklogin();                 
                    }
                                                            
                }else{
                    context.addMessage(null, new FacesMessage("Usuario y/o Contraseña incorrecto!"));
                }
            }
       }
    
    public void linklogin() {
        FacesContext context = FacesContext.getCurrentInstance();
        try {
            context.getExternalContext().redirect("index.xhtml");
        } catch (Exception e) {
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
    
    
    
 
    
    
    
    
    
    
     
    
    
    
    
   } 

    
    
      


 
