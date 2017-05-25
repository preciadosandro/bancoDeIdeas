package servlet;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import edu.uniajc.ideaBank.interfaces.IToken;
import edu.uniajc.ideaBank.interfaces.model.User;
import edu.uniajc.ideaBank.logic.services.TokenService;
import static edu.uniajc.ideaBank.view.UserBean.getContext;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.context.FacesContext;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Felipe
 */
public class PaswdMangrServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response, String token)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PaswdMangrServlet</title>");
            out.println("</head>");
            out.println("<h1>");
            out.println("Este es mi token  " + token);
            out.println("<br>");            
            out.println("</h1>");
            out.println("<body>");
            out.println("<h1>Servlet PaswdMangrServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       String myToken = request.getParameter("TOKEN");
       User user=new User();
       FacesContext context = FacesContext.getCurrentInstance();       
        IToken uToken =null;
        try {
            InitialContext ctx = getContext();
            uToken = (IToken) ctx.lookup("java:global/edu.uniajc.view/TokenService!edu.uniajc.ideaBank.interfaces.IToken");
            user=uToken.getUserByToken(myToken);
            System.out.println(user.getUsuario());
        } catch (Exception e) {
            Logger.getLogger(TokenService.class.getName()).log(Level.SEVERE, null, e);
            System.out.println();
        }            
        
      //  if (myToken.equals("1234567890")) {
        
            response.sendRedirect("../faces/newPassword.xhtml"); 
        
                   
        //request.getRequestDispatcher("/faces/newPassword.xhtml").forward(request, response);
       // }
       processRequest(request, response, myToken);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response, "");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
