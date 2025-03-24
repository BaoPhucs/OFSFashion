<%@page import="OFS.Order.OrderItem"%>
<%@page import="OFS.Order.Order"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.time.format.DateTimeFormatter"%>

<%
    Order order = (Order) request.getAttribute("order");
    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");

    boolean hasOrder = (order != null);
    boolean hasItems = (orderItems != null && !orderItems.isEmpty());
%>

<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
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

        h3 {
            font-size: 20px;
            font-weight: 500;
            margin: 20px 0;
            color: #2c3e50;
            text-align: left; 
        }

        /* Thông tin đơn hàng */
        div:not([class]) {
            background-color: #f5f6fa;
            padding: 20px 40px;
            border-radius: 8px;
            margin-bottom: 20px;
            max-width: 600px; 
            margin-left: 0;
        }

        div:not([class]) p {
            margin: 10px 0;
            font-size: 20px;
            color: #34495e;
        }

        div:not([class]) p strong {
            color: #2c3e50;
            font-weight: 500;
            display: inline-block;
            width: 120px;
        }

        /* Thông báo lỗi */
        p[style*="color: red"] {
            color: #dc3545 !important;
            text-align: left; 
            font-size: 16px;
            margin-top: 20px;
        }

        /* Bảng */
        table {
            width: 100%;
            max-width: 800px; 
            margin-left: 0; 
            border-collapse: collapse;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        table th, table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }

        table th {
            font-weight: 500;
            color: #7f8c8d;
            font-size: 14px;
            text-transform: uppercase; 
        }

        table td {
            color: #34495e;
            font-size: 14px;
        }

        table tr:hover {
            background-color: #f5f6fa; 
        }

        /* Liên kết Back to Orders */
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
            div:not([class]) {
                padding: 15px 20px; 
            }

            table {
                max-width: 100%;
            }

            table th, table td {
                padding: 10px;
                font-size: 12px;
            }

            a {
                width: 100%;
            }
        }
    </style>
</head>
<body>

    <h2>Order Details</h2>

    <% if (hasOrder) { %>
        <div>
            <p><strong>Order ID:</strong> #<%= order.getOrderId() %></p>
            <p><strong>Customer:</strong> <%= order.getUsers() != null ? (order.getUsers().getFirstName() + " " + order.getUsers().getLastName()) : "Unknown" %></p>
            <p><strong>Date:</strong> <%= order.getCreatedAt() != null ? DateTimeFormatter.ofPattern("yyyy-MM-dd").format(order.getCreatedAt()) : "N/A" %></p>
            <p><strong>Payment Method:</strong> <%= order.getPaymentMethod() %></p>
            <p><strong>Status:</strong> <%= order.getOrderStatus() %></p>
            <p><strong>Total:</strong> $<%= order.getTotalAmount() %></p>
        </div>

        <h3>Order Items</h3>
        <table border="1">
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Size</th>
                    <th>Color</th>
                    <th>Quantity</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody>
                <% if (hasItems) { %>
                    <% for (OrderItem item : orderItems) { %>
                        <tr>
                            <td><%= item.getVariantId().getProduct().getName() %></td>
                            <td><%= item.getVariantId().getSize() %></td>
                            <td><%= item.getVariantId().getColor() %></td>
                            <td><%= item.getQuantity() %></td>
                            <td>$<%= item.getPrice() %></td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr><td colspan="5">No items found.</td></tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p style="color: red;">Order not found.</p>
    <% } %>

    <a href="OrderMgtController">Back to Orders</a>
</body>
</html>
