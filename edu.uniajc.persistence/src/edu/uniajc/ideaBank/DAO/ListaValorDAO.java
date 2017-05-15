/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import edu.uniajc.ideaBank.interfaces.model.ListaValor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author rlara
 */
public class ListaValorDAO {

    private Connection DBConnection = null;

    public ListaValorDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }

    public boolean createListaValor(ListaValor listaValorModel) {

        try {
            PreparedStatement ps = null;
            String SQL;

            SQL = "INSERT INTO TB_ListaValor(ID, Agrupacion, Descripcion,"
                    + "CreadoPor) VALUES (SQ_TB_ListaValor.nextval, ?, ?, ?)";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setString(2, listaValorModel.getAgrupacion());
            ps.setString(3, listaValorModel.getDescripcion());
            ps.setString(4, listaValorModel.getCreadoPor());
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }

    ;
    
    public boolean getListaValorByAgrupacion(String Agrupacion) {
        PreparedStatement prepStm = null;
        final String SQL = "SELECT Descripcion FROM TB_ListaValor WHERE Agrupacion =?";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            prepStm.setString(1, Agrupacion);
            ResultSet RS = prepStm.executeQuery();
            if (RS.next()) {
                if (RS.getString("Descripcion").equals("")) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return false;
            }

        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
            return false;
        }
    }

    public boolean getListaValorById(int numId) {
        PreparedStatement prepStm = null;
        final String SQL = "SELECT Agrupacion FROM TB_ListaValor WHERE Id = ?";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            prepStm.setInt(1, numId);
            ResultSet RS = prepStm.executeQuery();

            if (RS.next()) {
                if (RS.getString("Agrupacion").equals("")) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return false;
            }

        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
            return false;
        }
    }
}
