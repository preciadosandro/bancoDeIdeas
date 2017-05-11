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
    
    @Override
    public boolean createUser(User userModel) {
        try {
            dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
            UserDAO dao = new UserDAO(dbConnection);
            validatorUser = dao.getUserByUser(userModel.getUsuario());
            validatorNumId = dao.getUserById(userModel.getNumIdentificacion());
            if (validatorUser == false && validatorNumId == false) {
                userModel.setContrasena(Utilities.Encriptar(userModel.getContrasena()));
                userModel.setIdEstadoUsuario(1);
                return dao.createUser(userModel);
            } else {
                return false;
            }
        } catch (SQLException | NamingException e) {
            System.out.println(e.getMessage());
            return false;
        } finally {
            try {
                if (null != dbConnection) {
                    dbConnection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }
    }
}
