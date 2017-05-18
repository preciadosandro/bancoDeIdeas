/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.Utilities.Utilities;
import edu.uniajc.ideaBank.DAO.UserDAO;
import edu.uniajc.ideaBank.interfaces.model.User;
import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import edu.uniajc.ideaBank.interfaces.IUser;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.Stateless;

/**
 *
 * @author Bladimir Morales
 */
@Stateless
public class UserService implements IUser {

    Connection dbConnection;
    boolean validatorUser, validatorNumId;
    User userModel;

    public UserService() {
        try {
            this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
        } catch (NamingException | SQLException e) {
            Logger.getLogger(UserService.class.getName()).log(Level.SEVERE, null, e);
        }
        
    }

    @Override
    public int createUser(User userModel) {
        UserDAO dao = new UserDAO(dbConnection);
        boolean confirmUser;
        validatorUser = dao.getUserByUser(userModel.getUsuario());
        validatorNumId = dao.getUserById(userModel.getNumIdentificacion());
        if (validatorUser == false) {
            if (validatorNumId == false) {
                userModel.setContrasena(Utilities.Encriptar(userModel.getContrasena()));
                userModel.setIdEstadoUsuario(1);
                confirmUser = dao.createUser(userModel);
                if (confirmUser == true) {
                    return 0;
                } else {
                    return -1;
                }
            }else{
                return -2;
            }
        }else{
            return -3;
        }
    }
}
