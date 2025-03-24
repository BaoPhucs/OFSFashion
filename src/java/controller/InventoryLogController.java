/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import OFS.Inventory.InventoryLogDAO;
import OFS.Inventory.InventoryLogDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author nguye
 */
@WebServlet(name = "InventoryLogController", urlPatterns = {"/inventoryLog"})
public class InventoryLogController extends HttpServlet {
    
    private static final int PAGE_SIZE = 15;
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet InventoryLogController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InventoryLogController at " + request.getContextPath() + "</h1>");
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
        InventoryLogDAO inventoryLogDAO = new InventoryLogDAO();

        // Lấy tham số tìm kiếm, sắp xếp và trang
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "none";
        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int offset = (page - 1) * PAGE_SIZE;

        // Lấy danh sách log với tìm kiếm, sắp xếp và phân trang
        List<InventoryLogDTO> inventoryLogs = inventoryLogDAO.getInventoryLogsWithFilters(keyword, sort, offset, PAGE_SIZE);
        int totalLogs = inventoryLogDAO.getTotalLogs(keyword);
        int totalPages = (int) Math.ceil((double) totalLogs / PAGE_SIZE);

        // Đặt các thuộc tính để hiển thị trên JSP
        request.setAttribute("inventoryLogs", inventoryLogs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("inventoryLog.jsp").forward(request, response);
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
        doGet(request, response);
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
