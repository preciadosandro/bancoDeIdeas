/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;



import edu.uniajc.ideaBank.interfaces.ILogin;
import edu.uniajc.ideaBank.interfaces.model.User;
import static edu.uniajc.ideaBank.view.UserBean.getContext;
import java.io.Serializable;
import javax.faces.bean.ViewScoped;
import javax.faces.bean.ManagedBean;
import javax.faces.context.FacesContext;
import javax.naming.InitialContext;

/**
 *
 * @author Hector-laptop
 */

@ManagedBean(name = "loginBean")
@ViewScoped
public class LoginBean implements Serializable {

    private String password;
    private String user;
    
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


    


    public LoginBean(){}   
    
    

    
    
    
    public void newLogin() {  
        ILogin lDao =null;
        int validator;
        FacesContext context = FacesContext.getCurrentInstance();
        
       try {
            InitialContext ctx = getContext();
            lDao = (ILogin) ctx.lookup("java:global/edu.uniajc.view/LoginService!edu.uniajc.ideaBank.interfaces.ILogin");
        } catch (Exception e) {
        }        

       if(user!=null){
            validator = lDao.newLogin(this.user);
                if(validator!=0){
                    
                }else{
                    linklogin();
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
   } 

    
    
      


 
