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
import OFS.Users.UsersDAO;
import OFS.Users.UsersDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author nguye
 */
@WebServlet(name = "OrderController", urlPatterns = {"/order"})
public class OrderController extends HttpServlet {

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
            out.println("<title>Servlet OrderController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderController at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        UsersDTO user = (UsersDTO) session.getAttribute("account");

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());
        System.out.println("User ID: " + user.getUserId() + " | Orders found: " + orders.size());

        // Lấy ảnh đầu tiên cho mỗi sản phẩm trong order
        ProductDAO productDAO = new ProductDAO();
        for (Order order : orders) {
            List<OrderItem> items = orderDAO.getOrderItemsByOrderIds(Arrays.asList(order.getOrderId()));
            for (OrderItem item : items) {
                int productId = item.getVariantId().getProduct().getProductId(); 
                List<ProductImages> images = productDAO.getProductImagesByProductId(productId);
                if (!images.isEmpty()) {
                    request.setAttribute("firstImage_" + productId, images.get(0).getImageUrl());
                } else {
                    request.setAttribute("firstImage_" + productId, "/Images/default.jpg");
                }
            }
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        UsersDAO userDAO = new UsersDAO();
        UsersDTO user = userDAO.check(phone, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", user);

            OrderDAO orderDAO = new OrderDAO();
            List<Order> orders = orderDAO.getOrdersByUserId(user.getUserId());

            // Lấy ảnh đầu tiên cho mỗi sản phẩm trong order
            ProductDAO productDAO = new ProductDAO();
            for (Order order : orders) {
                List<OrderItem> items = orderDAO.getOrderItemsByOrderIds(Arrays.asList(order.getOrderId()));
                for (OrderItem item : items) {
                    int productId = item.getVariantId().getProduct().getProductId(); 
                    List<ProductImages> images = productDAO.getProductImagesByProductId(productId);
                    if (!images.isEmpty()) {
                        request.setAttribute("firstImage_" + productId, images.get(0).getImageUrl());
                    } else {
                        request.setAttribute("firstImage_" + productId, "/Images/default.jpg");
                    }
                }
            }

            request.setAttribute("orders", orders);
            request.getRequestDispatcher("orders.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Sai số điện thoại hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
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
