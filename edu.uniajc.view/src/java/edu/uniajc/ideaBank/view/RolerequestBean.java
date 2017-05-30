/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;


import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.ideaBank.interfaces.model.V_rolrequest;

import edu.uniajc.ideaBank.logic.services.V_rolrequestService;
import java.io.Serializable;
import java.util.List;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;
import javax.faces.context.FacesContext;
import org.primefaces.event.RowEditEvent;


/**
 *
 * @author jorge.castaño
 */
@ManagedBean(name =  "role_requestBean")
@ViewScoped
public class RolerequestBean implements Serializable{

    

    private V_rolrequest userrolre;
    
    private List<V_rolrequest> filteredV_rolrequest;
    private List<V_rolrequest> rolrequestsList2 ;
    

    
    private V_rolrequest selectV_rolrequest;
   

   private V_rolrequestService rolrequest2 = new V_rolrequestService();
   

   
   
   public void init(){
     rolrequestsList2 = rolrequest2.getRolrequests2();   
   }

    public V_rolrequest getUserrolre() {
        return userrolre;
    }

    public void setUserrolre(V_rolrequest userrolre) {
        this.userrolre = userrolre;
    }


    
        public List<V_rolrequest> getRolrequestsList2() {
        if ( rolrequestsList2 == null ){
            init();
        }
        return rolrequestsList2;
    }
        


    public V_rolrequest getSelectV_rolrequest() {
        return selectV_rolrequest;
    }
        
        
        
    


    public void setFilteredV_rolrequest(List<V_rolrequest> filteredV_rolrequest) {
        this.filteredV_rolrequest = filteredV_rolrequest;
    }

    public void setSelectV_rolrequest(V_rolrequest selectV_rolrequest) {
        this.selectV_rolrequest = selectV_rolrequest;
    }
    
    

    
    
}
