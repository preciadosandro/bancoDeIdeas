/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.Utilities.Utilities;
import edu.uniajc.ideaBank.DAO.ListaValorDetalleDAO;
import edu.uniajc.ideaBank.interfaces.model.ListaValorDetalle;
import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import edu.uniajc.ideaBank.interfaces.IListaValorDetalle;
import javax.ejb.Stateless;

/**
 *
 * @author rlara
 */
@Stateless
public class ListaValorDetalleService implements IListaValorDetalle {

    Connection dbConnection;
    boolean validatorListaValorDetalle, validatorId;
    ListaValorDetalle listaValorDetalleModel;    
    
    @Override
    public boolean createListaValorDetalle(ListaValorDetalle listaValorDetalleModel) {
        try {
            dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            validatorListaValorDetalle = dao.getListaValorDetalleById(listaValorDetalleModel.getId());
            validatorId = dao.getListaValorDetalleById(listaValorDetalleModel.getId());
            
            if (validatorListaValorDetalle == false && validatorId == false) {
                return dao.createListaValorDetalle(listaValorDetalleModel);
            } else {
                return false;
            }
        } catch (SQLException | NamingException e) {
            System.out.println(e.getMessage());
            return false;
        } finally {
            try {
                if (null != dbConnection) {
                    dbConnection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

        }
    }
}
