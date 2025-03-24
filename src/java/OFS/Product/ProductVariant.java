/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Product;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author nguye
 */
public class ProductVariant {
    private int variantId;
    private Product product;
    private String size;
    private String color;
    private BigDecimal price;
    private int stockQuantity;
    private LocalDateTime createdAt;
    
    public ProductVariant(){
        
    }

    public ProductVariant(int variantId, Product product, String size, String color, BigDecimal price, int stockQuantity, LocalDateTime createdAt) {
        this.variantId = variantId;
        this.product = product;
        this.size = size;
        this.color = color;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.createdAt = createdAt;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    
}
