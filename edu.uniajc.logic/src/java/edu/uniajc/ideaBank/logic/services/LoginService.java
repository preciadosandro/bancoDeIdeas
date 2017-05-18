/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.DAO.UserDAO;
import edu.uniajc.ideaBank.interfaces.ILogin;
import edu.uniajc.ideaBank.interfaces.model.User;
import java.sql.Connection;
import java.sql.SQLException;
import javax.ejb.Stateless;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;


/**
 *
 * @author Hector
 */
@Stateless
public class LoginService implements ILogin {

    Connection dbConnection;
    boolean validatorUser, validatorNumId;
    User userModel;

    public LoginService() throws NamingException, SQLException {
        this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
    }

    @Override
    public int newLogin(String user) {
        UserDAO dao = new UserDAO(dbConnection);
        boolean confirmUser;
        validatorUser = dao.getUserByUser(user);        
        if (validatorUser == true) {
            return -3;
        }else{
            return 1;
            /*if (validatorNumId == true) {
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
        */}
    }
}