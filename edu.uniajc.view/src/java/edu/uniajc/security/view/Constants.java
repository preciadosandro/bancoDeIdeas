/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;

/**
 * <h1>Constantes</h1>
 * Constantes de la capa de presentación.
 * 
 * @author shpreciado
 * @version 1.0
 * @since 2017-05-25
 */
public class Constants {

    /**
     * Constructor por defecto para prevenir intanciación.
     */
    public Constants() {
    }

    /**
     * Constantes para manejo de CORBA
    */
    public static final String CORBA_CONTEXT_FACTORY = "com.sun.enterprise.naming.SerialInitContextFactory";
    public static final String CORBA_HOST = "org.omg.CORBA.ORBInitialHost";
    public static final String CORBA_HOST_VALUE = "localhost";
    public static final String CORBA_PORT = "org.omg.CORBA.ORBInitialPort";
    public static final String CORBA_PORT_VALUE = "3700";
    
    /**
     * Constantes para manejo de objetos en sesión
     */
    public static final String SESSION_KEY_USER = "SESSION.KEY.USER";
    public static final String SESSION_KEY_TOKEN_USER = "SESSION_KEY_TOKEN_USER";
    
    
    /**
     * Contantes que se manejan en vistas de Ideas.
     */
    public static final int ESTADO_REGISTRADA = 46; 
    
}
