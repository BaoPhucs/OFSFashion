/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import OFS.Order.Order;
import OFS.Order.OrderDAO;
import OFS.Order.OrderItem;
import OFS.Product.ProductDAO;
import OFS.Product.ProductImages;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
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
@WebServlet(name = "OrderDetailsController", urlPatterns = {"/orderdetails"})
public class OrderDetailsController extends HttpServlet {

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
            out.println("<title>Servlet OrderDetailsController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderDetailsController at " + request.getContextPath() + "</h1>");
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
        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect("order");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("order");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect("order?error=orderNotFound");
            return;
        }

        List<Integer> orderIds = new ArrayList<>();
        orderIds.add(orderId);
        List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderIds(orderIds);

        ProductDAO productDAO = new ProductDAO();
        for (OrderItem item : orderItems) {
            int productId = item.getVariantId().getProduct().getProductId(); 
            List<ProductImages> images = productDAO.getProductImagesByProductId(productId);
            if (!images.isEmpty()) {
                request.setAttribute("firstImage_" + productId, images.get(0).getImageUrl());
            } else {
                request.setAttribute("firstImage_" + productId, "/Images/default.jpg");
            }
        }

        request.setAttribute("order", order);
        request.setAttribute("orderItems", orderItems);
        request.getRequestDispatcher("orderdetails.jsp").forward(request, response);
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
        processRequest(request, response);
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
