/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.logic.services;
import edu.uniajc.security.DAO.TokenDAO;
import edu.uniajc.ideaBank.DAO.UserDAO;
import edu.uniajc.ideaBank.Utilities.SendMail;
import edu.uniajc.security.interfaces.IToken;
import edu.uniajc.ideaBank.interfaces.model.User;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ejb.Stateless;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;


/**
 *
 * @author Felipe
 */
@Stateless
public class TokenService implements IToken{
    
    Connection dbConnection=null;
    
    public TokenService() throws NamingException, SQLException {
        this.dbConnection = ((DataSource) new InitialContext().lookup("jdbc/sample")).getConnection();
    }
    
    public String IpAddress() {
        InetAddress address = null;          
        try {
            address = InetAddress.getLocalHost();
        } catch (UnknownHostException ex) {
            Logger.getLogger(TokenService.class.getName()).log(Level.SEVERE, null, ex);
        }       
        
        return address.getHostAddress();
    }
  
    

    @Override
    public boolean createToken(String usuario) {
        TokenDAO dao = new TokenDAO(dbConnection);
        boolean salida;
        String ip,token;
        token=java.util.UUID.randomUUID().toString();
        
        if (dao.createToken(usuario, token,1)){
            SendMail obj=new SendMail();
            
            ip=IpAddress();
            String mensaje = mensaje= "<html>"
                    + "<head>"
                    + "<title>Restablece tu contraseña</title>"
                    + "</head>"
                    + "<body>"
                    + "<p>Hemos recibido una petición para restablecer la contraseña de tu cuenta.</p>"
                    + "<p>Si hiciste esta petición, haz clic en el siguiente enlace,"
                    + " si no hiciste esta petición puedes ignorar este correo.</p>"
                    + "<p>"
                    + "<strong>Enlace para restablecer tu contraseña</strong><br>"
                    + "<a href='http://" + ip + ":39865/ideaBank/servlet/passwd?TOKEN=" + token + "'"
                    + "target='_blank+'>Pulsa Aqui para recuperar tu contraseña</a>"
                    + "</p>"
                    + "</body>"
                    + "</html>";
            obj.enviar_correo(usuario,"IRIS - Solicitud cambio contraseña", mensaje);
            salida=true;
        }else{
            salida=false;
        }        
        return salida;
    } 

    @Override
    public boolean validateUser(String usuario) {
       UserDAO dao = new UserDAO(dbConnection);        
       return dao.getUserByUser(usuario);
    }

    @Override
    public User getUserByToken(String token) {        
        TokenDAO dao = new TokenDAO(dbConnection);
        return dao.getUserByToken(token);        
    }

    @Override
    public boolean updateToken(String usuario, String token) {
        TokenDAO dao = new TokenDAO(dbConnection);
        return dao.updateToken(usuario, token);
    }

   
}
