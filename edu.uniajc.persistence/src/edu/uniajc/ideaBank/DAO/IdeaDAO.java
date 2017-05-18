/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import edu.uniajc.ideaBank.interfaces.model.IdeasObjetivos;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author LMIRANDA
 */
public class IdeaDAO {

    private Connection DBConnection = null;

    public IdeaDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }

    public IdeaDAO() throws NamingException, SQLException {
        this.DBConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
    }

    public List<IdeasObjetivos> listar() throws Exception {
        List<IdeasObjetivos> lista;

        try {
            //this.Conectar();
            PreparedStatement ps = null;

            String SQL = "select Y.TITULO, Y.DESCRIPCION , O.DESCRIPCION from TB_IDEA Y,TB_OBJETIVOIDEA O WHERE Y.ID = O.ID_T_IDEA";
            ps = this.DBConnection.prepareStatement(SQL);
            ResultSet rs = ps.executeQuery();
            lista = new ArrayList();
            while (rs.next()) {
                IdeasObjetivos ideo = new IdeasObjetivos();
                ideo.setTITULO_ideas(rs.getString(1));
                ideo.setDESCRIPCION_ideas(rs.getString(2));
                ideo.setDESCRIPCION_objetivo(rs.getString(3));

                lista.add(ideo);

            }
        } catch (Exception e) {
            throw e;

        } finally {

        }
        return lista;

    }

    public ArrayList<IdeasObjetivos> lista() {
        System.out.println("lista()");
        return null;
    }

}
