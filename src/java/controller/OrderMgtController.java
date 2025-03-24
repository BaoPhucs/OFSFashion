package controller;

import OFS.Inventory.InventoryLogDAO;
import OFS.Inventory.InventoryLogDTO;
import OFS.Order.Order;
import OFS.Order.OrderDAO;
import OFS.Order.OrderItem;
import OFS.Product.Product;
import OFS.Product.ProductDAO;
import OFS.Product.ProductVariant;
import OFS.Users.UsersDAO;
import OFS.Users.UsersDTO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
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
 * @author Acer
 */
@WebServlet(name = "OrderMgtController", urlPatterns = {"/OrderMgtController"})
public class OrderMgtController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        ProductDAO productDAO = new ProductDAO();
        UsersDAO usersDAO = new UsersDAO();
        InventoryLogDAO inventoryLogDAO = new InventoryLogDAO();
        String action = request.getParameter("action");

        // Kiểm tra quyền admin
        HttpSession session = request.getSession();
        UsersDTO admin = (UsersDTO) session.getAttribute("account"); 
        if (admin == null || !"admin".equalsIgnoreCase(admin.getUserType())) {
            response.sendRedirect("login.jsp?error=PleaseLogin");
            return;
        }

        try {
            if ("createOrder".equals(action)) {
                List<UsersDTO> users = usersDAO.getAllUsers();
                System.out.println("Number of users: " + users.size());
                request.setAttribute("users", users);

                List<Product> products = productDAO.searchProducts("");
                System.out.println("Number of products: " + products.size());
                request.setAttribute("products", products);

                Map<Integer, List<ProductVariant>> productVariants = new HashMap<>();
                for (Product product : products) {
                    List<ProductVariant> variants = productDAO.getProductVariantsByProductId(product.getProductId());
                    System.out.println("Product ID: " + product.getProductId() + ", Number of variants: " + (variants != null ? variants.size() : 0));
                    for (ProductVariant variant : variants) {
                        System.out.println("Variant - ID: " + variant.getVariantId() + ", Size: " + variant.getSize() + ", Color: " + variant.getColor() + ", Price: " + variant.getPrice());
                    }
                    productVariants.put(product.getProductId(), variants);
                }
                System.out.println("Product Variants: " + productVariants);
                request.setAttribute("productVariants", productVariants);

                request.getRequestDispatcher("createOrder.jsp").forward(request, response);
                return;
            } else if ("submitCreateOrder".equals(action)) {
                // Lấy thông tin từ form
                int userId = Integer.parseInt(request.getParameter("userId"));
                String[] productIds = request.getParameterValues("productIds");
                String[] variantIds = request.getParameterValues("variantIds");
                String[] quantities = request.getParameterValues("quantities");
                String[] prices = request.getParameterValues("prices");
                String paymentMethod = request.getParameter("paymentMethod");
                String orderStatus = request.getParameter("orderStatus");
                String deliveryOptions = request.getParameter("deliveryOptions");
                BigDecimal totalAmount = new BigDecimal(request.getParameter("totalAmount"));

                // Kiểm tra số lượng tồn kho trước khi tạo đơn hàng
                for (int i = 0; i < variantIds.length; i++) {
                    if (variantIds[i] == null || variantIds[i].isEmpty()) {
                        continue;
                    }
                    int variantId = Integer.parseInt(variantIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    int stockQuantity = productDAO.getStockQuantity(variantId);
                    if (stockQuantity == -1) {
                        response.sendRedirect("ordermanagement.jsp?error=VariantNotFound");
                        return;
                    }
                    if (quantity > stockQuantity) {
                        response.sendRedirect("ordermanagement.jsp?error=InsufficientStockForVariant" + variantId);
                        return;
                    }
                }

                // Tạo đối tượng Order
                Order order = new Order();
                UsersDTO user = usersDAO.getUsersById(userId);
                order.setUsersDTO(user);
                order.setTotalAmount(totalAmount);
                order.setPaymentMethod(paymentMethod);
                order.setOrderStatus(orderStatus);
                order.setDeliveryOptions(deliveryOptions);
                order.setCreatedAt(LocalDateTime.now());

                // Thêm đơn hàng vào cơ sở dữ liệu
                int orderId = orderDAO.addOrder(order);
                if (orderId == 0) {
                    response.sendRedirect("ordermanagement.jsp?error=FailedToCreateOrder");
                    return;
                }

                // Tạo danh sách OrderItem
                List<OrderItem> orderItems = new ArrayList<>();
                for (int i = 0; i < variantIds.length; i++) {
                    if (variantIds[i] == null || variantIds[i].isEmpty()) {
                        continue;
                    }

                    OrderItem item = new OrderItem();
                    Order orderRef = new Order();
                    orderRef.setOrderId(orderId);
                    item.setOrderId(orderRef);

                    ProductVariant variant = productDAO.getProductVariantById(Integer.parseInt(variantIds[i]));
                    item.setVariantId(variant);
                    item.setQuantity(Integer.parseInt(quantities[i]));
                    item.setPrice(new BigDecimal(prices[i]));
                    orderItems.add(item);
                }

                // Thêm các mục đơn hàng vào cơ sở dữ liệu
                orderDAO.addOrderItems(orderItems);

                // Giảm số lượng tồn kho và ghi log
                for (OrderItem item : orderItems) {
                    int variantId = item.getVariantId().getVariantId();
                    int quantity = item.getQuantity();
                    int currentStock = productDAO.getStockQuantity(variantId);
                    if (currentStock != -1) {
                        int newStock = currentStock - quantity;
                        // Cập nhật stock_quantity
                        productDAO.updateStockQuantity(variantId, newStock);

                        // Ghi log vào inventory_logs
                        InventoryLogDTO log = new InventoryLogDTO();
                        log.setVariantId(variantId);
                        log.setStockChange(-quantity); 
                        log.setChangeType("Removed");
                        log.setAdminId(admin.getUserId()); 
                        log.setChangeReason("Order ID: " + orderId);
                        log.setChangedAt(LocalDateTime.now());

                        if (!inventoryLogDAO.addInventoryLog(log)) {
                            System.err.println("Failed to log inventory change for variant ID: " + variantId);
                        }
                    }
                }

                response.sendRedirect("OrderMgtController?success=OrderCreated");
                return;
            } else if ("viewOrders".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                Order order = orderDAO.getOrderById(orderId);
                if (order == null) {
                    response.sendRedirect("ordermanagement.jsp");
                    return;
                }
                List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderIds(Collections.singletonList(orderId));
                request.setAttribute("order", order);
                request.setAttribute("orderItems", orderItems);
                request.getRequestDispatcher("viewOrder.jsp").forward(request, response);
                return;
            } else if ("deleteOrder".equals(action)) {
                boolean success = false;
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    success = orderDAO.deleteOrder(orderId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": " + success + "}");
                return;
            } else if ("edit".equals(action)) {
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    Order order = orderDAO.getOrderById(orderId);
                    if (order != null) {
                        request.setAttribute("order", order);
                        request.getRequestDispatcher("updateOrder.jsp").forward(request, response);
                        return;
                    } else {
                        response.sendRedirect("ordermanagement.jsp?error=OrderNotFound");
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("ordermanagement.jsp?error=InvalidOrder");
                    return;
                }
            } else if ("updateOrder".equals(action)) {
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String paymentMethod = request.getParameter("paymentMethod");
                    String orderStatus = request.getParameter("orderStatus");
                    String deliveryOptions = request.getParameter("deliveryOptions");

                    boolean success = orderDAO.updateOrder(orderId, orderStatus, paymentMethod, deliveryOptions);
                    response.sendRedirect("OrderMgtController?update=" + success);
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("ordermanagement.jsp?update=false");
                    return;
                }
            }

            // Pagination & Order Listing
            int page = 1;
            int recordsPerPage = 10;
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            int offset = (page - 1) * recordsPerPage;

            String sort = request.getParameter("sort");
            if (sort == null || sort.trim().isEmpty() || "none".equalsIgnoreCase(sort)) {
                sort = "none";
            }

            String statusFilter = request.getParameter("status");
            if (statusFilter == null || "all".equalsIgnoreCase(statusFilter)) {
                statusFilter = "all";
            }

            String keyword = request.getParameter("keyword");
            List<Order> orders;
            int totalRecords;

            // Nếu có từ khóa tìm kiếm, thực hiện tìm kiếm với phân trang
            if (keyword != null && !keyword.trim().isEmpty()) {
                orders = orderDAO.searchOrdersWithPagination(keyword, offset, recordsPerPage);
                totalRecords = orderDAO.getTotalSearchOrders(keyword);
            } else {
                // Nếu không có từ khóa, lấy danh sách đơn hàng theo bộ lọc và phân trang
                orders = orderDAO.getOrdersWithFilters(offset, recordsPerPage, statusFilter, sort);
                totalRecords = orderDAO.getTotalOrders(statusFilter);
            }

            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            request.setAttribute("orders", orders);
            request.setAttribute("selectedSort", sort);
            request.setAttribute("selectedStatus", statusFilter);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword); 

            request.getRequestDispatcher("ordermanagement.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendRedirect("ordermanagement.jsp?error=ServerError");
            } else {
                System.err.println("Cannot send error, response already committed.");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}