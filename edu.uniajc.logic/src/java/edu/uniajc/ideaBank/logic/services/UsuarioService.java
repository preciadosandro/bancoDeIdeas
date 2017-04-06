/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.logic.services;

import edu.uniajc.ideaBank.DAO.UsuarioDAO;
import edu.uniajc.ideaBank.interfaces.IUsuario;
import edu.uniajc.ideaBank.interfaces.model.Usuario;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author bmorales
 */
public class UsuarioService implements IUsuario{

    @Override
    public Usuario createUser(int idTipoUsuario, int idEstadoUsuario, int idTipoIdentificacion, 
            int numIdentificacion, String primerNombre, String segundoNombre, 
            String primerApellido, String segundoApellido, String telefonoFijo, 
            String telefonoCelular, String usuario, String contrasena, 
            String creadoPor, Date creadoEn) {
        try {
            if (idTipoUsuario != 0 && idTipoIdentificacion!=0 && numIdentificacion!=0
                    && !primerNombre.equals("") && !primerApellido.equals("")
                    && !telefonoCelular.equals("") && !usuario.equals("") 
                    && !contrasena.equals("") && !creadoPor.equals("")) {
                Connection dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
                UsuarioDAO dao = new UsuarioDAO(dbConnection);
                Date date = (creadoEn == null)? new Date():creadoEn;
                        
                Usuario user = dao.createUser(idTipoUsuario, idEstadoUsuario, idTipoIdentificacion, 
                        numIdentificacion, primerNombre, segundoNombre, primerApellido, 
                        segundoApellido, telefonoFijo, telefonoCelular, usuario, 
                        contrasena, creadoPor, creadoEn);
                //consulta las ideas que conincidan con el nombre buscado
                return user;
            }else{
                return null;
            }
        } catch (SQLException | NamingException e) {
            System.out.println(e.getMessage());
            return null;
        }
        
    }

    @Override
    public ArrayList<Usuario> getUsuario() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Usuario getUserByNumId(int numId) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Usuario getUserByUser(String User) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Usuario updateUser(int id, int idTipoUsuario, int idEstadoUsuario, int idTipoIdentificacion, int numIdentificacion, String primerNombre, String segundoNombre, String primerApellido, String segundoApellido, String telefonoFijo, String telefonoCelular, String modificadoPor, Date modificadoEn) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
