/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.Idea;
import edu.uniajc.ideaBank.interfaces.model.User;
import java.util.ArrayList;
import javax.ejb.Remote;

/**
 *
 * @author juanmanuel
 */
@Remote 
public interface IMyIdea {
    
    //public ArrayList<Idea> lista();
    public boolean asignarIdea(Idea idea,User user);
    
}
