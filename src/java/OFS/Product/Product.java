/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Product;

import OFS.Category.CategoryDTO;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author nguye
 */
public class Product {

    private int productId;
    private String name;
    private String description;
    private BigDecimal basePrice;
    private CategoryDTO category;
    private String brand;
    private String material;
    private LocalDateTime createdAt;
    public ProductImages productImage; // Nam thêm
    private List<ProductVariant> productVariant; // Nam thêm

    public ProductImages getProductImage() {
        return productImage;
    }

    public Product(ProductImages productImage) {
        this.productImage = productImage;
    }

    public void setProductImage(ProductImages productImage) { //Nam thêm
        this.productImage = productImage;
    }

    public List<ProductVariant> getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(List<ProductVariant> productVariant) {
        this.productVariant = productVariant;
    }

    public Product(int productId) {
        this.productId = productId;
    }

    public Product() {

    }

    public Product(ResultSet rs) throws SQLException {
        this.productId = rs.getInt("product_id");
        this.name = rs.getString("name");
        this.description = rs.getString("description");
        this.basePrice = rs.getBigDecimal("base_price");
        this.brand = rs.getString("brand");
        this.material = rs.getString("material");
        this.createdAt = rs.getTimestamp("created_at").toLocalDateTime();

        int categoryId = rs.getInt("category_id");
        String categoryName = rs.getString("category_name");
        this.category = new CategoryDTO(categoryId, categoryName);

        // Lấy imageUrl từ ResultSet
        String imageUrl = rs.getString("image_url");
        this.productImage = new ProductImages(imageUrl);
    }

    public Product(int productId, String name, String description, BigDecimal basePrice, CategoryDTO category, String brand, String material, LocalDateTime createdAt) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.basePrice = basePrice;
        this.category = category;
        this.brand = brand;
        this.material = material;
        this.createdAt = createdAt;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(BigDecimal basePrice) {
        this.basePrice = basePrice;
    }

    public CategoryDTO getCategory() {
        return category;
    }

    public void setCategory(CategoryDTO category) {
        this.category = category;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

}
