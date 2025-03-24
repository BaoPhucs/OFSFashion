/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import OFS.Cart.CartItem;
import OFS.Inventory.InventoryLogDAO;
import OFS.Order.Order;
import OFS.Order.OrderDAO;
import OFS.Order.OrderItem;
import OFS.Product.ProductDAO;
import OFS.Product.ProductImages;
import OFS.Product.ProductVariant;
import OFS.Users.UsersDTO;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import OFS.Inventory.InventoryLogDTO;

/**
 *
 * @author nguye
 */
@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

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
            out.println("<title>Servlet CheckoutController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CheckoutController at " + request.getContextPath() + "</h1>");
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
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        UsersDTO user = (UsersDTO) session.getAttribute("account");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Map<Integer, List<CartItem>> userCarts = (Map<Integer, List<CartItem>>) session.getAttribute("userCarts");
        if (userCarts == null || userCarts.get(user.getUserId()) == null) {
            response.sendRedirect("cart.jsp");
            return;
        }

        List<CartItem> cartItems = userCarts.get(user.getUserId());
        String[] selectedItems = request.getParameterValues("selectedItems");
        List<CartItem> selectedCartItems = new ArrayList<>();

        if (selectedItems != null) {
            for (String indexStr : selectedItems) {
                int index = Integer.parseInt(indexStr);
                if (index >= 0 && index < cartItems.size()) {
                    try {
                        CartItem cartItem = cartItems.get(index).clone();
                        String quantityParam = request.getParameter("quantity-" + index);
                        System.out.println("Index: " + index + ", Quantity Param: " + quantityParam);
                        int quantity = quantityParam != null ? Integer.parseInt(quantityParam) : cartItem.getQuantity();
                        System.out.println("Final Quantity: " + quantity);
                        cartItem.setQuantity(quantity);
                        selectedCartItems.add(cartItem);
                    } catch (CloneNotSupportedException e) {
                        e.printStackTrace();
                        response.sendRedirect("cart.jsp?error=cloneFailed");
                        return;
                    }
                }
            }
        }

        if (selectedCartItems.isEmpty()) {
            response.sendRedirect("cart.jsp?error=noItemsSelected");
            return;
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : selectedCartItems) {
            totalAmount = totalAmount.add(item.getSubtotal());
        }

        // Lấy ảnh đầu tiên cho mỗi sản phẩm
        ProductDAO productDAO = new ProductDAO();
        for (CartItem item : selectedCartItems) {
            int productId = item.getProduct().getProductId(); 
            List<ProductImages> images = productDAO.getProductImagesByProductId(productId);
            if (!images.isEmpty()) {
                request.setAttribute("firstImage_" + productId, images.get(0).getImageUrl());
            } else {
                request.setAttribute("firstImage_" + productId, "/Images/default.jpg");
            }
        }

        request.setAttribute("cartItems", selectedCartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
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

        Map<Integer, List<CartItem>> userCarts = (Map<Integer, List<CartItem>>) session.getAttribute("userCarts");
        if (userCarts == null || userCarts.get(user.getUserId()) == null) {
            response.sendRedirect("cart.jsp");
            return;
        }

        List<CartItem> cartItems = userCarts.get(user.getUserId());
        String[] selectedItems = request.getParameterValues("selectedItems");
        List<CartItem> selectedCartItems = new ArrayList<>();
        List<Integer> selectedIndices = new ArrayList<>();

        if (selectedItems != null) {
            for (String indexStr : selectedItems) {
                try {
                    int index = Integer.parseInt(indexStr);
                    if (index >= 0 && index < cartItems.size()) {
                        selectedIndices.add(index);
                        CartItem cartItem = cartItems.get(index).clone();
                        String quantityParam = request.getParameter("quantity-" + index);
                        System.out.println("Index: " + index + ", Quantity Param: " + quantityParam);
                        int quantity = quantityParam != null ? Integer.parseInt(quantityParam) : cartItem.getQuantity();
                        System.out.println("Final Quantity: " + quantity);
                        cartItem.setQuantity(quantity);
                        selectedCartItems.add(cartItem);
                    }
                } catch (CloneNotSupportedException | NumberFormatException e) {
                    e.printStackTrace();
                    response.sendRedirect("checkout.jsp?error=processingFailed");
                    return;
                }
            }
        }

        if (selectedCartItems.isEmpty()) {
            response.sendRedirect("checkout.jsp?error=noItemsSelected");
            return;
        }

        // Kiểm tra số lượng hàng trong kho trước khi tạo đơn hàng
        ProductDAO productDAO = new ProductDAO();
        for (CartItem item : selectedCartItems) {
            int variantId = item.getVariant().getVariantId();
            ProductVariant variant = productDAO.getProductVariantById(variantId);
            if (variant == null || variant.getStockQuantity() < item.getQuantity()) {
                response.sendRedirect("checkout.jsp?error=insufficientStock");
                return;
            }
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (CartItem item : selectedCartItems) {
            totalAmount = totalAmount.add(item.getSubtotal());
        }

        String deliveryOption = request.getParameter("delivery");
        System.out.println("Delivery Option from form: " + deliveryOption);
        String deliveryOptions;
        if (deliveryOption != null) {
            if (deliveryOption.equals("in-store")) {
                deliveryOptions = "In-Store Pickup";
            } else if (deliveryOption.equals("home")) {
                deliveryOptions = "Home Delivery";
            } else {
                deliveryOptions = "Home Delivery";
            }
        } else {
            deliveryOptions = "Home Delivery";
        }
        System.out.println("Delivery Options after mapping: " + deliveryOptions);

        String paymentMethod = request.getParameter("payment");
        System.out.println("Payment Method from form: " + paymentMethod);
        if (paymentMethod != null) {
            if (paymentMethod.equals("credit")) {
                paymentMethod = "Credit Card";
            } else if (paymentMethod.equals("cod")) {
                paymentMethod = "Cash on Delivery";
            } else {
                paymentMethod = "Cash on Delivery";
            }
        } else {
            paymentMethod = "Cash on Delivery";
        }
        System.out.println("Payment Method after mapping: " + paymentMethod);

        String orderStatus = "Processing";

        Order order = new Order();
        order.setUsersDTO(user);
        order.setTotalAmount(totalAmount);
        order.setPaymentMethod(paymentMethod);
        order.setOrderStatus(orderStatus);
        order.setCreatedAt(LocalDateTime.now());
        order.setDeliveryOptions(deliveryOptions);

        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem item : selectedCartItems) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(order);
            orderItem.setVariantId(item.getVariant());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setPrice(item.getVariant().getPrice());
            orderItems.add(orderItem);
        }

        OrderDAO orderDAO = new OrderDAO();
        int orderId = orderDAO.addOrder(order);
        if (orderId > 0) {
            for (OrderItem item : orderItems) {
                item.setOrderId(order);
                item.getOrderId().setOrderId(orderId);
            }
            orderDAO.addOrderItems(orderItems);

            // Giảm số lượng hàng trong kho và ghi log
            InventoryLogDAO inventoryLogDAO = new InventoryLogDAO();
            for (CartItem item : selectedCartItems) {
                int variantId = item.getVariant().getVariantId();
                int quantity = item.getQuantity();
                ProductVariant variant = productDAO.getProductVariantById(variantId);
                if (variant != null) {
                    int newStockQuantity = variant.getStockQuantity() - quantity;
                    // Cập nhật số lượng hàng trong kho
                    boolean updated = productDAO.updateProductVariant(
                            variantId,
                            variant.getSize(),
                            variant.getColor(),
                            variant.getPrice(),
                            newStockQuantity
                    );
                    // Ghi log vào bảng inventory_logs
                    InventoryLogDTO log = new InventoryLogDTO();
                    log.setVariantId(variantId);
                    log.setStockChange(-quantity); 
                    log.setChangeType("Removed");
                    log.setAdminId(user.getUserId()); 
                    log.setChangeReason("Checkout by user");
                    log.setChangedAt(LocalDateTime.now());
                    inventoryLogDAO.addInventoryLog(log);
                }
            }

            // Xóa các sản phẩm đã được chọn dựa trên chỉ số
            List<CartItem> updatedCart = new ArrayList<>();
            for (int i = 0; i < cartItems.size(); i++) {
                if (!selectedIndices.contains(i)) {
                    updatedCart.add(cartItems.get(i));
                }
            }

            // Cập nhật giỏ hàng trong session
            userCarts.put(user.getUserId(), updatedCart);
            session.setAttribute("userCarts", userCarts);
            session.setAttribute("cartCount_" + user.getUserId(), updatedCart.size());

            response.sendRedirect("orderConfirmation.jsp?orderId=" + orderId);
        } else {
            response.sendRedirect("checkout.jsp?error=orderFailed");
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
