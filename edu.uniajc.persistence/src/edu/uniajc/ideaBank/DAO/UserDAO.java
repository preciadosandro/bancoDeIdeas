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
 * @author bmorales
 */
public class UserDAO {

    private Connection DBConnection = null;

    public UserDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }

    public User createUser(int idTypeUser, int idStateUser,
            int idTypeId, int numId, String firstName,
            String secondName, String lastName, String lastName2,
            String phone, String cellPhone, String user,
            String password, String createBy, Date createDate) {

        try {
            User userModel = new User();
            userModel.setIdTipoUsuario(idTypeUser);
            userModel.setIdEstadoUsuario(idStateUser);
            userModel.setIdTipoIdentificacion(idTypeId);
            userModel.setNumIdentificacion(numId);
            userModel.setPrimerNombre(firstName);
            userModel.setSegundoNombre(secondName);
            userModel.setPrimerApellido(lastName);
            userModel.setSegundoApellido(lastName2);
            userModel.setTelefonoFijo(phone);
            userModel.setTelefonoCelular(cellPhone);
            userModel.setUsuario(user);
            userModel.setContrasena(password);
            userModel.setCreadoPor(createBy);
            userModel.setCreadoEn(createDate);

            PreparedStatement ps = null;
            String SQL;

            SQL = "INSERT INTO TB_USUARIO(ID_T_LV_TIPOUSUARIO,ID_T_LV_ESTADOUSUARIO,"
                    + "ID_T_LV_TIPOIDENTIFICACION,NUMIDENTIFICACION,PRIMERNOMBRE,"
                    + "SEGUNDONOMBRE,PRIMERAPELLIDO,SEGUNDOAPELLIDO,TELEFONOFIJO,"
                    + "TELEFONOCELULAR,USUARIO,CONTRASENA,CREADOPOR,CREADOEN) "
                    + "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(1, userModel.getIdTipoUsuario());
            ps.setInt(2, userModel.getIdEstadoUsuario());
            ps.setInt(3, userModel.getIdTipoIdentificacion());
            ps.setInt(4, userModel.getNumIdentificacion());
            ps.setString(5, userModel.getPrimerNombre());
            ps.setString(6, userModel.getSegundoNombre());
            ps.setString(7, userModel.getPrimerApellido());
            ps.setString(8, userModel.getSegundoApellido());
            ps.setString(9, userModel.getTelefonoFijo());
            ps.setString(10, userModel.getTelefonoCelular());
            ps.setString(11, userModel.getUsuario());
            ps.setString(12, userModel.getContrasena());
            ps.setString(13, userModel.getCreadoPor());
            java.sql.Date sqlStartDate = new java.sql.Date(userModel.getCreadoEn().getDate());
            ps.setDate(14, sqlStartDate);
            ps.execute();
            return userModel;

        } catch (Exception e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
            return null;
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
            }else{
                return false;
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, SQL, ex);
            return false;
        }
    }

    public boolean getUserById(int numId) {
        PreparedStatement prepStm = null;
        final String SQL = "SELECT USUARIO FROM TB_USUARIO WHERE NUMIDENTIFICACION =?";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            prepStm.setInt(1, numId);
            ResultSet RS = prepStm.executeQuery();
            
            if (RS.next()) {
                if (RS.getString("USUARIO").equals("")) {
                    return false;
                } else {
                    return true;
                }
            }else{
                return false;
            }

        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, SQL, ex);
            return false;
        }
    }
}
