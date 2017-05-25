/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import edu.uniajc.ideaBank.interfaces.model.Token;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Felipe
 */
public class TokenDAO {
    private Connection DBConnection = null;

    public TokenDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }
    
    public boolean createToken(String usuario,String token, int estado){
        try {
            Token tokenModel = new Token();            
            tokenModel.setUsuario(usuario);
            tokenModel.setToken(token);
            tokenModel.setEstado(estado);            

            PreparedStatement ps = null;
            String SQL;

            SQL = "INSERT INTO TB_TOKEN(ID,USUARIO,TOKEN,ESTADO) "
                  +"VALUES(SQ_TB_TOKEN.nextval,?,?,?)";
            ps = this.DBConnection.prepareStatement(SQL);            
            ps.setString(1, tokenModel.getUsuario());
            ps.setString(2, tokenModel.getToken());
            ps.setInt(3, tokenModel.getEstado());            
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(TokenDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }
    
}
