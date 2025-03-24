/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import OFS.Cart.CartItem;
import OFS.Product.Product;
import OFS.Product.ProductDAO;
import OFS.Product.ProductImages;
import OFS.Product.ProductVariant;
import OFS.Review.ReviewDAO;
import OFS.Review.ReviewDTO;
import OFS.Users.UsersDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
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
@WebServlet(name = "ProductDetailController", urlPatterns = {"/productdetail"})
public class ProductDetailController extends HttpServlet {

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
            out.println("<title>Servlet ProductDetailController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductDetailController at " + request.getContextPath() + "</h1>");
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
        String productIdStr = request.getParameter("product_id");
        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendRedirect("home.jsp");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect("home.jsp");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.getProductById(productId);
        List<ProductVariant> variants = productDAO.getVariantsByProductId(productId);
        List<ProductImages> productImages = productDAO.getProductImagesByProductId(productId);

        Set<String> uniqueColors = new HashSet<>();
        for (ProductVariant variant : variants) {
            uniqueColors.add(variant.getColor());
        }
        List<String> uniqueColorsList = new ArrayList<>(uniqueColors);
        System.out.println("Unique Colors for product_id " + productId + ": " + uniqueColorsList);

        // Lấy danh sách đánh giá và tính điểm trung bình
        List<ReviewDTO> reviews = productDAO.getReviewsByProductId(productId);
        double averageRating = calculateAverageRating(reviews);

        if (product != null) {
            request.setAttribute("product", product);
            request.setAttribute("variants", variants);
            request.setAttribute("uniqueColors", uniqueColorsList);
            request.setAttribute("productImages", productImages);
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("totalReviews", reviews != null ? reviews.size() : 0);
            request.getRequestDispatcher("productdetail.jsp").forward(request, response);
        } else {
            response.sendRedirect("home.jsp");
        }
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
        if ("addToCart".equals(action)) {
            System.out.println("Processing addToCart action"); // Debug
            String productIdStr = request.getParameter("productId");
            String size = request.getParameter("size");
            String color = request.getParameter("color");
            System.out.println("Product ID: " + productIdStr + ", Size: " + size + ", Color: " + color); // Debug

            int productId;
            try {
                productId = Integer.parseInt(productIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect("productdetail?product_id=" + productIdStr);
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);
            List<ProductVariant> variants = productDAO.getVariantsByProductId(productId);
            ProductVariant selectedVariant = null;
            for (ProductVariant variant : variants) {
                if (variant.getSize().equals(size) && variant.getColor().equals(color)) {
                    selectedVariant = variant;
                    break;
                }
            }
            System.out.println("Selected Size: " + size + ", Color: " + color + ", Variant Found: " + (selectedVariant != null));

            if (selectedVariant != null && selectedVariant.getStockQuantity() > 0) {
                CartItem cartItem = new CartItem(product, selectedVariant, 1);
                int userId = user.getUserId();
                Map<Integer, List<CartItem>> userCarts = (Map<Integer, List<CartItem>>) session.getAttribute("userCarts");
                if (userCarts == null) {
                    userCarts = new HashMap<>();
                }
                List<CartItem> cart = userCarts.getOrDefault(userId, new ArrayList<>());
                cart.add(cartItem);
                userCarts.put(userId, cart);
                session.setAttribute("userCarts", userCarts);
                int cartCount = cart.size();
                session.setAttribute("cartCount_" + userId, cartCount);
                response.sendRedirect("cart");
            } else {
                response.sendRedirect("productdetail?product_id=" + productIdStr + "&error=outOfStock");
            }
        } else if ("submitReview".equals(action)) {
            // Xử lý thêm đánh giá
            int productId = Integer.parseInt(request.getParameter("productId"));
            int orderItemId = Integer.parseInt(request.getParameter("orderItemId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comment = request.getParameter("comment");

            ProductDAO productDAO = new ProductDAO();
            ReviewDAO reviewDAO = new ReviewDAO();
            Product product = productDAO.getProductById(productId);

            if (product != null && reviewDAO.canUserReview(user.getUserId(), productId)) {
                ReviewDTO review = new ReviewDTO();
                review.setUser(user);
                review.setProduct(product);
                review.setRating(rating);
                review.setComment(comment);
                review.setCreatedAt(LocalDateTime.now());

                if (reviewDAO.addReview(review)) {
                    response.sendRedirect("productdetail?product_id=" + productId);
                } else {
                    response.sendRedirect("orderdetails?orderId=" + orderItemId + "&error=reviewFailed");
                }
            } else {
                response.sendRedirect("orderdetails?orderId=" + orderItemId + "&error=noPermission");
            }
        } else {
            System.out.println("Unknown action: " + action); // Debug
            response.sendRedirect("home.jsp");
        }
    }

    private double calculateAverageRating(List<ReviewDTO> reviews) {
        if (reviews == null || reviews.isEmpty()) {
            return 0.0;
        }
        double totalRating = 0;
        for (ReviewDTO review : reviews) {
            totalRating += review.getRating();
        }
        return totalRating / reviews.size();
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
