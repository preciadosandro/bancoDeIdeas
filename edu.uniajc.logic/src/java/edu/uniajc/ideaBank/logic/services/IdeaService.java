/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.DAO.IdeaDAO;
import edu.uniajc.ideaBank.interfaces.IIdea;
import edu.uniajc.ideaBank.interfaces.model.Idea;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author LMIRANDA
 */
public class IdeaService implements IIdea {

    Connection dbConnection = null;

    public IdeaService() throws NamingException, SQLException {
        this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
    }    

    @Override
    public boolean createIdea(Idea idea) {
        try {
            IdeaDAO dao = new IdeaDAO(dbConnection);
            return dao.createIdea(idea);
        } catch (Exception e) {
            Logger.getLogger(IdeaService.class.getName()).log(Level.SEVERE, null, e);
            System.out.println(e.getMessage());
            return false;
        }
    }

}
