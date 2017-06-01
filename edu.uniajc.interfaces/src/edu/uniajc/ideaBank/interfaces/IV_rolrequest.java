/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;



import edu.uniajc.ideaBank.interfaces.model.V_rolrequest;
import java.util.ArrayList;
import javax.ejb.Remote;

/**
 *
 * @author jorge.castaño
 */
@Remote
public interface IV_rolrequest {
   
   public ArrayList<V_rolrequest> getRolrequests2();
   public int updateUserRol(V_rolrequest V_rolrequestModel);


}
