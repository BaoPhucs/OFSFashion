<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="OFS.Order.Order"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="OFS.Users.UsersDTO"%>
<%@page import="OFS.Order.OrderItem"%>
<%@page import="java.util.ArrayList"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order List - OFS Fashion</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="CSS/styles.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f0f0f0;
                margin: 0;
                padding: 0;
            }

            .header {
                text-align: center;
                font-size: 24px;
                font-weight: bold;
                padding: 15px 0;
                background-color: #f8f8f8;
                border-bottom: 1px solid #ddd;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .user-menu {
                display: flex;
                justify-content: flex-end;
                background-color: #FFFFFF;
                padding: 0 10px;
                border: 1px solid black;
                border-top: none;
            }

            .user-menu a {
                padding: 15px 30px;
                text-decoration: none;
                color: #333;
                border-left: 1px solid black;
            }

            .user-menu a:hover {
                background-color: #ddd;
            }

            .container {
                max-width: 900px;
                margin: 20px auto;
                padding: 20px;
                background-color: #FFFFFF;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            h2 {
                text-align: left;
                color: #333;
                font-weight: bold;
                margin-bottom: 20px;
                font-size: 24px;
            }

            .section-title {
                font-weight: bold;
                margin-top: 20px;
                font-size: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }

            th, td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: center;
            }

            th {
                background-color: #333;
                color: white;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            .no-orders {
                text-align: center;
                font-size: 18px;
                color: red;
                margin-top: 10px;
            }

            .btn-black {
                background-color: black;
                color: white;
                border: none;
                padding: 10px 20px;
                cursor: pointer;
                border-radius: 10px;
            }

            .btn-black:hover {
                background-color: #333;
            }

            .order-items {
                margin-left: 20px;
                margin-top: 10px;
                border-left: 2px solid #ddd;
                padding-left: 10px;
            }

            .details-link {
                color: #007bff;
                text-decoration: none;
            }

            .details-link:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <%@include file="headerhome.jsp" %>
        <%@include file="usermenu.jsp" %>
        <div class="container">
            <h2>Your Orders</h2>
            <%            HttpSession sessionObj = request.getSession();
                user = (UsersDTO) sessionObj.getAttribute("account");

                if (user == null) {
                    response.sendRedirect("login.jsp");
                    return;
                } else {
                    List<Order> orders = (List<Order>) request.getAttribute("orders");
                    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
            %>

            <p>Welcome, <b><%= user.getFirstName()%></b>! Here are your recent orders:</p>

            <%
                List<Order> processingOrders = new ArrayList<>();
                List<Order> deliveredOrders = new ArrayList<>();
                if (orders != null) {
                    for (Order order : orders) {
                        if ("Processing".equalsIgnoreCase(order.getOrderStatus())) {
                            processingOrders.add(order);
                        } else if ("Delivered".equalsIgnoreCase(order.getOrderStatus())) {
                            deliveredOrders.add(order);
                        }
                    }
                }
            %>

        
            <% if (processingOrders.isEmpty()) { %>
            <div class="section-title">Processing Orders</div>
            <p class="no-orders">No processing orders at the moment.</p>
            <% } else { %>
            <div class="section-title">Processing Orders</div>
            <table>
                <tr>
                    <th>Order ID</th>
                    <th>Order Date</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Details</th>
                </tr>
                <% for (Order order : processingOrders) {%>
                <tr>
                    <td><%= order.getOrderId()%></td>
                    <td><%= order.getCreatedAt()%></td>
                    <td><%= order.getTotalAmount()%> USD</td>
                    <td><%= order.getOrderStatus()%></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/orderdetails?orderId=<%= order.getOrderId()%>" class="details-link">View Details</a>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } %>


            <% if (deliveredOrders.isEmpty()) { %>
            <div class="section-title">Order History</div>
            <p class="no-orders">No delivered orders in your history.</p>
            <% } else { %>
            <div class="section-title">Order History</div>
            <table>
                <tr>
                    <th>Order ID</th>
                    <th>Order Date</th>
                    <th>Total Amount</th>
                    <th>Status</th>
                    <th>Details</th>
                </tr>
                <% for (Order order : deliveredOrders) {%>
                <tr>
                    <td><%= order.getOrderId()%></td>
                    <td><%= order.getCreatedAt()%></td>
                    <td><%= order.getTotalAmount()%> USD</td>
                    <td><%= order.getOrderStatus()%></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/orderdetails?orderId=<%= order.getOrderId()%>" class="details-link">View Details</a>
                    </td>
                </tr>
                <% } %>
            </table>
            <% } %>

            <% }%>
        </div>
        <%@include file="footer.jsp" %>
    </body>
</html>