/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.DAO;

import edu.uniajc.security.interfaces.model.SummaryIdea;
import edu.uniajc.security.interfaces.model.SummaryIdeaByMonth;
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
 * @author shpreciado
 */
public class GraphicsDAO {
    private Connection DBConnection = null;
    private final static String SQL_SUMMARY_IDEA = "select STATUS, QUANTITY from VW_IDEA_STATUS";
    private final static String SQL_SUMMARY_IDEA_X_MONTH = "select MONTH, STATUS, QUANTITY from VW_IDEA_STATUS_BY_MONTH";

    public GraphicsDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }

    public List<SummaryIdea> listSummaryIdea(){
        List<SummaryIdea> lst = null;
        try {
            lst = new ArrayList<SummaryIdea>();            
            PreparedStatement ps;
            ps = this.DBConnection.prepareStatement(SQL_SUMMARY_IDEA);
        
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SummaryIdea ideaStatus = new  SummaryIdea();
                ideaStatus.setStatus(rs.getString("STATUS"));
                ideaStatus.setQuantity(rs.getInt("QUANTITY"));
                System.out.println( String.format(
                        "GraphicsDAO.listSummaryIdea ==>> ESTADO[%s] CANTIDAD[%s]",
                        ideaStatus.getStatus(), ideaStatus.getQuantity()
                ));
                lst.add(ideaStatus);
            }
        } catch (SQLException ex) {
            Logger.getLogger(GraphicsDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Error en DAO.listSummaryIdea : "+ex.getMessage());
        }
        return lst;
    }
    
    public List<SummaryIdeaByMonth> listSummaryIdeaByMonth(){
        List<SummaryIdeaByMonth> lst = null;
        try {
            lst = new ArrayList<SummaryIdeaByMonth>();            
            PreparedStatement ps;
            ps = this.DBConnection.prepareStatement(SQL_SUMMARY_IDEA_X_MONTH);
        
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SummaryIdeaByMonth ideaStatusBymonth = new  SummaryIdeaByMonth();
                ideaStatusBymonth.setMonth(rs.getString("MONTH"));
                ideaStatusBymonth.setStatus(rs.getString("STATUS"));
                ideaStatusBymonth.setQuantity(rs.getInt("QUANTITY"));
                System.out.println( String.format(
                        "GraphicsDAO.listSummaryIdeaByMonth ==>> MES[%s] ESTADO[%s] CANTIDAD[%s]", 
                        ideaStatusBymonth.getMonth(), ideaStatusBymonth.getStatus(), ideaStatusBymonth.getQuantity()
                ));
                lst.add(ideaStatusBymonth);
            }
        } catch (SQLException ex) {
            Logger.getLogger(GraphicsDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Error en DAO.listSummaryIdeaByMonth : "+ex);
        }
        return lst;
    }
}
