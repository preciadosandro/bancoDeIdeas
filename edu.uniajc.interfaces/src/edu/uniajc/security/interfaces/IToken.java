/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.interfaces;

import edu.uniajc.ideaBank.interfaces.model.User;
import javax.ejb.Remote;
/**
 *
 * @author Felipe
 */
@Remote 
public interface IToken {
    public boolean createToken(String usuario, String urlServer);
    public boolean validateUser(String usuario);   
    public User getUserByToken(String token); 
    public boolean updateToken(String usuario,String token);
}
