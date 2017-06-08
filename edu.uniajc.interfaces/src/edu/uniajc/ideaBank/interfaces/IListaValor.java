/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.ListaValor;
import java.util.List;
import javax.ejb.Remote;

/**
 *
 * @author rlara
 */
@Remote  
public interface IListaValor {
    
    public int createListaValor(ListaValor listaValorModel);
    
    public List<ListaValor> listaValorEncabezado();
    
    public int updateListaValor(ListaValor listaValorModel);
    
    public List<ListaValor> listaAgrupacion();
}
