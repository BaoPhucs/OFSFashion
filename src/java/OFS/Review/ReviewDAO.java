/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Review;

import OFS.Order.Order;
import OFS.Order.OrderDAO;
import OFS.Order.OrderItem;
import OFS.Product.Product;
import OFS.Users.UsersDTO;
import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 *
 * @author nguye
 */
public class ReviewDAO extends DBContext {

    private OrderDAO orderDAO = new OrderDAO();

    
    public boolean canUserReview(int userId, int productId) {
       
        List<Order> orders = orderDAO.getOrdersByUserId(userId);
        if (orders == null || orders.isEmpty()) {
            return false;
        }

        List<Order> deliveredOrders = orders.stream()
                .filter(order -> "Delivered".equalsIgnoreCase(order.getOrderStatus()))
                .collect(Collectors.toList());

        if (deliveredOrders.isEmpty()) {
            return false;
        }

        List<Integer> deliveredOrderIds = deliveredOrders.stream()
                .map(Order::getOrderId)
                .collect(Collectors.toList());

        List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderIds(deliveredOrderIds);
        if (orderItems == null || orderItems.isEmpty()) {
            return false;
        }

        for (OrderItem item : orderItems) {
            if (item.getVariantId().getProduct().getProductId() == productId) {
          
                if (!hasUserReviewedProduct(userId, productId)) {
                    return true;
                }
            }
        }
        return false;
    }

    private boolean hasUserReviewedProduct(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, productId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking existing review: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

   
    public boolean addReview(ReviewDTO review) {
        String sql = "INSERT INTO reviews (user_id, product_id, rating, comment, created_at) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, review.getUser().getUserId());
            st.setInt(2, review.getProduct().getProductId());
            st.setInt(3, review.getRating()); 
            st.setString(4, review.getComment());
            st.setTimestamp(5, Timestamp.valueOf(review.getCreatedAt()));

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding review: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<ReviewDTO> getReviewsByProductId(int productId) {
        List<ReviewDTO> reviews = new ArrayList<>();
        String sql = "SELECT r.review_id, r.user_id, r.product_id, r.rating, r.comment, r.created_at, "
                + "u.first_name, u.email, u.phone, u.address "
                + "FROM reviews r "
                + "JOIN users u ON r.user_id = u.user_id "
                + "WHERE r.product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                UsersDTO user = new UsersDTO();
                user.setUserId(rs.getInt("user_id"));
                user.setFirstName(rs.getString("first_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));

                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));

                ReviewDTO review = new ReviewDTO();
                review.setReviewId(rs.getInt("review_id"));
                review.setUser(user);
                review.setProduct(product);
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

                reviews.add(review);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching reviews: " + e.getMessage());
            e.printStackTrace();
        }
        return reviews;
    }
}
