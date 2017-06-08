/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.ListaValorDetalle;
import java.util.List;
import javax.ejb.Remote;

/**
 *
 * @author rlara
 */
@Remote  
public interface IListaValorDetalle {
    
    public int createListaValorDetalle(ListaValorDetalle listaValorDetalleModel);
    
    public List<ListaValorDetalle> listaValorDetalleDesc();
    
    public int updateListaValorDetalle(ListaValorDetalle listaValorDetalleModel);
    
    public List<ListaValorDetalle> listaTipoIdentificacion();

    public List<ListaValorDetalle> listaTipoIntegrante();

    public List<ListaValorDetalle> listaEstadoIntegrante();

    public List<ListaValorDetalle> listaEstadoProyecto();

    public List<ListaValorDetalle> listaTipoEvaluacion();

    public List<ListaValorDetalle> listaPeriodoEntrega();

    public List<ListaValorDetalle> listaEstadoEntrega();

    public List<ListaValorDetalle> listaEstadoIdea();

    public List<ListaValorDetalle> listaEstadoIdeaUsuario();

    public List<ListaValorDetalle> listaTipoUsuario();

    public List<ListaValorDetalle> listaEstadoUsuario();

    public List<ListaValorDetalle> listaEstadoSolicitudRol();

    public List<ListaValorDetalle> listaEstadoUsuarioRol();

    public List<ListaValorDetalle> listaProgramaAcademico();

    public List<ListaValorDetalle> listaDependencia();
}
