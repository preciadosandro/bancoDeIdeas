/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.DAO.IdeaDAO;
import edu.uniajc.ideaBank.interfaces.IMyIdea;
import edu.uniajc.ideaBank.interfaces.model.Idea;
import edu.uniajc.ideaBank.interfaces.model.User;
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
 * @author juanmanuel
 */
@Stateless
public class MyIdeaService implements IMyIdea {

    Connection dbConnection = null;

    public MyIdeaService() throws NamingException, SQLException {
        this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
    }    

    @Override
    public boolean asignarIdea(Idea idea, User user) {
        try {
            IdeaDAO dao = new IdeaDAO(dbConnection);
            return dao.updateStateIdea(idea);
        } catch (Exception e) {
            Logger.getLogger(IdeaService.class.getName()).log(Level.SEVERE, null, e);
            System.out.println(e.getMessage());
            return false;
        }
    }

    /*
    @Override
    public ArrayList<Idea> lista() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
*/

}
