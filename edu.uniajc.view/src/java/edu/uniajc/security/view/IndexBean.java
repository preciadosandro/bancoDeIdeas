/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.uniajc.security.view;

import javax.faces.application.FacesMessage;
import javax.faces.event.ActionEvent;
import javax.faces.bean.ManagedBean;
import org.primefaces.model.chart.AxisType;
import org.primefaces.model.chart.BubbleChartModel;
import org.primefaces.model.chart.BubbleChartSeries;
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

    private PieChartModel modelPieChart;
    private LineChartModel modelLineChart;
    private BubbleChartModel modelBubbleChart;
    private LineChartModel dateModel;

    /**
     * Creates a new instance of IndexBean
     */
    public IndexBean() {
        super();
        super.getContext();
        modelPieChart = new PieChartModel();
        modelPieChart.set("Registrada", 540);
        modelPieChart.set("En Revisión", 325);
        modelPieChart.set("Rechazada", 120);
        modelPieChart.set("Aprobada", 421);
        modelPieChart.set("Inactiva", 10);
        modelPieChart.set("Solicitada", 80);
        modelPieChart.set("Denegada", 25);
        modelPieChart.set("Asignada", 40);
        modelPieChart.setTitle("Ideas por Estados");
        modelPieChart.setLegendPosition("w");
        
        modelLineChart = new LineChartModel();
        LineChartSeries series1 = new LineChartSeries();
        series1.setLabel("Series 1");
        series1.set(1, 2);
        series1.set(2, 1);
        series1.set(3, 3);
        series1.set(4, 6);
        series1.set(5, 8);
        LineChartSeries series2 = new LineChartSeries();
        series2.setLabel("Series 2");
        series2.set(1, 6);
        series2.set(2, 3);
        series2.set(3, 2);
        series2.set(4, 7);
        series2.set(5, 9);
        modelLineChart.addSeries(series1);
        modelLineChart.addSeries(series2);
        modelLineChart.setTitle("Linear Chart");
        modelLineChart.setLegendPosition("e");
        modelLineChart.getAxis(AxisType.Y).setMin(0);
        modelLineChart.getAxis(AxisType.Y).setMax(10);

        modelBubbleChart = new BubbleChartModel();
        modelBubbleChart.add(new BubbleChartSeries("Acura", 70, 183,55));
        modelBubbleChart.add(new BubbleChartSeries("Alfa Romeo", 45, 92, 36));
        modelBubbleChart.add(new BubbleChartSeries("AM General", 24, 104, 40));
        modelBubbleChart.add(new BubbleChartSeries("Bugatti", 50, 123, 60));
        modelBubbleChart.add(new BubbleChartSeries("BMW", 15, 89, 25));
        modelBubbleChart.add(new BubbleChartSeries("Audi", 40, 180, 80));
        modelBubbleChart.add(new BubbleChartSeries("Aston Martin", 70, 70, 48));
        modelBubbleChart.setTitle("Bubble Chart");
        modelBubbleChart.getAxis(AxisType.X).setLabel("Price");
        modelBubbleChart.getAxis(AxisType.Y).setMin(0);
        modelBubbleChart.getAxis(AxisType.Y).setMin(250);
        modelBubbleChart.getAxis(AxisType.Y).setLabel("Labels");
        
        dateModel = new LineChartModel();
        LineChartSeries series1DateModel = new LineChartSeries();
        series1DateModel.setLabel("Series 1");
        series1DateModel.set("2014-01-01", 51);
        series1DateModel.set("2014-01-06", 22);
        series1DateModel.set("2014-01-12", 65);
        series1DateModel.set("2014-01-18", 74);
        series1DateModel.set("2014-01-24", 24);
        series1DateModel.set("2014-01-30", 51);
        LineChartSeries series1DateMode2 = new LineChartSeries();
        series1DateMode2.setLabel("Series 2");
        series1DateMode2.set("2014-01-01", 32);
        series1DateMode2.set("2014-01-06", 73);
        series1DateMode2.set("2014-01-12", 24);
        series1DateMode2.set("2014-01-18", 12);
        series1DateMode2.set("2014-01-24", 74);
        series1DateMode2.set("2014-01-30", 62);
        dateModel.addSeries(series1DateModel);
        dateModel.addSeries(series1DateMode2);
        dateModel.setTitle("Zoom for Details");
        dateModel.setZoom(true);
        dateModel.getAxis(AxisType.Y).setLabel("Values");
        DateAxis axis = new DateAxis("Dates");
        axis.setTickAngle(-50);
        axis.setMax("2014-02-01");
        axis.setTickFormat("%b %#d, %y");
        dateModel.getAxes().put(AxisType.X, axis);

    }
    
    public PieChartModel getModelPieChart() {
        return modelPieChart;
    }

    public LineChartModel getModelLineChart() {
        return modelLineChart;
    }

    public BubbleChartModel getModelBubbleChart() {
        return modelBubbleChart;
    }

    public LineChartModel getDateModel() {
        return dateModel;
    }
    
    public void buttonAction(ActionEvent actionEvent) {
        super.showMessage(FacesMessage.SEVERITY_INFO, "Prueba desde evento!!!!");
    }
    
}
