<%-- 
    Document   : UpdateOrder
    Created on : Mar 19, 2025, 10:08:18 AM
    Author     : Acer
--%>
<%
    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        response.sendRedirect("ordermanagement.jsp?error=OrderNotFound");
        return;
    }
%>

<%@page import="OFS.Users.UsersDTO"%>
<%@page import="java.util.List"%>
<%@page import="OFS.Order.Order"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Order</title>
        <style>
            /* Thiết lập chung */
            body {
                margin: 0;
                font-family: 'Roboto', sans-serif;
                background-color: #f7f9fc; 
                color: #333; 
                padding: 20px;
            }

            /* Tiêu đề */
            h2 {
                font-size: 28px;
                font-weight: 500;
                margin-bottom: 25px;
                color: #2c3e50;
                text-align: left; 
            }

            /* Form */
            form {
                max-width: 600px; 
                margin-left: 0;
                background-color: #ffffff;
                padding: 20px 40px;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            }

            /* Nhãn */
            label {
                display: block;
                font-weight: 500;
                color: #34495e;
                font-size: 14px;
                margin-bottom: 5px;
                margin-top: 15px;
            }

            /* Ô select */
            select {
                width: 100%;
                padding: 10px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                background-color: #ffffff;
                color: #333;
                font-size: 14px;
                box-sizing: border-box;
                transition: border-color 0.3s ease;
            }

            select:focus {
                border-color: #3498db;
                outline: none;
            }

            /* Khoảng cách giữa các phần tử */
            br {
                display: block;
                content: "";
                margin-top: 10px;
            }

            /* Nút Update Order */
            button[type="submit"] {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 20px;
                background-color: #3498db; 
                color: #ffffff;
                border: none;
                border-radius: 8px;
                font-family: 'Roboto', sans-serif;
                font-size: 14px;
                font-weight: 500;
                text-align: center;
                cursor: pointer;
                transition: background-color 0.3s ease;
                width: 200px;
            }

            button[type="submit"]:hover {
                background-color: #2980b9; 
            }

            /* Liên kết Back to Order List */
            a {
                display: inline-block;
                margin: 20px 0 0 0;
                padding: 10px 20px;
                background-color: #f5f5f5; 
                color: #333; 
                border: 1px solid #dfe6e9; 
                border-radius: 8px; 
                font-family: 'Roboto', sans-serif;
                font-size: 14px;
                font-weight: 500;
                text-align: center;
                text-decoration: none;
                cursor: pointer;
                transition: background-color 0.3s ease;
                width: 200px;
            }

            a:hover {
                background-color: #e5e5e5; 
            }

            /* Thiết kế responsive */
            @media (max-width: 768px) {
                form {
                    padding: 15px 20px; 
                }

                select {
                    font-size: 12px;
                }

                button[type="submit"],
                a {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <h2>Update Order #<%= order.getOrderId()%></h2>
        <form action="OrderMgtController?action=updateOrder" method="post">
            <input type="hidden" name="orderId" value="<%= order.getOrderId()%>">

            <label for="paymentMethod">Payment Method:</label>
            <select name="paymentMethod">
                <option value="Cash on Delivery" <%= "Cash on Delivery".equals(order.getPaymentMethod()) ? "selected" : ""%>>Cash on Delivery</option>
                <option value="Credit Card" <%= "Credit Card".equals(order.getPaymentMethod()) ? "selected" : ""%>>Credit Card</option>
            </select>
            </br>
            <label for="orderStatus">Order Status:</label>
            <select name="orderStatus">
                <option value="Processing" <%= "Processing".equals(order.getOrderStatus()) ? "selected" : ""%>>Processing</option>
                <option value="Delivered" <%= "Delivered".equals(order.getOrderStatus()) ? "selected" : ""%>>Delivered</option>
            </select>
            </br>
            <label for="deliveryOptions">Delivery Options:</label>
            <select name="deliveryOptions">
                <option value="In-Store Pickup" <%= "In-Store Pickup".equals(order.getDeliveryOptions()) ? "selected" : ""%>>In-Store Pickup</option>
                <option value="Home Delivery" <%= "Home Delivery".equals(order.getDeliveryOptions()) ? "selected" : ""%>>Home Delivery</option>
            </select>
            </br>
            <button type="submit">Update Order</button>
            </br>
            <a href="OrderMgtController">Back to Order List</a>
            
        </form>

    </body>
</html>

