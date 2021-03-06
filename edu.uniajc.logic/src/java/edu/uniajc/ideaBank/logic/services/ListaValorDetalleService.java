/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.DAO.ListaValorDetalleDAO;
import edu.uniajc.ideaBank.interfaces.model.ListaValorDetalle;
import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import edu.uniajc.ideaBank.interfaces.IListaValorDetalle;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.Stateless;

/**
 *
 * @author rlara
 */
@Stateless
public class ListaValorDetalleService implements IListaValorDetalle {

    Connection dbConnection;
    boolean validatorValor;
    ListaValorDetalle listaValorDetalleModel;
    
    public ListaValorDetalleService() {
        try {
            this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
        } catch (NamingException | SQLException e) {
            Logger.getLogger(UserService.class.getName()).log(Level.SEVERE, null, e);
        }
    }
    
    @Override
    public int createListaValorDetalle(ListaValorDetalle listaValorDetalleModel) {
        ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
        boolean confirmListaValorDetalle;
        
        confirmListaValorDetalle = dao.createListaValorDetalle(listaValorDetalleModel);

        if (confirmListaValorDetalle == true) {
            return 0;
        } else {
            return -1;
        }
    }
    
    @Override
    public List<ListaValorDetalle> listaValorDetalleDesc() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getListaValorDetalleByIdListaValor(listaValorDetalleModel.getIdListaValor());
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public int updateListaValorDetalle(ListaValorDetalle listaValorDetalleModel) {
        ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
        boolean confirmListaValorDetalle;
        
        confirmListaValorDetalle = dao.updateListaValorDetalle(listaValorDetalleModel);
        if (confirmListaValorDetalle == true) {
            return 0;
        } else {
            return -1;
        }
    }
        
    @Override
    public List<ListaValorDetalle> listaTipoIdentificacion() {
        try {
            System.out.println("Service");
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getTipoIdentificacion();
            System.out.println("EndService");
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }
    
    @Override
    public List<ListaValorDetalle> listaTipoIntegrante() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getTipoIntegrante();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaEstadoIntegrante() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getEstadoIntegrante();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaEstadoProyecto() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getEstadoProyecto();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaTipoEvaluacion() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getTipoEvaluacion();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaPeriodoEntrega() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getPeriodoEntrega();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaEstadoEntrega() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getEstadoEntrega();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaEstadoIdea() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getEstadoIdea();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaEstadoIdeaUsuario() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getEstadoIdeaUsuario();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaTipoUsuario() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getTipoUsuario();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaEstadoUsuario() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getEstadoUsuario();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaEstadoSolicitudRol() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getEstadoSolicitudRol();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaEstadoUsuarioRol() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getEstadoUsuarioRol();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaProgramaAcademico() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getProgramaAcademico();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<ListaValorDetalle> listaDependencia() {
        try {
            ListaValorDetalleDAO dao = new ListaValorDetalleDAO(dbConnection);
            List<ListaValorDetalle> list = dao.getDependencia();
            return list;
            
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return null;
        }
    }
    
}
