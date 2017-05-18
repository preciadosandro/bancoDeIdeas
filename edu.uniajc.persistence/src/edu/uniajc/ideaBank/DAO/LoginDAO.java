/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 *
 * @author Hector
 */
public class LoginDAO {

private Connection DBConnection = null;

    public LoginDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }
    
      public boolean getPasswordByUser(String user) {
        PreparedStatement prepStm = null;
        final String SQL = "SELECT CONTRASENA FROM TB_USUARIO WHERE USUARIO =?";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            prepStm.setString(1, user);
            ResultSet RS = prepStm.executeQuery();
            
            if (RS.next()) {
                if (RS.getString("CONTRASENA").equals("")) {
                    return false;
                } else {
                    return true;
                }
            }else{
                return false;
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, SQL, ex);
            return false;
        }
    }
                  
    
}
