/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.DAO.IdeaDAO;
import edu.uniajc.ideaBank.interfaces.IIdeasObjetivos;
import edu.uniajc.ideaBank.interfaces.model.IdeasObjetivos;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.Stateless;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author LMIRANDA
 */
@Stateless
public class IdeasObjetivosService implements IIdeasObjetivos {

    Connection dbConnection = null;

    public IdeasObjetivosService() throws NamingException, SQLException {
        this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
    }    

    @Override
    public ArrayList<IdeasObjetivos> lista() {
        try {
            IdeaDAO dao = new IdeaDAO(dbConnection);
            //consulta las ideas que conincidan con el nombre buscado
            ArrayList<IdeasObjetivos> list = dao.listar();
            return list;
        } catch (Exception e) {
            Logger.getLogger(IdeasObjetivosService.class.getName()).log(Level.SEVERE, null, e);
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public ArrayList<IdeasObjetivos> listarXid(int id) {
        try {
            IdeaDAO dao = new IdeaDAO(dbConnection);
            //consulta las ideas que conincidan con el nombre buscado
            ArrayList<IdeasObjetivos> list = dao.listarxid(id);
            return list;
        } catch (Exception e) {
            Logger.getLogger(IdeasObjetivosService.class.getName()).log(Level.SEVERE, null, e);
            System.out.println(e.getMessage());
            return null;
        }
    }

}
