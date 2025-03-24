/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.data;


import OFS.Order.Order;
import OFS.Users.UsersDTO;
import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Acer
 */
public class DashBoard extends DBContext {
    
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE order_status IN ('Delivered')";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
    
    public int getDeliveredOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE order_status = 'Delivered'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<Order> getRecentOrders(int limit) {
        List<Order> orders = new ArrayList<>();
       String sql = "SELECT o.order_id, o.user_id, u.first_name, u.last_name, " +
             "o.total_amount, o.payment_method, o.order_status, o.delivery_options, o.created_at " +
             "FROM orders o " +
             "JOIN users u ON o.user_id = u.user_id " +
             "ORDER BY o.created_at DESC " +
             "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";


        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, limit);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
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
                    rs.getTimestamp("created_at").toLocalDateTime(),
                    rs.getString("delivery_options")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    
}
