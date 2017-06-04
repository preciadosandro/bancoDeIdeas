/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces.model;

import java.io.Serializable;

/**
 *
 * @author Hector
 */
public class Login implements Serializable {

    private boolean typeProject;      
    private String password;
    private String user;

    public boolean isTypeProject() {
        return typeProject;
    }
    public void setTypeProject(boolean typeProject) {
        this.typeProject = typeProject;
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
}
