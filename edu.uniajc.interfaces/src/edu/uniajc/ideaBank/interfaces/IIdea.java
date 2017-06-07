/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.ideaBank.interfaces;

import edu.uniajc.ideaBank.interfaces.model.Idea;
import java.util.ArrayList;
import javax.ejb.Remote;

/**
 *
 * @author LMIRANDA
 */
@Remote
public interface IIdea {
   
    public boolean createIdea(Idea idea);
    
}
