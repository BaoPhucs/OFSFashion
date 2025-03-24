/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Wishlist;

import OFS.Product.Product;
import OFS.Product.ProductDAO;
import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nguye
 */
public class WishlistDAO extends DBContext {

    public List<WishlistDTO> getWishlistByUserId(int userId) {
        List<WishlistDTO> wishlist = new ArrayList<>();
        String sql = "SELECT w.*, p.* FROM wishlist w JOIN products p ON w.product_id = p.product_id WHERE w.user_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (!rs.isBeforeFirst()) {
                System.out.println("No wishlist items found for user_id: " + userId);
            }
            ProductDAO productDAO = new ProductDAO();
            while (rs.next()) {
                LocalDateTime addedAt = rs.getTimestamp("added_at") != null ? rs.getTimestamp("added_at").toLocalDateTime() : null;
                LocalDateTime createdAt = rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null;
                Product product = new Product(
                        rs.getInt("product_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBigDecimal("base_price"),
                        null, 
                        rs.getString("brand"),
                        rs.getString("material"),
                        createdAt
                );
                WishlistDTO wishlistItem = new WishlistDTO(
                        rs.getInt("wishlist_id"),
                        null, // UsersDTO có thể được lấy riêng nếu cần
                        product,
                        addedAt
                );
                wishlist.add(wishlistItem);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching wishlist for user_id " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return wishlist;
    }

    public boolean addToWishlist(int userId, int productId) {
        String sql = "INSERT INTO wishlist (user_id, product_id, added_at) VALUES (?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, productId);
            st.setTimestamp(3, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            st.executeUpdate();
            System.out.println("Added product " + productId + " to wishlist for user " + userId);
            return true;
        } catch (SQLException e) {
            System.err.println("Error adding to wishlist: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeFromWishlist(int userId, int productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            st.setInt(2, productId);
            st.executeUpdate();
            System.out.println("Removed product " + productId + " from wishlist for user " + userId);
            return true;
        } catch (SQLException e) {
            System.err.println("Error removing from wishlist: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
