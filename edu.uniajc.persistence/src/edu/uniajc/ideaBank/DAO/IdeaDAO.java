/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import edu.uniajc.ideaBank.interfaces.model.Idea;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nathalia Riascos
 */
public class IdeaDAO {
     private Connection DBConnection = null;

    public IdeaDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }
    
      public boolean createUser(Idea ideaModel) {
      
           try {
            PreparedStatement ps = null;
            String SQL;

            SQL = "INSERT INTO TB_IDEA(ID,ID_T_USUARIO,"
                    + "TITULO,DESCRIPCION,IDEAPROVADA,PALABRASCLAVE"
                    + "CREADOPOR,CREADOEN,MODIFICADOPOR,MODIFICADOEN"
                    + "ID_T_LV_ESTADOIDEA) "
                    + "VALUES(?,?,?,?,?,?,?,?,?,?,?)";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(1, ideaModel.getId());
            ps.setInt(2, ideaModel.getidUsuario());
            ps.setInt(3, ideaModel.getidEstadoidea());
            ps.setString(4, ideaModel.gettitulo());
            ps.setString(5, ideaModel.getdescripcion());
            ps.setString(6, ideaModel.getideaPrivada());
            ps.setString(7, ideaModel.getpalabrasClaves());
            ps.setString(8, ideaModel.getcreadoPor());
            java.sql.Date birtDate = new java.sql.Date(ideaModel.getcreadoEn().getTime());
            ps.setDate(9, birtDate);
            ps.setString(10, ideaModel.getmodificadoPor());
            java.sql.Date birtDatedos = new java.sql.Date(ideaModel.getmodificadoEn().getTime());
            ps.setDate(11, birtDatedos);
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(IdeaDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }
      
      }
      ;
     
}
