/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import OFS.Category.CategoryDAO;
import OFS.Category.CategoryDTO;
import OFS.Product.Product;
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
import javax.servlet.http.HttpSession;

/**
 *
 * @author nguye
 */
@WebServlet(name = "ProductByCategoryController", urlPatterns = {"/productbycategory"})
public class ProductByCategoryController extends HttpServlet {

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
            out.println("<title>Servlet ProductByCategoryController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductByCategoryController at " + request.getContextPath() + "</h1>");
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
        String categoryIdStr = request.getParameter("category_id");
        if (categoryIdStr == null || categoryIdStr.isEmpty()) {
            response.sendRedirect("home.jsp");
            return;
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("home.jsp");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        List<Product> productList = productDAO.getProductsByCategory(categoryId);
        CategoryDAO categoryDAO = new CategoryDAO();
        CategoryDTO category = categoryDAO.getCategoryById(categoryId);
        String categoryName = (category != null) ? category.getName() : "Unknown Category";

        // Lấy ảnh đầu tiên cho mỗi sản phẩm
        for (Product p : productList) {
            List<ProductImages> images = productDAO.getProductImagesByProductId(p.getProductId());
            if (!images.isEmpty()) {
                request.setAttribute("firstImage_" + p.getProductId(), images.get(0).getImageUrl());
            } else {
                request.setAttribute("firstImage_" + p.getProductId(), "/Images/default.jpg");
            }
        }

        boolean viewAll = "true".equals(request.getParameter("viewall"));
        List<Product> displayedProducts;
        if (viewAll) {
            displayedProducts = productList;
        } else {
            displayedProducts = new ArrayList<>();
            int maxDisplay = Math.min(12, productList.size());
            for (int i = 0; i < maxDisplay; i++) {
                displayedProducts.add(productList.get(i));
            }
        }

        HttpSession session = request.getSession(false);
        int userId = (session != null && session.getAttribute("userId") != null) ? (Integer) session.getAttribute("userId") : 0;
        request.setAttribute("userId", userId);
        request.setAttribute("productList", displayedProducts);
        request.setAttribute("allProducts", productList);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("categoryName", categoryName);
        request.getRequestDispatcher("productlist.jsp").forward(request, response);
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
