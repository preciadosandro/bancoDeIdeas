/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.DAO.LoginDAO;
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
    boolean validatorUser, validatorPassword;
    User userModel;

    public LoginService() throws NamingException, SQLException {
        this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
    }

    @Override
    public boolean newLogin(String user,String pass) {
        UserDAO dao = new UserDAO(dbConnection);
        LoginDAO daoPass=new LoginDAO(dbConnection);
        validatorUser = dao.getUserByUser(user);   
        validatorPassword=daoPass.getPasswordByUser(user,pass);
        if (validatorPassword==true) {
            return true;
        }else{
            return false;      
        }
    }
}