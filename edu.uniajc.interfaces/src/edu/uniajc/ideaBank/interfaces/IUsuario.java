/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.Usuario;
import java.util.ArrayList;
import java.util.Date;
import javax.ejb.Remote;

/**
 *
 * @author bmorales
 */
@Remote
public interface IUsuario {
    public Usuario createUser(int idTipoUsuario,int idEstadoUsuario, 
            int idTipoIdentificacion,int numIdentificacion,String primerNombre,
            String segundoNombre,String primerApellido,String segundoApellido,
            String telefonoFijo,String telefonoCelular,String usuario,
            String contrasena,String creadoPor,Date creadoEn);
    public ArrayList<Usuario> getUsuario();
    
    public Usuario getUserByNumId(int numId);
    
    public Usuario getUserByUser(String User);
    
    public Usuario updateUser(int id,int idTipoUsuario,int idEstadoUsuario, 
            int idTipoIdentificacion,int numIdentificacion,String primerNombre,
            String segundoNombre,String primerApellido,String segundoApellido,
            String telefonoFijo,String telefonoCelular,String modificadoPor,
            Date modificadoEn);
}
