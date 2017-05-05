/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.User;
import java.util.Date;
import javax.ejb.Remote;

/**
 *
 * @author bmorales
 */
@Remote
public interface IUser {
    public User createUser(int idTypeUser,int idStateUser, 
            int idTypeId,String numId,String firstName,
            String secondName,String lastName,String lastName2,
            String phone,String cellPhone,String user,
            String password, String gender, Date birthDate, int idAcadProgr, int idDepend);
    
    public boolean getUserByNumId(String numId);
    
    public boolean getUserByUser(String User);
    
}
