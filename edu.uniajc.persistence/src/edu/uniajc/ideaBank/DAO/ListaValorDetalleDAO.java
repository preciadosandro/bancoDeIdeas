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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
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
            ps.setString(4, "rlara");
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(ListaValorDetalleDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }

    public List<ListaValorDetalle> getListaValorDetalleByIdListaValor(int idListaValor) {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT Valor FROM TB_ListaValorDetalle WHERE ID_T_ListaValor =? ORDER BY 1";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("ID"));
                uRow.setIdListaValor(RS.getInt("ID_T_ListaValor"));
                uRow.setValor(RS.getString("Valor"));
                uRow.setEstado(RS.getInt("Estado"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getListaValorDetalleById(int id) {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT Valor FROM TB_ListaValorDetalle WHERE Id = ?";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("ID"));
                uRow.setIdListaValor(RS.getInt("ID_T_ListaValor"));
                uRow.setValor(RS.getString("Valor"));
                uRow.setEstado(RS.getInt("Estado"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public boolean updateListaValorDetalle(ListaValorDetalle listaValorDetalleModel) {

        try {
            PreparedStatement ps = null;
            String SQL;
            SQL = "UPDATE TB_ListaValorDetalle SET Estado = ? WHERE ID = ?";

            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(1, listaValorDetalleModel.getEstado());
            ps.setInt(2, listaValorDetalleModel.getId());
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
    }

    public List<ListaValorDetalle> getTipoIdentificacion() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'TipoIdentificacion'";

        try {
            System.out.println("DAO");
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDetalleDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getTipoIntegrante() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'TipoIntegrante'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDetalleDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getEstadoIntegrante() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'EstadoIntegrante'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getEstadoProyecto() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'EstadoProyecto'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getTipoEvaluacion() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'TipoEvaluacion'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getPeriodoEntrega() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'PeriodoEntrega'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getEstadoEntrega() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'EstadoEntrega'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getEstadoIdea() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'EstadoIdea'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getEstadoIdeaUsuario() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'EstadoIdeaUsuario'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getTipoUsuario() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'TipoUsuario'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getEstadoUsuario() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'EstadoUsuario'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getEstadoSolicitudRol() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'EstadoSolicitudRol'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getEstadoUsuarioRol() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'EstadoUsuarioRol'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getProgramaAcademico() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'ProgramaAcademico'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }

    public List<ListaValorDetalle> getDependencia() {
        List<ListaValorDetalle> itemFound = new ArrayList<ListaValorDetalle>(0);
        PreparedStatement prepStm = null;
        final String SQL = "SELECT TB_ListaValor.ID AS IDListaValor,"
                + " TB_ListaValorDetalle.ID AS IDListaValorDetalle,"
                + " TB_ListaValorDetalle.Valor AS Valor"
                + " FROM TB_ListaValor, "
                + " TB_ListaValorDetalle "
                + " WHERE TB_ListaValor.ID = TB_ListaValorDetalle.ID_T_ListaValores "
                + " AND TB_ListaValor.Estado = 1"
                + " AND TB_ListaValorDetalle.Estado = 1"
                + " AND TB_ListaValor.Agrupacion = 'Dependencia'";

        try {
            prepStm = this.DBConnection.prepareStatement(SQL);
            ResultSet RS = prepStm.executeQuery();

            while (RS.next()) {
                ListaValorDetalle uRow = new ListaValorDetalle();
                uRow.setId(RS.getInt("IDListaValor"));
                uRow.setIdListaValor(RS.getInt("IDListaValorDetalle"));
                uRow.setValor(RS.getString("Valor"));

                itemFound.add(uRow);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListaValorDAO.class.getName()).log(Level.SEVERE, SQL, ex);
        }
        return itemFound;
    }
}
