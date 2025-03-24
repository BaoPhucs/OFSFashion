/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import OFS.Cart.CartItem;
import OFS.Product.ProductDAO;
import OFS.Product.ProductImages;
import OFS.Users.UsersDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
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
@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

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
            out.println("<title>Servlet CartController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CartController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UsersDTO user = (UsersDTO) session.getAttribute("account");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = user.getUserId();
        Map<Integer, List<CartItem>> userCarts = (Map<Integer, List<CartItem>>) session.getAttribute("userCarts");
        List<CartItem> cart = null;
        if (userCarts != null) {
            cart = userCarts.getOrDefault(userId, new ArrayList<>());
        } else {
            userCarts = new HashMap<>();
            cart = new ArrayList<>();
            userCarts.put(userId, cart);
            session.setAttribute("userCarts", userCarts);
        }

        // Lấy ảnh đầu tiên cho mỗi sản phẩm
        ProductDAO productDAO = new ProductDAO();
        for (CartItem item : cart) {
            int productId = item.getProduct().getProductId(); 
            List<ProductImages> images = productDAO.getProductImagesByProductId(productId);
            if (!images.isEmpty()) {
                request.setAttribute("firstImage_" + productId, images.get(0).getImageUrl());
            } else {
                request.setAttribute("firstImage_" + productId, "/images/default.jpg");
            }
        }

        request.setAttribute("cart", cart);
        int cartCount = cart.size();
        session.setAttribute("cartCount_" + userId, cartCount);

        String action = request.getParameter("action");
        if ("checkout".equals(action)) {
            response.sendRedirect("checkout");
            return;
        }

        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UsersDTO user = (UsersDTO) session.getAttribute("account");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int userId = user.getUserId();
        Map<Integer, List<CartItem>> userCarts = (Map<Integer, List<CartItem>>) session.getAttribute("userCarts");

        if (userCarts == null) {
            userCarts = new HashMap<>();
            session.setAttribute("userCarts", userCarts);
        }

        List<CartItem> cart = userCarts.getOrDefault(userId, new ArrayList<>());

        if ("remove".equals(action)) {
            int index;
            try {
                index = Integer.parseInt(request.getParameter("index"));
            } catch (NumberFormatException e) {
                index = -1;
            }
            if (index >= 0 && index < cart.size()) {
                cart.remove(index);
                userCarts.put(userId, cart);
                session.setAttribute("userCarts", userCarts);
                int cartCount = cart.size();
                session.setAttribute("cartCount_" + userId, cartCount);
                System.out.println("Removed item at index " + index + " for userId " + userId);
            }
        }

        response.sendRedirect("cart");
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
