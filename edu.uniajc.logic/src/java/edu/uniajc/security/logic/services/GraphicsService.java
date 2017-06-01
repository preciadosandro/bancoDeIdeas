/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.logic.services;

import edu.uniajc.security.DAO.GraphicsDAO;
import edu.uniajc.security.interfaces.ISummaryIdea;
import edu.uniajc.security.interfaces.model.SummaryIdea;
import edu.uniajc.security.interfaces.model.SummaryIdeaByMonth;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.Stateless;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author shpreciado
 */
@Stateless
public class GraphicsService implements ISummaryIdea {

    Connection dbConnection=null;

    public GraphicsService() throws NamingException, SQLException {
        this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
    }
    
    @Override
    public List<SummaryIdea> listSummaryIdea() {
        try {
            GraphicsDAO dao = new GraphicsDAO(dbConnection);
            List <SummaryIdea> lst = dao.listSummaryIdea();
            return lst;
        } catch (Exception e) {
            Logger.getLogger(GraphicsService.class.getName()).log(Level.SEVERE, null, e);
            System.out.println("Error en Service.listSummaryIdea : " + e.getMessage());
            return null;
        }
    }

    @Override
    public List<SummaryIdeaByMonth> listSummaryIdeaByMonth() {
        try {
            GraphicsDAO dao = new GraphicsDAO(dbConnection);
            List <SummaryIdeaByMonth> lst = dao.listSummaryIdeaByMonth();
            return lst;
        } catch (Exception e) {
            Logger.getLogger(GraphicsService.class.getName()).log(Level.SEVERE, null, e);
            System.out.println("Error en Service.SummaryIdeaByMonth : " + e.getMessage());
            return null;
        }
    }
    
}
