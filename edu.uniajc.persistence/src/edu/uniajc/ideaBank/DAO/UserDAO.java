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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Bladimir Morales
 */
public class UserDAO {

    private Connection DBConnection = null;

    public UserDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }

    public boolean createUser(User userModel) {

        try {
            PreparedStatement ps = null;
            String SQL;

            SQL = "INSERT INTO TB_USUARIO(ID,ID_T_LV_TIPOUSUARIO,ID_T_LV_ESTADOUSUARIO,"
                    + "ID_T_LV_TIPOIDENTIFICACION,NUMIDENTIFICACION,PRIMERNOMBRE,"
                    + "SEGUNDONOMBRE,PRIMERAPELLIDO,SEGUNDOAPELLIDO,TELEFONOFIJO,"
                    + "TELEFONOCELULAR,USUARIO,CONTRASENA,CREADOPOR, GENERO, ID_T_LV_DEPENDENCIA,"
                    + "ID_T_LV_PROGRAMAACADEMICO, FECHANACIMIENTO) "
                    + "VALUES(SQ_TB_USUARIO.nextval,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(1, userModel.getIdTipoUsuario());
            ps.setInt(2, userModel.getIdEstadoUsuario());
            ps.setInt(3, userModel.getIdTipoIdentificacion());
            ps.setString(4, userModel.getNumIdentificacion());
            ps.setString(5, userModel.getPrimerNombre());
            ps.setString(6, userModel.getSegundoNombre());
            ps.setString(7, userModel.getPrimerApellido());
            ps.setString(8, userModel.getSegundoApellido());
            ps.setString(9, userModel.getTelefonoFijo());
            ps.setString(10, userModel.getTelefonoCelular());
            ps.setString(11, userModel.getUsuario());
            ps.setString(12, userModel.getContrasena());
            ps.setString(13, userModel.getPrimerNombre() + " " + userModel.getPrimerApellido());
            java.sql.Date birtDate = new java.sql.Date(userModel.getFechaNacimiento().getTime());
            ps.setString(14, userModel.getGenero());
            ps.setInt(15, userModel.getIdDependencia());
            ps.setInt(16, userModel.getIdProgrmaAcademico());
            ps.setDate(17, birtDate);
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }

    }

    ;
    
    public boolean getUserByUser(String user) {
        PreparedStatement prepStm = null;
        final String SQL = "SELECT USUARIO FROM TB_USUARIO WHERE USUARIO =?";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            prepStm.setString(1, user);
            ResultSet RS = prepStm.executeQuery();
            if (RS.next()) {
                if (RS.getString("USUARIO").equals("")) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return false;
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, SQL, ex);
            return false;
        }
    }

    public boolean getUserById(String numId) {
        PreparedStatement prepStm = null;
        final String SQL = "SELECT USUARIO FROM TB_USUARIO WHERE NUMIDENTIFICACION =?";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            prepStm.setString(1, numId);
            ResultSet RS = prepStm.executeQuery();

            if (RS.next()) {
                if (RS.getString("USUARIO").equals("")) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return false;
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, SQL, ex);
            return false;
        }
    }

    public List<User> listUser() {
        List<User> itemFound = new ArrayList<User>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT ID,ID_T_LV_TIPOUSUARIO,ID_T_LV_ESTADOUSUARIO,"
                + "ID_T_LV_TIPOIDENTIFICACION,NUMIDENTIFICACION,PRIMERNOMBRE,"
                + "SEGUNDONOMBRE,PRIMERAPELLIDO,SEGUNDOAPELLIDO,TELEFONOFIJO,"
                + "TELEFONOCELULAR,USUARIO,CONTRASENA,CREADOPOR, GENERO, ID_T_LV_DEPENDENCIA,"
                + "ID_T_LV_PROGRAMAACEDEMICO, FECHANACIMIENTO "
                + "FROM TB_USUARIO ORDER BY 1";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                User uRow = new User();
                uRow.setId(RS.getInt("ID"));
                uRow.setIdTipoUsuario(RS.getInt("ID_T_LV_TIPOUSUARIO"));
                uRow.setIdEstadoUsuario(RS.getInt("ID_T_LV_ESTADOUSUARIO"));
                uRow.setIdTipoIdentificacion(RS.getInt("ID_T_LV_TIPOIDENTIFICACION"));
                uRow.setNumIdentificacion(RS.getString("NUMIDENTIFICACION"));
                uRow.setPrimerNombre(RS.getString("PRIMERNOMBRE"));
                uRow.setSegundoNombre(RS.getString("SEGUNDONOMBRE"));
                uRow.setPrimerApellido(RS.getString("PRIMERAPELLIDO"));
                uRow.setSegundoApellido(RS.getString("SEGUNDOAPELLIDO"));
                uRow.setTelefonoFijo(RS.getString("TELEFONOFIJO"));
                uRow.setTelefonoCelular(RS.getString("TELEFONOCELULAR"));
                uRow.setUsuario(RS.getString("USUARIO"));
                uRow.setGenero(RS.getString("GENERO"));
                uRow.setIdDependencia(RS.getInt("ID_T_LV_DEPENDENCIA"));
                uRow.setIdProgrmaAcademico(RS.getInt("ID_T_LV_PROGRAMAACEDEMICO"));
                uRow.setFechaNacimiento(RS.getDate("FECHANACIMIENTO"));
                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }

        return itemFound;
    }    
    
    public boolean updateUser(User userModel) {

        try {
            
            java.sql.Date birtDate = new java.sql.Date(userModel.getFechaNacimiento().getTime());
            Date date = new Date();
            PreparedStatement ps = null;
            String SQL;
            SQL = "UPDATE TB_USUARIO SET ID_T_LV_TIPOUSUARIO = ?, ID_T_LV_ESTADOUSUARIO = ?,"
                    + "ID_T_LV_TIPOIDENTIFICACION = ?, NUMIDENTIFICACION = ?, PRIMERNOMBRE = ?,"
                    + "SEGUNDONOMBRE = ?, PRIMERAPELLIDO = ?, SEGUNDOAPELLIDO = ?, TELEFONOFIJO = ?,"
                    + " FECHANACIMIENTO = ?,TELEFONOCELULAR = ?,"
                    + "GENERO = ?,  ID_T_LV_PROGRAMAACEDEMICO = ?,"
                    + "ID_T_LV_DEPENDENCIA = ?, MODIFICADOPOR = ?,"
                    + "MODIFICADOEN = ? WHERE ID = ?";
            ps = this.DBConnection.prepareStatement(SQL);
            //ps.setInt(1, id);
            ps.setInt(1, userModel.getIdTipoUsuario());
            ps.setInt(2, userModel.getIdEstadoUsuario());
            ps.setInt(3, userModel.getIdTipoIdentificacion());
            ps.setString(4, userModel.getNumIdentificacion());
            ps.setString(5, userModel.getPrimerNombre());
            ps.setString(6, userModel.getSegundoNombre());
            ps.setString(7, userModel.getPrimerApellido());
            ps.setString(8, userModel.getSegundoApellido());
            ps.setString(9, userModel.getTelefonoFijo());
            ps.setDate(10, birtDate);
            ps.setString(11, userModel.getTelefonoCelular());
            ps.setString(12, userModel.getGenero());
            ps.setInt(13, userModel.getIdProgrmaAcademico());
            ps.setInt(14, userModel.getIdDependencia());            
            ps.setString(15, userModel.getPrimerNombre() + " " + userModel.getPrimerApellido());  
            ps.setDate(16, birtDate);
            ps.setInt(17, userModel.getId());
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }

    }
    
    public boolean newPassword(User user) {
        try {
            PreparedStatement ps = null;
            String SQL = "UPDATE TB_USUARIO SET TB_Usuario = ?  WHERE ID = ?";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setString(1, user.getContrasena());
            ps.setInt(2, user.getId());
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }

    }
    
    
}
