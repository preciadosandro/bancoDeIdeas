/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.DAO;

import edu.uniajc.security.interfaces.model.Token;
import edu.uniajc.ideaBank.interfaces.model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
    
    public boolean updateToken(String usuario,String token){
        try {
            PreparedStatement ps = null;
            String SQL = "UPDATE TB_TOKEN SET ESTADO=0 WHERE TOKEN=?"+
                         " AND USUARIO=? AND ESTADO=1";
                  
            ps = this.DBConnection.prepareStatement(SQL);            
            ps.setString(1, token);
            ps.setString(2, usuario);            
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(TokenDAO.class.getName()).log(Level.SEVERE, null, e);
            System.out.println("Error actualizando token: "+e);
            return false;
        }        
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
            System.out.println("Error insertando token: "+e);
            return false;
        }
    }
    
    public User getUserByToken(String token){
        User userModel = new User();            
        try {
            String SQL = "SELECT U.* FROM TB_TOKEN T,TB_USUARIO U "+
                     " WHERE T.TOKEN=?"+
                     " AND T.CREADOEN >= SYSDATE - (1/24)"+
                     " AND U.USUARIO=T.USUARIO"+
                     " AND T.ESTADO=1";   
            PreparedStatement ps;
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setString(1,token);
        
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                userModel.setId(rs.getInt("ID"));
                userModel.setIdTipoUsuario(rs.getInt("ID_T_LV_TIPOUSUARIO"));
                userModel.setIdEstadoUsuario(rs.getInt("ID_T_LV_ESTADOUSUARIO"));
                userModel.setIdTipoIdentificacion(rs.getInt("ID_T_LV_TIPOIDENTIFICACION"));
                userModel.setNumIdentificacion(rs.getString("NUMIDENTIFICACION"));
                userModel.setPrimerNombre(rs.getString("PRIMERNOMBRE"));
                userModel.setSegundoNombre(rs.getString("SEGUNDONOMBRE"));
                userModel.setPrimerApellido(rs.getString("PRIMERAPELLIDO"));
                userModel.setSegundoApellido(rs.getString("SEGUNDOAPELLIDO"));
                userModel.setFechaNacimiento(rs.getDate("FECHANACIMIENTO"));
                userModel.setGenero(rs.getString("GENERO"));
                userModel.setTelefonoFijo(rs.getString("TELEFONOFIJO"));
                userModel.setTelefonoCelular(rs.getString("TELEFONOCELULAR"));
                userModel.setUsuario(rs.getString("USUARIO"));
                userModel.setContrasena(rs.getString("CONTRASENA"));
                userModel.setIdProgrmaAcademico(rs.getInt("ID_T_LV_PROGRAMAACADEMICO"));
                userModel.setIdDependencia(rs.getInt("ID_T_LV_DEPENDENCIA"));
                userModel.setCreadoPor(rs.getString("CREADOPOR"));
                userModel.setCreadoEn(rs.getDate("CREADOEN"));
                userModel.setModificadoPor(rs.getString("MODIFICADOPOR"));
                userModel.setModificadoEn(rs.getDate("MODIFICADOEN"));
            }
            return userModel;
        } catch (SQLException ex) {
            Logger.getLogger(TokenDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Error validando token vs usuario: "+ex);
        }
        return null;
    }
    
}
