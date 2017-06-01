/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;

import edu.uniajc.security.interfaces.ISummaryIdea;
import edu.uniajc.security.interfaces.model.SummaryIdea;
import edu.uniajc.security.interfaces.model.SummaryIdeaByMonth;
import edu.uniajc.security.logic.services.GraphicsService;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;
import javax.faces.bean.ManagedBean;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import org.primefaces.model.chart.Axis;
import org.primefaces.model.chart.AxisType;
import org.primefaces.model.chart.BarChartModel;
import org.primefaces.model.chart.BubbleChartModel;
import org.primefaces.model.chart.BubbleChartSeries;
import org.primefaces.model.chart.ChartSeries;
import org.primefaces.model.chart.DateAxis;
import org.primefaces.model.chart.LineChartModel;
import org.primefaces.model.chart.LineChartSeries;
import org.primefaces.model.chart.PieChartModel;

/**
 * <h1>Bean Index</h1>
 * Bean de la página Index.
 * 
 * @author shpreciado
 * @version 1.0
 * @since 2017-05-25
 */
@ManagedBean(name = "index")
public class IndexBean extends ManagerBean {

    private InitialContext ctx;
    private PieChartModel modelPieChart;
    private LineChartModel modelLineChart;
    private BarChartModel barModel;
    private List<SummaryIdea> lstSumaryIdea;
    private List<SummaryIdeaByMonth> lstSumaryIdeaByMonth;

    /**
     * Creates a new instance of IndexBean
     */
    public IndexBean() {
        super();
        ctx = super.getContext();
        
        modelPieChart = new PieChartModel();
        modelLineChart = new LineChartModel();
        getList();

         
        barModel = new BarChartModel();

        for (SummaryIdea s : lstSumaryIdea) {
            modelPieChart.set(s.getStatus(), s.getQuantity());
            
            //LineChartSeries series = new LineChartSeries();
            ChartSeries series = new ChartSeries();
            series.setLabel(s.getStatus());
            System.out.println("=== >> " + s.getStatus());
            for (SummaryIdeaByMonth sm : lstSumaryIdeaByMonth) {
                System.out.println("=== >> === >> " + sm.getStatus());
                if ( s.getStatus().equals(sm.getStatus()) ) {
                    series.set(sm.getMonth(),sm.getQuantity());
                    System.out.println("=== >> === >> " + sm.getMonth() + " >>" + sm.getQuantity());
                }
            }
            modelLineChart.addSeries(series);
            barModel.addSeries(series);
        }
            
        modelPieChart.setTitle("Ideas por Estados");
        modelPieChart.setLegendPosition("ne");
        
        modelLineChart.setTitle("Crecimiento mensual de Ideas");
        modelLineChart.setLegendPosition("e");
        //modelLineChart.getAxis(AxisType.Y).setMin(0);
        //modelLineChart.getAxis(AxisType.Y).setMax(10);

        modelLineChart.setZoom(true);
        modelLineChart.getAxis(AxisType.Y).setLabel("Cantidad");
        DateAxis axis = new DateAxis("Corte a fin de Mes");
        //axis.setTickAngle(-50);
        axis.setTickAngle(-25);
        axis.setTickFormat("%b %#d, %y");
        modelLineChart.getAxes().put(AxisType.X, axis);

        barModel.setTitle("Ideas por Estados por Mes");
        barModel.setLegendPosition("ne");
        Axis xAxis = barModel.getAxis(AxisType.X);
        xAxis.setLabel("Mes");
         
        Axis yAxis = barModel.getAxis(AxisType.Y);
        yAxis.setLabel("Cantidad");
        yAxis.setMin(0);
        //yAxis.setMax(200);
        
    }

    private void getList() {
        try {
            //ISummaryIdea summaryIdea = new GraphicsService();
            ISummaryIdea summaryIdea = (ISummaryIdea) ctx.lookup("java:global/edu.uniajc.view/GraphicsService!edu.uniajc.security.interfaces.ISummaryIdea");
            lstSumaryIdea = summaryIdea.listSummaryIdea();
            lstSumaryIdeaByMonth = summaryIdea.listSummaryIdeaByMonth();
        } catch (Exception e) {
            Logger.getLogger(IndexBean.class.getName()).log(Level.SEVERE, null, e);
            System.out.println("Error en Bean.getList : " + e.getMessage());
            super.showMessage(FacesMessage.SEVERITY_FATAL, "Error cargando datos de las graficas");
        }
    }
    
    public PieChartModel getModelPieChart() {
        return modelPieChart;
    }

    public LineChartModel getModelLineChart() {
        return modelLineChart;
    }
    
    public BarChartModel getBarModel() {
        return barModel;
    }

    public void buttonAction(ActionEvent actionEvent) {
        super.showMessage(FacesMessage.SEVERITY_INFO, "Prueba desde evento!!!!");
    }
    
}
