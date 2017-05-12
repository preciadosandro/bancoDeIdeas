/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;
import edu.uniajc.ideaBank.DAO.TokenDAO;
import edu.uniajc.ideaBank.interfaces.IToken;
import edu.uniajc.ideaBank.interfaces.model.Token;
import java.sql.Connection;
import java.sql.SQLException;
import javax.ejb.Stateless;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;


/**
 *
 * @author Felipe
 */
@Stateless
public class TokenServices implements IToken{
    
    Connection dbConnection=null;
    
    @Override
    public Token createToken(String usuario,String token, int estado){
        try{
            dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
            TokenDAO dao = new TokenDAO(dbConnection);
            Token tokenModel = dao.createToken(usuario, token, estado);
            return tokenModel;
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
    public boolean getTokenByUserAndToken(String User, String token) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    
}
