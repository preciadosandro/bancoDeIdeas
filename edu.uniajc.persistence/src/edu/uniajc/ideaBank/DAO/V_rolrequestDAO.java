/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.DAO;

import edu.uniajc.ideaBank.interfaces.model.Rol;

import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.ideaBank.interfaces.model.V_rolrequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author jorge.castaño
 */
public class V_rolrequestDAO {
    
        private Connection DBConnection = null;

    public V_rolrequestDAO(Connection openConnection) {
        this.DBConnection = openConnection;
    }
    
       public ArrayList<V_rolrequest> getRolesrequest2() {
        System.out.println("nuevo");

        try {
            System.out.println("nuevo");
            ArrayList<V_rolrequest> items = new ArrayList<>(0);
               
            PreparedStatement ps = null;
        final String SQL ="SELECT U.ID,U.USUARIO,RO.DESCRIPCION,R.ESTADO,R.FECHASOLICITUD,R.ID_T_ROL,U.PRIMERNOMBRE,U.PRIMERAPELLIDO FROM PRUEBA.TB_SOLICITUDROL R,PRUEBA.TB_USUARIO U ,PRUEBA.TB_ROL RO WHERE R.ID_T_USUARIO=U.ID AND R.ID_T_ROL=RO.ID";
            ps = this.DBConnection.prepareStatement(SQL);
            ResultSet rs = ps.executeQuery();

            System.out.print(rs.toString());
            
            while (rs.next()) {
                V_rolrequest rol = new V_rolrequest();

                rol.setId(rs.getInt("id"));
                rol.setUsuario(rs.getString("usuario"));
                rol.setDescripcion(rs.getString("descripcion"));
                rol.setEstado(rs.getInt("estado"));
                rol.setFechasolicitud(rs.getDate("fechasolicitud"));
                rol.setId_t_rol(rs.getInt("id_t_rol"));
                rol.setPrimernombre(rs.getString("primernombre"));
                rol.setPrimerapellido(rs.getString("primerapellido"));
                items.add(rol);
                
            }        

            return items;
        } catch (SQLException e) {
           // Logger.getLogger(RolDAO.class.getName()).log(Level.SEVERE, null, e);
           e.printStackTrace();
           return null;
        }
        
    };
       
       
       public boolean updateUserRol(V_rolrequest V_rolrequestModel) {
         System.out.println(V_rolrequestModel.getId_t_rol());
         System.out.println(V_rolrequestModel.getId());
        try {
            
            PreparedStatement ps = null;
            String SQL;
            SQL = "UPDATE TB_SOLICITUDROL SET ID_T_ROL = ? WHERE ID = ?";
            ps = this.DBConnection.prepareStatement(SQL);
            //ps.setInt(1, id);
            ps.setInt(1, V_rolrequestModel.getId_t_rol());
            ps.setInt(2, V_rolrequestModel.getId());
            ps.execute();
            System.out.println(ps);
            return true;

        } catch (Exception e) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, e);
            return false;
        }

    }
       

    
}
