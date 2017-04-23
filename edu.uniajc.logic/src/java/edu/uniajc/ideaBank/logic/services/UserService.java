/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;
//
import edu.uniajc.ideaBank.DAO.UserDAO;
import edu.uniajc.ideaBank.interfaces.model.User;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import edu.uniajc.ideaBank.interfaces.IUser;
import javax.ejb.Stateless;

/**
 *
 * @author bmorales
 */
@Stateless
public class UserService implements IUser {

    Connection dbConnection=null;
            
    @Override
    public User createUser(int idTypeUser, int idStateUser,
            int idTypeId, int numId, String firstName,
            String secondName, String lastName, String lastName2,
            String phone, String cellPhone, String user,
            String password) {
        try {
            dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
            UserDAO dao = new UserDAO(dbConnection);
            Date date = new Date();
            String createBy = firstName + " " + lastName;

            User userModel = dao.createUser(idTypeUser, idStateUser, idTypeId,
                    numId, firstName, secondName, lastName,
                    lastName2, phone, cellPhone, user,
                    password, createBy, date);
            return userModel;

        } catch (SQLException | NamingException e) {
            System.out.println(e.getMessage());
            return null;
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

    @Override
    public boolean getUserByUser(String User
    ) {
        boolean validator;
        try {
            dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
            UserDAO dao = new UserDAO(dbConnection);
            validator = dao.getUserByUser(User);
            return validator;
        } catch (SQLException | NamingException e) {
            System.out.println(e.getMessage());
            return false;
        }finally {
            try {
                if (null != dbConnection) {
                    dbConnection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }

    }

    @Override
    public boolean getUserByNumId(int numId) {
        boolean validator;
        try {
            dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
            UserDAO dao = new UserDAO(dbConnection);
            validator = dao.getUserById(numId);
            return validator;
        } catch (SQLException | NamingException e) {
            System.out.println(e.getMessage());
            return false;
        }finally {
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
