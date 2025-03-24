<%@page import="java.math.BigDecimal"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="OFS.Order.Order"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Management</title>
        <link rel="stylesheet" href="CSS/order.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    </head>
    <body>
        <div class="dashboard">
           
            <%@include file="dashBoardHeader.jsp" %>

           
            <div class="main-content">
             
                <div class="header">
                    <div class="search-bar">
                        <form action="OrderMgtController" method="GET">
                            <input type="text" name="keyword" placeholder="Search orders..." value="${param.keyword}">
                            <button type="submit">Search</button>
                            
                            <a href="OrderMgtController" class="clear-search-btn">Clear Search</a>
                        </form>
                    </div>

                    <div class="user-profile">
                        <strong><span>Admin</span></strong>
                        <a href="logout" class="a-logout">Logout</a>
                    </div>
                </div>

         
                <div class="content">
                    <h1>Order Management</h1>

                   
                    <div class="quick-actions">
    <a href="OrderMgtController?action=createOrder" class="btn btn-primary">Create Order</a>
    <form method="get" action="OrderMgtController">
   
        <select name="status" id="status-filter" class="filter-status">
            <option value="all" ${"all".equals(request.getParameter("status")) ? "selected" : ""}>All Statuses</option>
            <option value="Processing" ${"Processing".equals(request.getParameter("status")) ? "selected" : ""}>Processing</option>
            <option value="Delivered" ${"Delivered".equals(request.getParameter("status")) ? "selected" : ""}>Delivered</option>
        </select>

        
        <select name="sort" class="sort-date">
            <option value="none" <%= "none".equals(request.getParameter("sort")) ? "selected" : ""%>>Default</option>
            <option value="date_asc" <%= "date_asc".equals(request.getParameter("sort")) ? "selected" : ""%>>Date: Oldest to Newest</option>
            <option value="date_desc" <%= "date_desc".equals(request.getParameter("sort")) ? "selected" : ""%>>Date: Newest to Oldest</option>
            <option value="total_asc" <%= "total_asc".equals(request.getParameter("sort")) ? "selected" : ""%>>Total: Low to High</option>
            <option value="total_desc" <%= "total_desc".equals(request.getParameter("sort")) ? "selected" : ""%>>Total: High to Low</option>
        </select>

        <input type="hidden" name="keyword" value="${param.keyword}">
        <button type="submit" class="apply-btn">Apply</button>
    </form>
</div>

                    <div class="table-section">
                        <table border="1">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Created At</th>
                                    <th>Payment Method</th>
                                    <th>Status</th>
                                    <th>Delivery Options</th>
                                    <th>Total Amount</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Order> orders = (List<Order>) request.getAttribute("orders");
                                    if (orders != null && !orders.isEmpty()) {
                                        for (Order order : orders) {
                                %>
                                <tr>
                                    <td><%= order.getOrderId()%></td>
                                    <td><%= order.getUsers().getFirstName() + " " + order.getUsers().getLastName()%></td>
                                    <td><%= DateTimeFormatter.ofPattern("dd/MM/yyyy").format(order.getCreatedAt())%></td>
                                    <td><%= order.getPaymentMethod()%></td>
                                    <td><%= order.getOrderStatus()%></td>
                                    <td><%= order.getDeliveryOptions()%></td>
                                    <td>$<%= order.getTotalAmount()%></td>
                                    <td>
                                        <a href="OrderMgtController?action=viewOrders&orderId=<%= order.getOrderId()%>" class="btn btn-info">View Order</a>
                                        <a href="OrderMgtController?action=edit&orderId=<%= order.getOrderId()%>" class="btn btn-primary">Edit</a>
                                        <a href="OrderMgtController?action=deleteOrder&orderId=<%= order.getOrderId()%>" 
                                           class="btn btn-danger delete-link">Delete</a>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="8">No orders found.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>

      
                        <%
                            if (request.getAttribute("currentPage") != null && request.getAttribute("totalPages") != null) {
                                int currentPage = (int) request.getAttribute("currentPage");
                                int totalPages = (int) request.getAttribute("totalPages");
                                String status = request.getParameter("status") != null ? request.getParameter("status") : "all";
                                String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "none";
                                String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
                        %>
                        <div class="pagination">
                            <% if (currentPage > 1) {%>
                            <a href="?status=<%= status%>&sort=<%= sort%>&page=<%= currentPage - 1%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>">Previous</a>
                            <% }%>

                            <span>Page <%= currentPage%> of <%= totalPages%></span>

                            <% if (currentPage < totalPages) {%>
                            <a href="?status=<%= status%>&sort=<%= sort%>&page=<%= currentPage + 1%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8")%>">Next</a>
                            <% } %>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

    
        <div class="modal" id="orderDetailsModal">
            <div class="modal-content">
                <span class="close">×</span>
                <h2>Order Details</h2>
                <div class="order-info">
                    <p><strong>Order ID:</strong> <span id="orderId"></span></p>
                    <p><strong>Customer:</strong> <span id="customerName"></span></p>
                    <p><strong>Date:</strong> <span id="orderDate"></span></p>
                    <p><strong>Payment Method:</strong> <span id="paymentMethod"></span></p>
                    <p><strong>Status:</strong> <span id="orderStatus"></span></p>
                    <p><strong>Total:</strong> <span id="orderTotal"></span></p>
                </div>
                <h3>Order Items</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Product Name</th>
                            <th>Size</th>
                            <th>Color</th>
                            <th>Quantity</th>
                            <th>Price</th>
                        </tr>
                    </thead>
                    <tbody id="orderItemsTable">
                        
                    </tbody>
                </table>
            </div>
        </div>

    
        <div class="notification">
            <span>Order has been updated successfully!</span>
        </div>

        <script>
            document.querySelectorAll('.delete-link').forEach(link => {
                link.addEventListener('click', function (event) {
                    event.preventDefault();
                    if (confirm('Are you sure you want to delete this order?')) {
                        fetch(this.href, {method: 'GET'})
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        alert('Order deleted successfully!');
                                        this.closest('tr').remove();
                                    } else {
                                        alert('Failed to delete order!');
                                    }
                                })
                                .catch(error => console.error('Error:', error));
                    }
                });
            });

            // Sample data for order details
            const orders = {
                1001: {
                    customer: "John Doe",
                    date: "2023-10-01",
                    paymentMethod: "Credit Card",
                    status: "Shipped",
                    total: "$120.00",
                    items: [
                        {productName: "Men's T-Shirt", size: "M", color: "Black", quantity: 2, price: "$25.00"},
                        {productName: "Women's Dress", size: "S", color: "Red", quantity: 1, price: "$45.00"}
                    ]
                },
                1002: {
                    customer: "Jane Smith",
                    date: "2023-10-02",
                    paymentMethod: "Cash on Delivery",
                    status: "Pending",
                    total: "$80.00",
                    items: [
                        {productName: "Unisex Hoodie", size: "L", color: "Gray", quantity: 1, price: "$60.00"}
                    ]
                },
                1003: {
                    customer: "Alice Johnson",
                    date: "2023-10-03",
                    paymentMethod: "Cash on Delivery",
                    status: "Cancelled",
                    total: "$200.00",
                    items: [
                        {productName: "Men's T-Shirt", size: "L", color: "White", quantity: 3, price: "$25.00"},
                        {productName: "Women's Dress", size: "M", color: "Blue", quantity: 2, price: "$45.00"}
                    ]
                }
            };

            // Modal functionality
            const modal = document.getElementById('orderDetailsModal');
            const closeModal = document.querySelector('.close');
            const viewButtons = document.querySelectorAll('.btn-info');

            viewButtons.forEach(button => {
                button.addEventListener('click', () => {
                    const orderId = button.closest('tr').querySelector('td').textContent;
                    const order = orders[orderId];
                    if (order) {
                        document.getElementById('orderId').textContent = orderId;
                        document.getElementById('customerName').textContent = order.customer;
                        document.getElementById('orderDate').textContent = order.date;
                        document.getElementById('paymentMethod').textContent = order.paymentMethod;
                        document.getElementById('orderStatus').textContent = order.status;
                        document.getElementById('orderTotal').textContent = order.total;

                        const orderItemsTable = document.getElementById('orderItemsTable');
                        orderItemsTable.innerHTML = order.items.map(item => `
                            <tr>
                                <td>${item.productName}</td>
                                <td>${item.size}</td>
                                <td>${item.color}</td>
                                <td>${item.quantity}</td>
                                <td>${item.price}</td>
                            </tr>
                        `).join('');

                        modal.style.display = 'block';
                    }
                });
            });

            closeModal.addEventListener('click', () => {
                modal.style.display = 'none';
            });

            window.addEventListener('click', (event) => {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });

            // Show notification
            function showNotification(message) {
                const notification = document.querySelector('.notification');
                notification.querySelector('span').textContent = message;
                notification.classList.add('show');
                setTimeout(() => notification.classList.remove('show'), 3000);
            }
        </script>
    </body>
</html>