/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Hector
 */
@ManagedBean(name = "logPruebaBean")
@ViewScoped
public class logPruebaBean {

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isCheckBox() {
        return checkBox;
    }

    public void setCheckBox(boolean checkBox) {
        this.checkBox = checkBox;
    }

    public String getVirtualCheck() {
        return virtualCheck;
    }

    public void setVirtualCheck(String virtualCheck) {
        this.virtualCheck = virtualCheck;
    }
    
    
    private String userId;
private String password;
private boolean checkBox = false;
private String virtualCheck;

    // Setter and getter

    public logPruebaBean() {
    isChecked();
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
                setUserId(cValue);
            } else if(cName.equals("cPassword")) {
                setPassword(cValue);
            } else if(cName.equals("cVirtualCheck")) {
                setVirtualCheck(cValue);
                if(getVirtualCheck().equals("false")) {
                    setCheckBox(false);
                    setUserId(null);
                    setPassword(null);
                } else if(getVirtualCheck().equals("true")) {
                    System.out.println("Here in doLogin() line 99");
                    setCheckBox(true);
                }
            }
        }

}

    public String doLogin() {
        if(userId != null && password!= null){
        FacesContext fc = FacesContext.getCurrentInstance();
        if(checkBox == true) {
            virtualCheck = "true";
            Cookie cUserId = new Cookie("cUserId", userId);
            Cookie cPassword = new Cookie("cPassword", password);
            Cookie cVirtualCheck = new Cookie("cVirtualCheck", virtualCheck);
            cUserId.setMaxAge(3600);
            cPassword.setMaxAge(3600);
            cVirtualCheck.setMaxAge(3600);
            ((HttpServletResponse)(fc.getExternalContext().getResponse())).addCookie(cUserId);
            ((HttpServletResponse)(fc.getExternalContext().getResponse())).addCookie(cPassword);
            ((HttpServletResponse)(fc.getExternalContext().getResponse())).addCookie(cVirtualCheck);
        } else {
            virtualCheck = "false";
            Cookie cVirtualCheck = new Cookie("cVirtualCheck", virtualCheck);
            ((HttpServletResponse)(fc.getExternalContext().getResponse())).addCookie(cVirtualCheck);
        }
                return "success";
    }
        return null;
    
}
}
