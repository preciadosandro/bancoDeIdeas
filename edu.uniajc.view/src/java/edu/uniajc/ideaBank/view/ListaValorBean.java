/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.view;

import edu.uniajc.ideaBank.interfaces.IListaValor;
import edu.uniajc.ideaBank.interfaces.IListaValorDetalle;
import edu.uniajc.ideaBank.interfaces.model.ListaValor;
import edu.uniajc.ideaBank.interfaces.model.ListaValorDetalle;
import edu.uniajc.security.view.ManagerBean;
import java.io.Serializable;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import javax.naming.InitialContext;
import org.primefaces.context.RequestContext;

/**
 *
 * @author rlara
 */
@ManagedBean(name = "listaValorBean")
@SessionScoped
public class ListaValorBean extends ManagerBean implements Serializable {

    private ListaValor listaValor;
    private ListaValorDetalle listaValorDetalle;
    private InitialContext ctx;
    private List<ListaValor> listaAgrupacion;
    
    IListaValor uDao = null;
    IListaValorDetalle uDaoDetalle = null;
    
    IListaValor listaValorDAO = null;
    
    public ListaValorBean() {
        super();
        ctx = super.getContext();
        listaValor = new ListaValor();
        listaValorDetalle = new ListaValorDetalle();
    }

    public ListaValor getListaValor() {
        return listaValor;
    }

    public void setListaValor(ListaValor listaValor) {
        this.listaValor = listaValor;
    }

    public List<ListaValor> getListaAgrupacion() {
        try {
            listaValorDAO = (IListaValor) ctx.lookup("java:global/edu.uniajc.view/ListaValorService!edu.uniajc.ideaBank.interfaces.IListaValor");
        } catch (Exception e) {
            Logger.getLogger(UserBean.class.getName()).log(Level.SEVERE, null, e);
        }
        listaAgrupacion = listaValorDAO.listaAgrupacion();    
        return listaAgrupacion;
    }

    public void setListaAgrupacion(List<ListaValor> listaAgrupacion) {
        this.listaAgrupacion = listaAgrupacion;
    }
    
    public void newListaValor() {

        int validator;
        FacesContext context = FacesContext.getCurrentInstance();

        try {
            uDao = (IListaValor) ctx.lookup("java:global/edu.uniajc.view/ListaValorService!edu.uniajc.ideaBank.interfaces.IListaValor");
        } catch (Exception e) {
            Logger.getLogger(ListaValorBean.class.getName()).log(Level.SEVERE, null, e);
        }

        validator = uDao.createListaValor(this.listaValor);
        switch (validator) {
            case 0:
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                        "Los datos fueron guardados.", ""));
                RequestContext.getCurrentInstance().execute("PF('dialogOk').show()");
                break;
            case -1:
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_FATAL,
                        "Los datos no fueron guardados. 'Problemas en el listaValorDAO'", ""));
                break;
            case -2:
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_ERROR,
                        "La agrupacion ya se encuentra registrada.", ""));
                break;
            default:
                break;
        }
    }
    
    public boolean isChecked() {
        return listaValor.getEstado()!= 0;
    }

    public void setChecked(boolean checked) {
        listaValor.setEstado(checked ? 1 : 0);
    }

    public ListaValorDetalle getListaValorDetalle() {
        return listaValorDetalle;
    }

    public void setListaValorDetalle(ListaValorDetalle listaValorDetalle) {
        this.listaValorDetalle = listaValorDetalle;
    }
    
    public boolean isCheckedDetalle() {
        return listaValorDetalle.getEstado()!= 0;
    }

    public void setCheckedDetalle(boolean checked) {
        listaValorDetalle.setEstado(checked ? 1 : 0);
    }
    
    public void newListaValorDetalle() {

        int validator;
        FacesContext context = FacesContext.getCurrentInstance();

        try {
            uDaoDetalle = (IListaValorDetalle) ctx.lookup("java:global/edu.uniajc.view/ListaValorDetalleService!edu.uniajc.ideaBank.interfaces.IListaValorDetalle");
        } catch (Exception e) {
            Logger.getLogger(ListaValorBean.class.getName()).log(Level.SEVERE, null, e);
        }

        validator = uDaoDetalle.createListaValorDetalle(this.listaValorDetalle);
        switch (validator) {
            case 0:
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_INFO,
                        "Los datos fueron guardados.", ""));
                RequestContext.getCurrentInstance().execute("PF('dialogOk').show()");
                break;
            case -1:
                context.addMessage(null, new FacesMessage(FacesMessage.SEVERITY_FATAL,
                        "Los datos no fueron guardados. 'Problemas en el listaValorDAO'", ""));
                break;
            default:
                break;
        }
    }
    
}
