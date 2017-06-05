/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import edu.uniajc.ideaBank.interfaces.model.User;
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
    
        User userModel;

private Connection DBConnection = null;

    public LoginDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }
    
     public User getPasswordByUser(String username, String pass) {
        PreparedStatement prepStm = null;
        User user = null;
        final String SQL = "SELECT * FROM TB_USUARIO WHERE USUARIO=? AND CONTRASENA=?";

        try {
            prepStm = DBConnection.prepareStatement(SQL);
            prepStm.setString(1, username);
            prepStm.setString(2, pass);
            ResultSet rs = prepStm.executeQuery();
            if (rs.next()) {
                user = new User();

                user.setId( rs.getInt("ID") );                
                user.setIdTipoUsuario( rs.getInt("ID_T_LV_TIPOUSUARIO"));                
                user.setIdEstadoUsuario(rs.getInt("ID_T_LV_ESTADOUSUARIO"));                                
                user.setIdTipoIdentificacion(rs.getInt("ID_T_LV_TIPOIDENTIFICACION"));                                
                user.setNumIdentificacion(rs.getString("NUMIDENTIFICACION"));                                                
                user.setPrimerNombre(rs.getString("PRIMERNOMBRE"));
                user.setSegundoNombre(rs.getString("SEGUNDONOMBRE"));                                                
                user.setPrimerApellido( rs.getString("PRIMERAPELLIDO"));
                user.setSegundoApellido(rs.getString("SEGUNDOAPELLIDO"));                
                user.setTelefonoFijo(rs.getString("TELEFONOFIJO"));                
                user.setTelefonoCelular(rs.getString("TELEFONOCELULAR"));                                
                user.setUsuario(username);
                user.setContrasena(pass);
                user.setCreadoPor(rs.getString("CREADOPOR"));                                                                                                
                user.setCreadoEn( rs.getDate("CREADOEN"));
                user.setModificadoPor(rs.getString("MODIFICADOPOR"));                
                user.setModificadoEn(rs.getDate("MODIFICADOEN"));                                
                user.setGenero(rs.getString("GENERO"));
                user.setFechaNacimiento(rs.getDate("FECHANACIMIENTO"));                             
                user.setIdProgrmaAcademico(rs.getInt("ID_T_LV_PROGRAMAACADEMICO"));                                                
                user.setIdDependencia(rs.getInt("ID_T_LV_DEPENDENCIA"));                                                                


                }
            
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return user;
    }    
}
                  
    

