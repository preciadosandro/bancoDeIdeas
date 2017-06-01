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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

            SQL = "INSERT INTO TB_IDEA(ID,ID_T_USUARIO,"
                    + "TITULO,DESCRIPCION,IDEAPROVADA,PALABRASCLAVE"
                    + "CREADOPOR,CREADOEN,MODIFICADOPOR,MODIFICADOEN"
                    + "ID_T_LV_ESTADOIDEA) "
                    + "VALUES(SQ_TB_IDEA.nextval,?,?,?,?,?,?,?,?,?,?)";
            ps = this.DBConnection.prepareStatement(SQL);
            ps.setInt(1, idea.getidUsuario());
            ps.setInt(2, idea.getidEstadoidea());
            ps.setString(3, idea.gettitulo());
            ps.setString(4, idea.getdescripcion());
            ps.setString(5, idea.getideaPrivada());
            ps.setString(6, idea.getpalabrasClaves());
            ps.setString(7, idea.getcreadoPor());
            java.sql.Date birtDate = new java.sql.Date(idea.getcreadoEn().getTime());
            ps.setDate(8, birtDate);
            ps.setString(9, idea.getmodificadoPor());
            java.sql.Date birtDatedos = new java.sql.Date(idea.getmodificadoEn().getTime());
            ps.setDate(10, birtDatedos);
            ps.execute();
            return true;

        } catch (Exception e) {
            Logger.getLogger(IdeaDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }

    }

    public List<IdeasObjetivos> listar()  {
        List<IdeasObjetivos> lista = null;

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
    public List<IdeasObjetivos> listarxid(int id) {
        List<IdeasObjetivos> listaxid = null;

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

}
