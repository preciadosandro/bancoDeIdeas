/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.User;
import java.util.ArrayList;
import java.util.Date;
import javax.ejb.Remote;

/**
 *
 * @author bmorales
 */
@Remote
public interface IUser {
    public User createUser(int idTypeUser,int idStateUser, 
            int idTypeId,int numId,String firstName,
            String secondName,String lastName,String lastName2,
            String phone,String cellPhone,String user,
            String password);
    
    public boolean getUserByNumId(int numId);
    
    public boolean getUserByUser(String User);
    
}
