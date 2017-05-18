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
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author LMIRANDA
 */
public class IdeaService implements IIdeasObjetivos {

    @Override
    public ArrayList<IdeasObjetivos> lista() {
        try {
            Connection dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
            IdeaDAO dao = new IdeaDAO(dbConnection);
            //consulta las ideas que conincidan con el nombre buscado
            ArrayList<IdeasObjetivos> list = dao.lista();
            return list;
        } catch (SQLException | NamingException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }

}
