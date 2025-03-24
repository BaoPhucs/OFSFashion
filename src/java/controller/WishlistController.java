/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import OFS.Product.ProductDAO;
import OFS.Product.ProductImages;
import OFS.Users.UsersDTO;
import OFS.Wishlist.WishlistDAO;
import OFS.Wishlist.WishlistDTO;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "WishlistController", urlPatterns = {"/wishlist"})
public class WishlistController extends HttpServlet {

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
            out.println("<title>Servlet WishlistController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet WishlistController at " + request.getContextPath() + "</h1>");
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
        System.out.println("Fetching wishlist for user_id: " + user.getUserId());

        WishlistDAO wishlistDAO = new WishlistDAO();
        List<WishlistDTO> wishlist = wishlistDAO.getWishlistByUserId(user.getUserId());
        System.out.println("Wishlist items found: " + (wishlist != null ? wishlist.size() : "null"));

        // Lấy ảnh đầu tiên cho mỗi sản phẩm
        ProductDAO productDAO = new ProductDAO();
        if (wishlist != null) {
            for (WishlistDTO item : wishlist) {
                int productId = item.getProduct().getProductId();
                List<ProductImages> images = productDAO.getProductImagesByProductId(productId);
                if (!images.isEmpty()) {
                    String imageUrl = images.get(0).getImageUrl();
                    request.setAttribute("firstImage_" + productId, imageUrl);
                    System.out.println("Product ID: " + productId + " | First Image URL: " + imageUrl);
                } else {
                    request.setAttribute("firstImage_" + productId, request.getContextPath() + "/Images/default.jpg");
                    System.out.println("Product ID: " + productId + " | No images found, using default: " + request.getContextPath() + "/Images/default.jpg");
                }
            }
        }

        request.setAttribute("wishlist", wishlist);
        request.getRequestDispatcher("wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        UsersDTO user = (UsersDTO) session.getAttribute("account");
        WishlistDAO wishlistDAO = new WishlistDAO();
        String action = request.getParameter("action");
        String redirect = request.getParameter("redirect");
        int productId;

        try {
            productId = Integer.parseInt(request.getParameter("productId"));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid product ID.");
            doGet(request, response); 
            return;
        }

        boolean success = false;
        if ("add".equals(action)) {
            success = wishlistDAO.addToWishlist(user.getUserId(), productId);
            if (success) {
                request.setAttribute("successMessage", "Product added to wishlist successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to add product to wishlist.");
            }
        } else if ("remove".equals(action)) {
            success = wishlistDAO.removeFromWishlist(user.getUserId(), productId);
            if (success) {
                request.setAttribute("successMessage", "Product removed from wishlist successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to remove product from wishlist.");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid action.");
        }

        if ("productlist".equals(redirect)) {
            String referer = request.getHeader("Referer");
            response.sendRedirect(referer != null ? referer : "productbycategory");
        } else if ("searchOverlay".equals(redirect)) {
            String referer = request.getHeader("Referer");
            if (referer != null) {
                if (!referer.contains("openOverlay=")) {
                    if (referer.contains("?")) {
                        response.sendRedirect(referer + "&openOverlay=true");
                    } else {
                        response.sendRedirect(referer + "?openOverlay=true");
                    }
                } else {
                    response.sendRedirect(referer);
                }
            } else {
                response.sendRedirect("home?openOverlay=true");
            }
        } else {
            
            doGet(request, response);
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
