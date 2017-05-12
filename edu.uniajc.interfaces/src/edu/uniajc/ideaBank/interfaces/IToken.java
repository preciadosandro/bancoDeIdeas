/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.Token;
import javax.ejb.Remote;

/**
 *
 * @author Felipe
 */
@Remote 
public interface IToken {
    public Token createToken(String usuario,String token,int estado);     
    public boolean getTokenByUserAndToken(String User,String token);
    
}
