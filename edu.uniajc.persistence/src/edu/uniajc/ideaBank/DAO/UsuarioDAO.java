/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import edu.uniajc.ideaBank.interfaces.model.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author bmorales
 */
public class UsuarioDAO {
    private Connection DBConnection = null;

    public UsuarioDAO(Connection openConnection) {
        this.DBConnection = openConnection; 
    }
    
    public Usuario createUser(int idTipoUsuario, int idEstadoUsuario, int idTipoIdentificacion, 
            int numIdentificacion, String primerNombre, String segundoNombre, 
            String primerApellido, String segundoApellido, String telefonoFijo, 
            String telefonoCelular, String usuario, String contrasena, 
            String creadoPor, Date creadoEn){
        
        try {
            Usuario user = new Usuario();
            user.setIdTipoUsuario(idTipoUsuario);
            user.setIdEstadoUsuario(idEstadoUsuario);
            user.setIdTipoIdentificacion(idTipoIdentificacion);
            user.setNumIdentificacion(numIdentificacion);
            user.setPrimerNombre(primerNombre);
            user.setSegundoNombre(segundoNombre);
            user.setPrimerApellido(primerApellido);
            user.setSegundoApellido(segundoApellido);
            user.setTelefonoFijo(telefonoFijo);
            user.setTelefonoCelular(telefonoCelular);
            user.setUsuario(usuario);
            user.setContrasena(contrasena);
            user.setCreadoPor(creadoPor);
            user.setCreadoEn(creadoEn);
            
            PreparedStatement ps = null;
            
            String SQL = "select SQ_TB_USUARIO.nextval ID from dual";
            ps = this.DBConnection.prepareStatement(SQL);
            ResultSet rs = ps.executeQuery();
            int id = rs.getInt("ID");
            
            SQL = "INSERT INTO TB_USUARIO(ID,ID_T_LV_TIPOUSUARIO,ID_T_LV_ESTADOUSUARIO,"
                    + "ID_T_LV_TIPOIDENTIFICACION,NUMIDENTIFICACION,PRIMERNOMBRE,"
                    + "SEGUNDONOMBRE,PRIMERAPELLIDO,SEGUNDOAPELLIDO,TELEFONOFIJO,"
                    + "TELEFONOCELULAR,USUARIO,CONTRASENA,CREADOPOR,CREADOEN) "
                    + "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(1, id);
            ps.setInt(2, user.getIdTipoUsuario());
            ps.setInt(3, user.getIdEstadoUsuario());
            ps.setInt(4, user.getIdTipoIdentificacion());
            ps.setInt(5, user.getNumIdentificacion());
            ps.setString(6, user.getPrimerNombre());
            ps.setString(7, user.getSegundoNombre());
            ps.setString(8, user.getPrimerApellido());
            ps.setString(9, user.getSegundoApellido());
            ps.setString(10,user.getTelefonoFijo());
            ps.setString(11,user.getTelefonoCelular());
            ps.setString(12,user.getUsuario());
            ps.setString(13,user.getContrasena());
            ps.setString(14,user.getCreadoPor());
            ps.setDate(15, (java.sql.Date) user.getCreadoEn());
            ps.execute();
            
            user.setId(id);
            return user;
            
        } catch (Exception e) {
            Logger.getLogger(UsuarioDAO.class.getName()).log(Level.SEVERE, null, e);
            return null;
        }
        
    };
}
