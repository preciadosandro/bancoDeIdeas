/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.IdeasObjetivos;
import java.util.ArrayList;
import javax.ejb.Remote;

/**
 *
 * @author LMIRANDA
 */
@Remote 
public interface IIdeasObjetivos {

    public ArrayList<IdeasObjetivos> lista();
    public ArrayList<IdeasObjetivos> listarXid(int id);
}
