/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Order;

import OFS.Users.UsersDTO;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author nguye
 */
public class Order {
    private int orderId;
    private UsersDTO users;
    private BigDecimal totalAmount;
    private String paymentMethod;
    private String orderStatus;
    private LocalDateTime createdAt;
    private String deliveryOptions;
    
    public Order(){
        
    }

    public Order(int orderId, UsersDTO users, BigDecimal totalAmount, String paymentMethod, String orderStatus, LocalDateTime createdAt, String deliveryOptions) {
        this.orderId = orderId;
        this.users = users;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.orderStatus = orderStatus;
        this.createdAt = createdAt;
        this.deliveryOptions = deliveryOptions;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public UsersDTO getUsersDTO() {
        return users;
    }

    public void setUsersDTO(UsersDTO usersDTO) {
        this.users = usersDTO;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public UsersDTO getUsers() {
        return users;
    }

    public void setUsers(UsersDTO users) {
        this.users = users;
    }

    public String getDeliveryOptions() {
        return deliveryOptions;
    }

    public void setDeliveryOptions(String deliveryOptions) {
        this.deliveryOptions = deliveryOptions;
    }
    
    
}
