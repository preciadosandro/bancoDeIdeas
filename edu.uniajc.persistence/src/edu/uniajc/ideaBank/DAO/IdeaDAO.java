/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import edu.uniajc.ideaBank.interfaces.model.Idea;
import edu.uniajc.ideaBank.interfaces.model.IdeasObjetivos;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nathalia Riascos
 * @author LMIRANDA
 */
public class IdeaDAO {
     private Connection DBConnection = null;

    public IdeaDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }

    public boolean createIdea(Idea idea) {

           try {
            PreparedStatement ps = null;
            String SQL;

            SQL = "INSERT INTO TB_IDEA(ID, CREADOEN, "
                    + "ID_T_USUARIO, TITULO, DESCRIPCION, IDEAPRIVADA, PALABRASCLAVE, "
                    + "CREADOPOR, ID_T_LV_ESTADOIDEA) "
                    + "VALUES(SQ_TB_IDEA.nextval, sysdate, ?, ?, ?, ?, ?, ?, ?)";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(1, idea.getidUsuario());
            ps.setString(2, idea.gettitulo());
            ps.setString(3, idea.getdescripcion());
            ps.setInt(4, idea.getideaPrivada());
            ps.setString(5, idea.getpalabrasClaves());
            ps.setString(6, idea.getcreadoPor());
            ps.setInt(7, idea.getidEstadoidea());
            ps.execute();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            Logger.getLogger(IdeaDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }

    }

    public ArrayList<IdeasObjetivos> listar()  {
        ArrayList<IdeasObjetivos> lista = null;

        try {
            //this.Conectar();
            PreparedStatement ps = null;

            String SQL = "select Y.TITULO, Y.DESCRIPCION , O.DESCRIPCION, Y.PALABRASCLAVE, U.PRIMERNOMBRE, U.PRIMERAPELLIDO ,U.USUARIO, Y.ID  from TB_IDEA Y,TB_OBJETIVOIDEA O,TB_USUARIO U WHERE Y.ID = O.ID_T_IDEA and U.ID = Y.ID_T_USUARIO";
            ps = this.DBConnection.prepareStatement(SQL);
            ResultSet rs = ps.executeQuery();
            lista = new ArrayList();
            while (rs.next()) {
                IdeasObjetivos ideo = new IdeasObjetivos();
                ideo.setTITULO_ideas(rs.getString(1));
                ideo.setDESCRIPCION_ideas(rs.getString(2));
                ideo.setDESCRIPCION_objetivo(rs.getString(3));
                ideo.setPALABRASCLAVE_ideas(rs.getString(4));
                ideo.setPrimerNombre_usuario(rs.getString(5));
                ideo.setPrimerApellido_usuario(rs.getString(6));
                ideo.setUsuario_usuario(rs.getString(7));
                ideo.setID_ideas(rs.getInt(8));
                lista.add(ideo);
            }
        } catch (Exception e) {
          Logger.getLogger(IdeaDAO.class.getName()).log(Level.SEVERE, null, e);
          lista = null;
        }
        return lista;
    }

    //------------------------------------------------------------------------//
    public ArrayList<IdeasObjetivos> listarxid(int id) {
        ArrayList<IdeasObjetivos> listaxid = null;

        try {
            //this.Conectar();
            PreparedStatement ps = null;

            String SQL = "select Y.TITULO, Y.DESCRIPCION , O.DESCRIPCION, Y.PALABRASCLAVE, U.PRIMERNOMBRE, U.PRIMERAPELLIDO ,U.USUARIO, Y.CREADOPOR  from TB_IDEA Y,TB_OBJETIVOIDEA O,TB_USUARIO U WHERE Y.ID = O.ID_T_IDEA and U.ID = Y.ID_T_USUARIO and Y.id = ?";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            listaxid = new ArrayList();
            while (rs.next()) {
                IdeasObjetivos ideo = new IdeasObjetivos();
                ideo.setTITULO_ideas(rs.getString(1));
                ideo.setDESCRIPCION_ideas(rs.getString(2));
                ideo.setDESCRIPCION_objetivo(rs.getString(3));
                ideo.setPALABRASCLAVE_ideas(rs.getString(4));
                ideo.setPrimerNombre_usuario(rs.getString(5));
                ideo.setPrimerApellido_usuario(rs.getString(6));
                ideo.setUsuario_usuario(rs.getString(7));
                ideo.setCREADOPOR_ideas(rs.getString(8));
                listaxid.add(ideo);
            }
        } catch (Exception e) {
          Logger.getLogger(IdeaDAO.class.getName()).log(Level.SEVERE, null, e);
          listaxid = null;
        }
        return listaxid;
    }
    
    
    public boolean updateStateIdea(Idea idea) {

        try {
            String SQL;
            PreparedStatement ps = null;
            SQL = "UPDATE TB_IDEA SET MODIFICADOEN=sysdate, MODIFICADOPOR = ?, ID_T_LV_ESTADOIDEA = ? WHERE ID = ?";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setString(1, idea.getmodificadoPor());
            ps.setInt(2, idea.getidEstadoidea());
            ps.setInt(3, idea.getId());
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
            e.printStackTrace();
            return false;
        }

    }
    

}
