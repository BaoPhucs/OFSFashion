/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Category;

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
public class CategoryDAO extends DBContext {

    public CategoryDTO getCategoryById(int id) {
        String sql = "SELECT * FROM Categories WHERE category_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                CategoryDTO c = new CategoryDTO(
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        createdAt,
                        rs.getString("image_url")
                );
                return c;
            }
        } catch (SQLException e) {
            System.err.println("Error fetching category by id " + id + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<CategoryDTO> getAllCategories() {
        List<CategoryDTO> categoryList = new ArrayList<>();
        String sql = "SELECT * FROM Categories";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                CategoryDTO c = new CategoryDTO(
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        createdAt,
                        rs.getString("image_url")
                );
                categoryList.add(c);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all categories: " + e.getMessage());
            e.printStackTrace();
        }
        return categoryList;
    }
}
