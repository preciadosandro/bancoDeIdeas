/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.ListaValorDetalle;
import javax.ejb.Remote;

/**
 *
 * @author rlara
 */
@Remote  
public interface IListaValorDetalle {
    public boolean createListaValorDetalle(ListaValorDetalle listaValorDetalleModel);    
}