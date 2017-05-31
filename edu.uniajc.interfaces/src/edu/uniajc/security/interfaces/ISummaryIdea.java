/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.interfaces;

import edu.uniajc.security.interfaces.model.SummaryIdea;
import edu.uniajc.security.interfaces.model.SummaryIdeaByMonth;
import java.util.List;
import javax.ejb.Remote;

/**
 *
 * @author shpreciado
 */
@Remote
public interface ISummaryIdea {
    public List<SummaryIdea> listSummaryIdea();
    public List<SummaryIdeaByMonth> listSummaryIdeaByMonth();

    
}
