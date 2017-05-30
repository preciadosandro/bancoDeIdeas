/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;


import edu.uniajc.ideaBank.DAO.V_rolrequestDAO;

import edu.uniajc.ideaBank.interfaces.model.V_rolrequest;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author jorge.castaño
 */
public class V_rolrequestService {
    
        public ArrayList<V_rolrequest> getRolrequests2() {      
        try {
            Connection dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
            V_rolrequestDAO dao = new V_rolrequestDAO(dbConnection);
            //consulta las solicitudes de Roles que coincidan.
            ArrayList<V_rolrequest> list = dao.getRolesrequest2();
            return list;
        } catch (SQLException | NamingException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }
        
        
        

    
}
