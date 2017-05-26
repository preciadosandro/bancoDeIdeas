/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.DAO.ListaValorDAO;
import edu.uniajc.ideaBank.interfaces.model.ListaValor;
import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import edu.uniajc.ideaBank.interfaces.IListaValor;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.Stateless;

/**
 *
 * @author rlara
 */
@Stateless
public class ListaValorService implements IListaValor {

    Connection dbConnection;
    boolean validatorAgrupacion;
    ListaValor listaValorModel;
    
    public ListaValorService() {
        try {
            this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
        } catch (NamingException | SQLException e) {
            Logger.getLogger(UserService.class.getName()).log(Level.SEVERE, null, e);
        }
    }
    
    @Override
    public int createListaValor(ListaValor listaValorModel) {
        ListaValorDAO dao = new ListaValorDAO(dbConnection);
        boolean confirmListaValor;
        validatorAgrupacion = dao.getListaValorByAgrupacion(listaValorModel.getAgrupacion());
        if (validatorAgrupacion == false) {
            listaValorModel.setAgrupacion(listaValorModel.getAgrupacion());
            listaValorModel.setEstado(30);
            confirmListaValor = dao.createListaValor(listaValorModel);
            
            if (confirmListaValor == true) {
                return 0;
            } else {
                return -1;
            }
        } else {
            return -2;
        }
    }
    
    @Override
    public List<ListaValor> listaValorEncabezado() {
        try {
            ListaValorDAO dao = new ListaValorDAO(dbConnection);
            List<ListaValor> list = dao.listListaValor();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public int updateListaValor(ListaValor listaValorModel) {
        ListaValorDAO dao = new ListaValorDAO(dbConnection);
        boolean confirmListaValor;
        
        confirmListaValor = dao.updateListaValor(listaValorModel);
        if (confirmListaValor == true) {
            return 0;
        } else {
            return -1;
        }
    }
    
}
