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
import java.util.ArrayList;
import java.util.List;
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
            ps.setString(1, listaValorModel.getAgrupacion());
            ps.setString(2, listaValorModel.getDescripcion());
            ps.setString(3, "rlara");
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }
    
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

    public List<ListaValor> listListaValor() {
        List<ListaValor> itemFound = new ArrayList<ListaValor>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT ID, Agrupacion, Descripcion, Estado "
                + "FROM TB_ListaValor ORDER BY 1";
        
        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();
            
            while (RS.next()) {
                ListaValor uRow = new ListaValor();
                uRow.setId(RS.getInt("ID"));
                uRow.setAgrupacion(RS.getString("Agrupacion"));
                uRow.setDescripcion(RS.getString("Descripcion"));
                uRow.setEstado(RS.getInt("Estado"));
                
                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }
    
    public boolean updateListaValor(ListaValor listaValorModel) {
        
        try {
            PreparedStatement ps = null;
            String SQL;
            SQL = "UPDATE TB_ListaValor SET Estado = ? WHERE ID = ?";
            
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(1, listaValorModel.getEstado());
            ps.setInt(2, listaValorModel.getId());
            ps.execute();
            return true;
            
        } catch (Exception e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }
}
