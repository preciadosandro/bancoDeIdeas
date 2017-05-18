/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import edu.uniajc.ideaBank.interfaces.model.ListaValorDetalle;
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
public class ListaValorDetalleDAO {

    private Connection DBConnection = null;

    public ListaValorDetalleDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }

    public boolean createListaValorDetalle(ListaValorDetalle listaValorDetalleModel) {

        try {
            PreparedStatement ps = null;
            String SQL;

            SQL = "INSERT INTO TB_ListaValorDetalle(ID, ID_T_ListaValor, "
                    + "Valor, CreadoPor) VALUES (SQ_TB_ListaValorDetalle.nextval, ?, ?, ?, ?)";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(2, listaValorDetalleModel.getIdListaValor());
            ps.setString(3, listaValorDetalleModel.getValor());
            ps.setString(4, listaValorDetalleModel.getCreadoPor());
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(ListaValorDetalleDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }

    ;
    
    public boolean getListaValorDetalleByIdListaValor(int idListaValor) {
        PreparedStatement prepStm = null;
        final String SQL = "SELECT Valor FROM TB_ListaValorDetalle WHERE ID_T_ListaValor =?";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            prepStm.setInt(1, idListaValor);
            ResultSet RS = prepStm.executeQuery();
            if (RS.next()) {
                if (RS.getString("Valor").equals("")) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return false;
            }

        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDetalleDAO.class.getName()).log(Level.SEVERE, SQL, ex);
            return false;
        }
    }

    public boolean getListaValorDetalleById(int id) {
        PreparedStatement prepStm = null;
        final String SQL = "SELECT Valor FROM TB_ListaValorDetalle WHERE Id = ?";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            prepStm.setInt(1, id);
            ResultSet RS = prepStm.executeQuery();

            if (RS.next()) {
                if (RS.getString("Valor").equals("")) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return false;
            }

        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDetalleDAO.class.getName()).log(Level.SEVERE, SQL, ex);
            return false;
        }
    }
}
