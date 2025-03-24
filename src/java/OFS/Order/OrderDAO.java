package OFS.Order;

import OFS.Product.Product;
import OFS.Product.ProductVariant;
import OFS.Users.UsersDTO;
import dal.DBContext;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class OrderDAO extends DBContext {

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT order_id, user_id, total_amount, payment_method, order_status, created_at, delivery_options "
                + "FROM orders WHERE user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (!rs.isBeforeFirst()) {
                System.out.println("No orders found for user_id: " + userId);
            }
            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                Order order = new Order(
                        rs.getInt("order_id"),
                        null,
                        rs.getBigDecimal("total_amount"),
                        rs.getString("payment_method"),
                        rs.getString("order_status"),
                        createdAt,
                        rs.getString("delivery_options")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching orders for user_id " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    public Order getOrderById(int id) {
        String sql = "SELECT o.order_id, o.user_id, o.total_amount, o.payment_method, o.order_status, o.created_at, o.delivery_options, "
                + "u.first_name, u.last_name, u.email, u.address "
                + "FROM orders o "
                + "JOIN users u ON o.user_id = u.user_id "
                + "WHERE o.order_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                UsersDTO user = new UsersDTO();
                user.setUserId(rs.getInt("user_id"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                order.setUsersDTO(user);
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setCreatedAt(createdAt);
                order.setDeliveryOptions(rs.getString("delivery_options"));
                return order;
            }
        } catch (SQLException e) {
            System.err.println("Error fetching order by id " + id + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItemsByOrderIds(List<Integer> orderIds) {
        List<OrderItem> orderItems = new ArrayList<>();

        if (orderIds == null || orderIds.isEmpty()) {
            System.err.println("OrderIds is null or empty: " + orderIds);
            return orderItems;
        }

        String placeholders = orderIds.stream().map(id -> "?").collect(Collectors.joining(", "));

        String sql = "SELECT oi.order_item_id, oi.order_id, oi.variant_id, oi.quantity, oi.price, "
                + "       o.total_amount, o.payment_method, o.order_status, "
                + "       pv.size, pv.color, pv.price AS variant_price, "
                + "       p.product_id, p.name "
                + "FROM order_items oi "
                + "JOIN orders o ON oi.order_id = o.order_id "
                + "JOIN product_variants pv ON oi.variant_id = pv.variant_id "
                + "JOIN products p ON pv.product_id = p.product_id "
                + "WHERE oi.order_id IN (" + placeholders + ")";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            for (int i = 0; i < orderIds.size(); i++) {
                st.setInt(i + 1, orderIds.get(i));
            }

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setOrderStatus(rs.getString("order_status"));

                ProductVariant variant = new ProductVariant();
                variant.setVariantId(rs.getInt("variant_id"));
                variant.setSize(rs.getString("size"));
                variant.setColor(rs.getString("color"));
                variant.setPrice(rs.getBigDecimal("variant_price"));

                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                variant.setProduct(product);

                OrderItem item = new OrderItem(
                        rs.getInt("order_item_id"),
                        order,
                        variant,
                        rs.getInt("quantity"),
                        rs.getBigDecimal("price")
                );
                orderItems.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching order items for orderIds " + orderIds + ": " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("Returning " + orderItems.size() + " order items");
        return orderItems;
    }

    public int addOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, total_amount, payment_method, order_status, created_at, delivery_options) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getUsersDTO().getUserId());
            ps.setBigDecimal(2, order.getTotalAmount());
            ps.setString(3, order.getPaymentMethod());
            ps.setString(4, order.getOrderStatus());
            ps.setTimestamp(5, Timestamp.valueOf(order.getCreatedAt()));
            ps.setString(6, order.getDeliveryOptions());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding order: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public void addOrderItems(List<OrderItem> orderItems) {
        String sql = "INSERT INTO order_items (order_id, variant_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (OrderItem item : orderItems) {
                if (item.getOrderId() == null || item.getVariantId() == null) {
                    System.err.println("Invalid order item data: orderId or variantId is null");
                    continue;
                }
                ps.setInt(1, item.getOrderId().getOrderId());
                ps.setInt(2, item.getVariantId().getVariantId());
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getPrice());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            System.err.println("Error adding order items: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Tìm kiếm đơn hàng với phân trang
    public List<Order> searchOrdersWithPagination(String keyword, int offset, int limit) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.user_id, u.first_name, u.last_name, "
                + "o.total_amount, o.payment_method, o.order_status, o.delivery_options, o.created_at "
                + "FROM orders o "
                + "JOIN users u ON o.user_id = u.user_id "
                + "WHERE CAST(o.order_id AS VARCHAR) LIKE ? "
                + "OR LOWER(u.first_name) LIKE LOWER(?) "
                + "OR LOWER(u.last_name) LIKE LOWER(?) "
                + "OR CAST(u.user_id AS VARCHAR) LIKE ? "
                + "OR LOWER(o.payment_method) LIKE LOWER(?) "
                + "OR LOWER(o.order_status) LIKE LOWER(?) "
                + "OR LOWER(o.delivery_options) LIKE LOWER(?) "
                + "ORDER BY o.order_id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchKeyword = "%" + keyword.trim() + "%";
            st.setString(1, searchKeyword);
            st.setString(2, searchKeyword);
            st.setString(3, searchKeyword);
            st.setString(4, searchKeyword);
            st.setString(5, searchKeyword);
            st.setString(6, searchKeyword);
            st.setString(7, searchKeyword);
            st.setInt(8, offset);
            st.setInt(9, limit);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();

                UsersDTO user = new UsersDTO();
                user.setUserId(rs.getInt("user_id"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));

                Order order = new Order(
                        rs.getInt("order_id"),
                        user,
                        rs.getBigDecimal("total_amount"),
                        rs.getString("payment_method"),
                        rs.getString("order_status"),
                        createdAt,
                        rs.getString("delivery_options")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Đếm tổng số đơn hàng tìm thấy
    public int getTotalSearchOrders(String keyword) {
        String sql = "SELECT COUNT(*) "
                + "FROM orders o "
                + "JOIN users u ON o.user_id = u.user_id "
                + "WHERE CAST(o.order_id AS VARCHAR) LIKE ? "
                + "OR LOWER(u.first_name) LIKE LOWER(?) "
                + "OR LOWER(u.last_name) LIKE LOWER(?) "
                + "OR CAST(u.user_id AS VARCHAR) LIKE ? "
                + "OR LOWER(o.payment_method) LIKE LOWER(?) "
                + "OR LOWER(o.order_status) LIKE LOWER(?) "
                + "OR LOWER(o.delivery_options) LIKE LOWER(?)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchKeyword = "%" + keyword.trim() + "%";
            st.setString(1, searchKeyword);
            st.setString(2, searchKeyword);
            st.setString(3, searchKeyword);
            st.setString(4, searchKeyword);
            st.setString(5, searchKeyword);
            st.setString(6, searchKeyword);
            st.setString(7, searchKeyword);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Order> searchOrders(String keyword) {
        return searchOrdersWithPagination(keyword, 0, Integer.MAX_VALUE); // Lấy tất cả kết quả
    }

    private String getOrderByClause(String sort) {
        if (sort == null || sort.isEmpty()) {
            return "o.order_id";
        }
        switch (sort.toLowerCase()) {
            case "date_asc":
                return "o.created_at ASC";
            case "date_desc":
                return "o.created_at DESC";
            case "total_asc":
                return "o.total_amount ASC";
            case "total_desc":
                return "o.total_amount DESC";
            case "none":
            default:
                return "o.order_id";
        }
    }

    public List<Order> getOrdersWithFilters(int offset, int limit, String status, String sort) throws Exception {
        List<Order> orderList = new ArrayList<>();
        String orderBy = getOrderByClause(sort);

        StringBuilder sql = new StringBuilder(
                "SELECT o.order_id, o.user_id, u.first_name, u.last_name, o.created_at, "
                + "o.payment_method, o.order_status, o.delivery_options, o.total_amount "
                + "FROM orders o "
                + "JOIN users u ON o.user_id = u.user_id "
        );

        List<Object> params = new ArrayList<>();

        if (status != null && !status.equalsIgnoreCase("all")) {
            sql.append("WHERE o.order_status = ? ");
            params.add(status);
        }

        sql.append("ORDER BY ").append(orderBy).append(" ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                if (params.get(i) instanceof Integer) {
                    ps.setInt(i + 1, (Integer) params.get(i));
                } else {
                    ps.setString(i + 1, (String) params.get(i));
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                    String paymentMethod = rs.getString("payment_method");
                    String orderStatus = rs.getString("order_status");
                    String deliveryOptions = rs.getString("delivery_options");
                    BigDecimal totalAmount = rs.getBigDecimal("total_amount");

                    UsersDTO user = new UsersDTO();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFirstName(firstName);
                    user.setLastName(lastName);

                    Order order = new Order(orderId, user, totalAmount, paymentMethod, orderStatus, createdAt, deliveryOptions);
                    orderList.add(order);
                }
            }
        }
        return orderList;
    }

    public boolean updateOrder(int orderId, String status, String paymentMethod, String deliveryOptions) throws Exception {
        String sql = "UPDATE orders SET order_status = ?, payment_method = ?, delivery_options = ? WHERE order_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, paymentMethod);
            ps.setString(3, deliveryOptions);
            ps.setInt(4, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalOrders(String status) throws Exception {
        int totalOrders = 0;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) AS total FROM orders ");

        List<Object> params = new ArrayList<>();

        if (status != null && !status.equalsIgnoreCase("all")) {
            sql.append("WHERE order_status = ? ");
            params.add(status);
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, (String) params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalOrders = rs.getInt("total");
                }
            }
        }
        return totalOrders;
    }

    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders";

        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                orders.add(mapOrder(rs));
            }
        }
        return orders;
    }

    public boolean updateOrder(Order updatedOrder) {
        String sql = "UPDATE Orders SET user_id = ?, total_amount = ?, payment_method = ?, order_status = ?, delivery_options = ? WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, updatedOrder.getUsers().getUserId());
            ps.setBigDecimal(2, updatedOrder.getTotalAmount());
            ps.setString(3, updatedOrder.getPaymentMethod());
            ps.setString(4, updatedOrder.getOrderStatus());
            ps.setString(5, updatedOrder.getDeliveryOptions());
            ps.setInt(6, updatedOrder.getOrderId());

            int rowsUpdated = ps.executeUpdate();
            System.out.println("Rows updated: " + rowsUpdated);
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteOrder(int orderId) throws SQLException {
        String sql = "DELETE FROM orders WHERE order_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        UsersDTO user = new UsersDTO();
        user.setUserId(rs.getInt("user_id"));

        return new Order(
                rs.getInt("order_id"),
                user,
                rs.getBigDecimal("total_amount"),
                rs.getString("payment_method"),
                rs.getString("order_status"),
                rs.getTimestamp("created_at").toLocalDateTime(),
                rs.getString("delivery_options")
        );
    }

    public List<Order> getRecentOrdersWithPagination(int offset, int limit) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.user_id, u.first_name, u.last_name, "
                + "o.total_amount, o.payment_method, o.order_status, o.created_at, o.delivery_options "
                + "FROM orders o "
                + "JOIN users u ON o.user_id = u.user_id "
                + "ORDER BY o.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, offset);
            st.setInt(2, limit);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();

                UsersDTO user = new UsersDTO();
                user.setUserId(rs.getInt("user_id"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));

                Order order = new Order(
                        rs.getInt("order_id"),
                        user,
                        rs.getBigDecimal("total_amount"),
                        rs.getString("payment_method"),
                        rs.getString("order_status"),
                        createdAt,
                        rs.getString("delivery_options")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching recent orders with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    // Phương thức đếm tổng số đơn hàng để tính tổng số trang
    public int getTotalRecentOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting total recent orders: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
