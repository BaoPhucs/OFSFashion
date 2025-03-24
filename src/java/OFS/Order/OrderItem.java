/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Order;

import OFS.Product.ProductVariant;
import java.math.BigDecimal;

/**
 *
 * @author nguye
 */
public class OrderItem {
    private int orderItemId;
    private Order order;
    private ProductVariant variantId;
    private int quantity;
    private BigDecimal price;
    
    public OrderItem(){
        
    }

    public OrderItem(int orderItemId, Order order, ProductVariant variantId, int quantity, BigDecimal price) {
        this.orderItemId = orderItemId;
        this.order = order;
        this.variantId = variantId;
        this.quantity = quantity;
        this.price = price;
    }

    

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public Order getOrderId() {
        return order;
    }

    public void setOrderId(Order order) {
        this.order = order;
    }

    public ProductVariant getVariantId() {
        return variantId;
    }

    public void setVariantId(ProductVariant variantId) {
        this.variantId = variantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    
}
