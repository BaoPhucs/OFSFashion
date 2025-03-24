<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="OFS.Order.Order"%>
<%@page import="OFS.Product.Product"%>
<%@page import="OFS.Users.UsersDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>

        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="CSS/stylesmn.css">
        <style>
            .clear-search-btn {
                padding: 10px 20px; 
                background-color: #F7F9FC; 
                color: grey; 
                text-decoration: none;
                border-radius: 8px; 
                font-family: 'Roboto', sans-serif; 
                font-size: 14px; 
                font-weight: 500; 
                width: 100px; 
                border: none; 
                transition: background-color 0.3s ease;
                text-align: center;
            }

            .clear-search-btn:hover {
                background-color: #e5e5e5;
            }

            .search-results {
                margin-top: 20px;
                padding: 10px;
                background-color: white;
                margin-bottom: 20px;
            }

            .search-results h2 {
                margin-bottom: 20px;

            }


        </style>
    </head>
    <body>
        <div class="dashboard">
            <%@include file="dashBoardHeader.jsp"%>

            <div class="main-content">
                <div class="header">
                    <div class="search-bar">
                        <form action="DashBoardController" method="POST">
                            <div class="search-row">
                                <input type="text" name="keyword" placeholder="Search..." value="${param.keyword}">
                                <button type="submit">Search</button>
                                <a href="DashBoardController" class="clear-search-btn">Clear Search</a>
                            </div>
                            <div class="filter-options">
                                <label><input type="radio" name="filter" value="users" <%= "users".equals(request.getParameter("filter")) ? "checked" : ""%>> Users</label>
                                <label><input type="radio" name="filter" value="orders" <%= "orders".equals(request.getParameter("filter")) ? "checked" : ""%>> Orders</label>
                                <label><input type="radio" name="filter" value="products" <%= "products".equals(request.getParameter("filter")) ? "checked" : ""%>> Products</label>
                            </div>
                        </form>
                    </div>

                    <div class="user-profile">
                        <strong><span>Admin</span></strong>
                        <a href="logout" class="a-logout">Logout</a>
                    </div>
                </div>

                <div class="content">
                    <h1>Dashboard</h1>
                    <div class="stats">
                        <%
                            Integer totalProductsObj = (Integer) request.getAttribute("totalProducts");
                            int totalProducts = (totalProductsObj != null) ? totalProductsObj : 0;

                            Integer totalOrdersObj = (Integer) request.getAttribute("totalOrders");
                            int totalOrders = (totalOrdersObj != null) ? totalOrdersObj : 0;

                            Integer totalUsersObj = (Integer) request.getAttribute("totalUsers");
                            int totalUsers = (totalUsersObj != null) ? totalUsersObj : 0;

                            Double totalRevenueObj = (Double) request.getAttribute("totalRevenue");
                            double totalRevenue = (totalRevenueObj != null) ? totalRevenueObj : 0.0;

                            Integer deliveredOrdersObj = (Integer) request.getAttribute("deliveredOrders");
                            int deliveredOrders = (deliveredOrdersObj != null) ? deliveredOrdersObj : 0;

                            List<Order> recentOrders = (List<Order>) request.getAttribute("recentOrders");
                            if (recentOrders == null) {
                                recentOrders = new ArrayList<>();
                            }
                        %>

                        <div class="stat-card"><h2>Total Products</h2><p><%= totalProducts%></p></div>
                        <div class="stat-card"><h2>Total Orders</h2><p><%= totalOrders%></p></div>
                        <div class="stat-card"><h2>Total Users</h2><p><%= totalUsers%></p></div>
                        <div class="stat-card"><h2>Revenue</h2><p>$<%= totalRevenue%></p></div>
                        <div class="stat-card"><h2>Delivered Orders</h2><p><%= deliveredOrders%></p></div>
                    </div>

                    <div class="table-section">
                        <h2>Recent Orders</h2>
                        <div class="table-actions">
                            <form id="status-filter-form" action="DashBoardController" method="GET">
                                <input type="hidden" name="recentOrderPage" value="${param.recentOrderPage != null ? param.recentOrderPage : 1}">
                                <input type="hidden" name="keyword" value="${param.keyword}">
                                <input type="hidden" name="filter" value="${param.filter}">
                                <input type="hidden" name="userPage" value="${param.userPage != null ? param.userPage : 1}">
                                <input type="hidden" name="orderPage" value="${param.orderPage != null ? param.orderPage : 1}">
                                <input type="hidden" name="productPage" value="${param.productPage != null ? param.productPage : 1}">
                                <select id="status-filter" name="statusFilter" onchange="this.form.submit()">
                                    <option value="all" <%= "all".equals(request.getParameter("statusFilter")) ? "selected" : ""%>>All Status</option>
                                    <option value="processing" <%= "processing".equals(request.getParameter("statusFilter")) ? "selected" : ""%>>Processing</option>
                                    <option value="delivered" <%= "delivered".equals(request.getParameter("statusFilter")) ? "selected" : ""%>>Delivered</option>
                                </select>
                            </form>
                        </div>

                        <table>
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Date</th>
                                    <th>Customer</th>
                                    <th>Status</th>
                                    <th>Payment Method</th>
                                    <th>Total</th>
                                </tr>
                            </thead>
                            <tbody id="order-table-body">
                                <%
                                    recentOrders = (List<Order>) request.getAttribute("recentOrders");
                                    if (recentOrders != null) {
                                        for (Order order : recentOrders) {
                                %>
                                <tr data-status="<%= order.getOrderStatus().toLowerCase()%>" data-date="<%= order.getCreatedAt()%>">
                                    <td>#<%= order.getOrderId()%></td>
                                    <td><%= order.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))%></td>
                                    <td><%= order.getUsers().getFirstName() + " " + order.getUsers().getLastName()%></td>
                                    <td><%= order.getOrderStatus()%></td>
                                    <td><%= order.getPaymentMethod()%></td>
                                    <td>$<%= order.getTotalAmount().setScale(2, BigDecimal.ROUND_HALF_UP)%></td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                        <div class="pagination">
                            <%
                                if (request.getAttribute("currentRecentOrderPage") != null && request.getAttribute("totalRecentOrderPages") != null) {
                                    int currentRecentOrderPage = (int) request.getAttribute("currentRecentOrderPage");
                                    int totalRecentOrderPages = (int) request.getAttribute("totalRecentOrderPages");
                                    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
                                    String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
                                    String statusFilter = request.getParameter("statusFilter") != null ? request.getParameter("statusFilter") : "all";
                                    int userPage = request.getParameter("userPage") != null ? Integer.parseInt(request.getParameter("userPage")) : 1;
                                    int orderPage = request.getParameter("orderPage") != null ? Integer.parseInt(request.getParameter("orderPage")) : 1;
                                    int productPage = request.getParameter("productPage") != null ? Integer.parseInt(request.getParameter("productPage")) : 1;
                            %>
                            <% if (currentRecentOrderPage > 1) {%>
                            <a href="DashBoardController?recentOrderPage=<%= currentRecentOrderPage - 1%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>&filter=<%= filter%>&statusFilter=<%= statusFilter%>&userPage=<%= userPage%>&orderPage=<%= orderPage%>&productPage=<%= productPage%>">Previous</a>
                            <% }%>
                            <span>Page <%= currentRecentOrderPage%> of <%= totalRecentOrderPages%></span>
                            <% if (currentRecentOrderPage < totalRecentOrderPages) {%>
                            <a href="DashBoardController?recentOrderPage=<%= currentRecentOrderPage + 1%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>&filter=<%= filter%>&statusFilter=<%= statusFilter%>&userPage=<%= userPage%>&orderPage=<%= orderPage%>&productPage=<%= productPage%>">Next</a>
                            <% } %>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <div class="search-results">
                        <% List<Order> orders = (List<Order>) request.getAttribute("orders"); %>
                        <% List<UsersDTO> users = (List<UsersDTO>) request.getAttribute("users"); %>
                        <% List<Product> products = (List<Product>) request.getAttribute("products"); %>

                        <% if (orders != null && !orders.isEmpty()) { %>
                        <h2>Order Results</h2>
                        <table>
                            <thead>
                                <tr><th>Order ID</th><th>Date</th><th>Customer</th><th>Status</th><th>Payment Method</th><th>Total</th></tr>
                            </thead>
                            <tbody>
                                <% for (Order order : orders) {%>
                                <tr>
                                    <td>#<%= order.getOrderId()%></td>
                                    <td><%= order.getCreatedAt().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))%></td>
                                    <td><%= order.getUsers().getFirstName() + " " + order.getUsers().getLastName()%></td>
                                    <td><%= order.getOrderStatus()%></td>
                                    <td><%=order.getPaymentMethod()%></td>
                                    <td>$<%= order.getTotalAmount()%></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                       
                        <div class="pagination">
                            <%
                                if (request.getAttribute("currentOrderPage") != null && request.getAttribute("totalOrderPages") != null) {
                                    int currentOrderPage = (int) request.getAttribute("currentOrderPage");
                                    int totalOrderPages = (int) request.getAttribute("totalOrderPages");
                                    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
                                    String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
                                    int userPage = request.getParameter("userPage") != null ? Integer.parseInt(request.getParameter("userPage")) : 1;
                                    int productPage = request.getParameter("productPage") != null ? Integer.parseInt(request.getParameter("productPage")) : 1;
                                    int recentOrderPage = request.getParameter("recentOrderPage") != null ? Integer.parseInt(request.getParameter("recentOrderPage")) : 1;
                            %>
                            <% if (currentOrderPage > 1) {%>
                            <a href="DashBoardController?recentOrderPage=<%= recentOrderPage%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>&filter=<%= filter%>&userPage=<%= userPage%>&orderPage=<%= currentOrderPage - 1%>&productPage=<%= productPage%>">Previous</a>
                            <% }%>
                            <span>Page <%= currentOrderPage%> of <%= totalOrderPages%></span>
                            <% if (currentOrderPage < totalOrderPages) {%>
                            <a href="DashBoardController?recentOrderPage=<%= recentOrderPage%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>&filter=<%= filter%>&userPage=<%= userPage%>&orderPage=<%= currentOrderPage + 1%>&productPage=<%= productPage%>">Next</a>
                            <% } %>
                            <%
                                }
                            %>
                        </div>
                        <% } %>

                        <% if (users != null && !users.isEmpty()) { %>
                        <h2>User Results</h2>
                        <table>
                            <thead>
                                <tr><th>User ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Address</th></tr>
                            </thead>
                            <tbody>
                                <% for (UsersDTO user : users) {%>
                                <tr>
                                    <td>#<%= user.getUserId()%></td>
                                    <td><%= user.getFirstName()%> <%= user.getLastName()%></td>
                                    <td><%= user.getEmail()%></td>
                                    <td><%= user.getPhone()%></td>
                                    <td><%= user.getAddress()%></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                  
                        <div class="pagination">
                            <%
                                if (request.getAttribute("currentUserPage") != null && request.getAttribute("totalUserPages") != null) {
                                    int currentUserPage = (int) request.getAttribute("currentUserPage");
                                    int totalUserPages = (int) request.getAttribute("totalUserPages");
                                    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
                                    String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
                                    int orderPage = request.getParameter("orderPage") != null ? Integer.parseInt(request.getParameter("orderPage")) : 1;
                                    int productPage = request.getParameter("productPage") != null ? Integer.parseInt(request.getParameter("productPage")) : 1;
                                    int recentOrderPage = request.getParameter("recentOrderPage") != null ? Integer.parseInt(request.getParameter("recentOrderPage")) : 1;
                            %>
                            <% if (currentUserPage > 1) {%>
                            <a href="DashBoardController?recentOrderPage=<%= recentOrderPage%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>&filter=<%= filter%>&userPage=<%= currentUserPage - 1%>&orderPage=<%= orderPage%>&productPage=<%= productPage%>">Previous</a>
                            <% }%>
                            <span>Page <%= currentUserPage%> of <%= totalUserPages%></span>
                            <% if (currentUserPage < totalUserPages) {%>
                            <a href="DashBoardController?recentOrderPage=<%= recentOrderPage%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>&filter=<%= filter%>&userPage=<%= currentUserPage + 1%>&orderPage=<%= orderPage%>&productPage=<%= productPage%>">Next</a>
                            <% } %>
                            <%
                                }
                            %>
                        </div>
                        <% } %>

                        <% if (products != null && !products.isEmpty()) { %>
                        <h2>Product Results</h2>
                        <table>
                            <thead>
                                <tr><th>Product ID</th><th>Name</th><th>Brand</th><th>Category</th><th>Material</th><th>Price</th></tr>
                            </thead>
                            <tbody>
                                <% for (Product product : products) {%>
                                <tr>
                                    <td>#<%= product.getProductId()%></td>
                                    <td><%= product.getName()%></td>
                                    <td><%= product.getBrand()%></td>
                                    <td><%= product.getCategory().getName()%></td>
                                    <td><%= product.getMaterial()%></td>
                                    <td>$<%= product.getBasePrice()%></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    
                        <div class="pagination">
                            <%
                                if (request.getAttribute("currentProductPage") != null && request.getAttribute("totalProductPages") != null) {
                                    int currentProductPage = (int) request.getAttribute("currentProductPage");
                                    int totalProductPages = (int) request.getAttribute("totalProductPages");
                                    String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
                                    String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "";
                                    int userPage = request.getParameter("userPage") != null ? Integer.parseInt(request.getParameter("userPage")) : 1;
                                    int orderPage = request.getParameter("orderPage") != null ? Integer.parseInt(request.getParameter("orderPage")) : 1;
                                    int recentOrderPage = request.getParameter("recentOrderPage") != null ? Integer.parseInt(request.getParameter("recentOrderPage")) : 1;
                            %>
                            <% if (currentProductPage > 1) {%>
                            <a href="DashBoardController?recentOrderPage=<%= recentOrderPage%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>&filter=<%= filter%>&userPage=<%= userPage%>&orderPage=<%= orderPage%>&productPage=<%= currentProductPage - 1%>">Previous</a>
                            <% }%>
                            <span>Page <%= currentProductPage%> of <%= totalProductPages%></span>
                            <% if (currentProductPage < totalProductPages) {%>
                            <a href="DashBoardController?recentOrderPage=<%= recentOrderPage%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>&filter=<%= filter%>&userPage=<%= userPage%>&orderPage=<%= orderPage%>&productPage=<%= currentProductPage + 1%>">Next</a>
                            <% } %>
                            <%
                                }
                            %>
                        </div>
                        <% } %>

                        <% if ((orders == null || orders.isEmpty()) && (users == null || users.isEmpty()) && (products == null || products.isEmpty()) && request.getParameter("keyword") != null && !request.getParameter("keyword").trim().isEmpty()) { %>
                        <p class="no-result">No results found.</p>
                        <% }%>
                    </div>
                </div>
            </div>
        </div>

        <div class="notification">
            <span>Product has been successfully added!</span>
        </div>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
               
                document.getElementById("sort-date").addEventListener("click", function () {
                    const tableBody = document.getElementById("order-table-body");
                    const rows = Array.from(tableBody.getElementsByTagName("tr"));
                    rows.sort((a, b) => new Date(b.dataset.date) - new Date(a.dataset.date));
                    tableBody.innerHTML = "";
                    rows.forEach(row => tableBody.appendChild(row));
                });

                function showOrderDetails(orderId) {
                    alert(`Order details: ${orderId}`);
                }

                function logout() {
                    alert("Logout successful!");
                }
            });
        </script>
    </body>
</html>