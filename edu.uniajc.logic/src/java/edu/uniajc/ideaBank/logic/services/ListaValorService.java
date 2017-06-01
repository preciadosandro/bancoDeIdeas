/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.Utilities.Utilities;
import edu.uniajc.ideaBank.DAO.ListaValorDAO;
import edu.uniajc.ideaBank.interfaces.model.ListaValor;
import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import edu.uniajc.ideaBank.interfaces.IListaValor;
import javax.ejb.Stateless;

/**
 *
 * @author rlara
 */
@Stateless
public class ListaValorService implements IListaValor {

    Connection dbConnection;
    boolean validatorListaValor, validatorId;
    ListaValor listaValorModel;    
    
    @Override
    public boolean createListaValor(ListaValor listaValorModel) {
        try {
            dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
            ListaValorDAO dao = new ListaValorDAO(dbConnection);
            validatorListaValor = dao.getListaValorByAgrupacion(listaValorModel.getAgrupacion());
            validatorId = dao.getListaValorById(listaValorModel.getId());
            
            if (validatorListaValor == false && validatorId == false) {
                return dao.createListaValor(listaValorModel);
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
