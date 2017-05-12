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
import java.util.Date;
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

            SQL = "INSERT INTO TB_USUARIO(ID_T_LV_TIPOUSUARIO,ID_T_LV_ESTADOUSUARIO,"
                    + "ID_T_LV_TIPOIDENTIFICACION,NUMIDENTIFICACION,PRIMERNOMBRE,"
                    + "SEGUNDONOMBRE,PRIMERAPELLIDO,SEGUNDOAPELLIDO,TELEFONOFIJO,"
                    + "TELEFONOCELULAR,USUARIO,CONTRASENA,CREADOPOR,CREADOEN, GENERO, ID_T_LV_DEPENDENCIA,"
                    + "ID_T_LV_PROGRAMAACEDEMICO, FECHANACIMIENTO) "
                    + "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
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
            ps.setDate(14, birtDate);
            ps.setString(15, userModel.getGenero());
            ps.setInt(16, userModel.getIdDependencia());
            ps.setInt(17, userModel.getIdProgrmaAcademico());
            ps.setDate(18, birtDate);
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
}
