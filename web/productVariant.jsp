<%-- 
    Document   : ProductVariant
    Created on : Mar 15, 2025, 8:04:52 PM
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="OFS.Product.ProductVariant"%>
<%@page import="OFS.Product.Product"%>

<%
    Product product = (Product) request.getAttribute("product");
    List<ProductVariant> variants = (List<ProductVariant>) request.getAttribute("variants");
    if (product == null) {
%>
<p style="color: red;">Error: Product not found!</p>
<a href="productmanagement.jsp">Go back</a>
<%
        return;
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" pageEncoding="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Management</title>
<!--        <link rel="stylesheet" href="CSS/product.css">-->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            /* Thiết lập chung */
            body {
                margin: 0;
                font-family: 'Roboto', sans-serif;
                background-color: #f7f9fc;
                color: #333;
            }

            /* Bố cục Dashboard */
            .dashboard {
                display: flex;
                min-height: 100vh;
            }

            /* Thanh bên (Sidebar) */
            .sidebar {
                width: 260px;
                background-color: #ffffff;
                padding: 30px 20px;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05); 
                transition: width 0.3s ease;
            }

            .sidebar .logo {
                font-size: 26px;
                font-weight: 700;
                color: #2c3e50; 
                margin-bottom: 40px;
                text-align: center;
            }

            .sidebar ul {
                list-style: none;
                padding: 0;
            }

            .sidebar ul li {
                margin: 25px 0;
            }

            .sidebar ul li a {
                color: #34495e; 
                text-decoration: none;
                font-size: 16px;
                display: flex;
                align-items: center;
                padding: 10px;
                border-radius: 8px;
                transition: background-color 0.3s ease;
            }

            .sidebar ul li a:hover {
                background-color: #ecf0f1; 
            }

            .sidebar ul li a i {
                margin-right: 12px;
                color: #7f8c8d; 
            }

            .sidebar ul li a.active {
                font-weight: bold;
                background-color: #ecf0f1;
            }

            /* Nội dung chính */
            .main-content {
                flex: 1;
                background-color: #f7f9fc;
                padding: 20px;
            }

            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 20px;
                background-color: #ffffff;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                border-radius: 10px;
                margin-bottom: 20px;
            }

            /* Thanh tìm kiếm */
            .search-bar form {
                display: flex;
                align-items: center;
                gap: 10px; 
            }

            /* Ô nhập liệu tìm kiếm */
            .search-bar input {
                padding: 12px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                background-color: #ffffff;
                color: #333;
                font-size: 14px;
                width: 300px; 
                transition: border-color 0.3s ease;
            }

            .search-bar input:focus {
                border-color: #3498db;
                outline: none;
            }

            /* Nút Search */
            .search-bar button {
                padding: 10px 20px;
                background-color: #3498db;
                color: #ffffff;
                border: none;
                border-radius: 8px;
                font-family: 'Roboto', sans-serif;
                font-size: 14px;
                font-weight: 500;
                width: 100px; 
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .search-bar button:hover {
                background-color: #2980b9;
            }

            /* Nút Clear Search */
            .clear-search-btn {
                padding: 10px 20px;
                background-color: #3498db;
                color: #ffffff;
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
                background-color: #2980b9;
            }

            .user-profile {
                display: flex;
                align-items: center;
                gap: 15px;
                font-size: 15px;
                color: #2c3e50;
            }

            .user-profile button {
                padding: 8px 16px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                color: #34495e;
                font-weight: 500;
                background-color: transparent;
                cursor: pointer;
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            .user-profile button:hover {
                background-color: #ecf0f1;
                color: #2c3e50;
            }

            .user-profile i {
                color: #7f8c8d;
            }

            /* Nội dung */
            .content {
                padding: 20px;
            }

            h2 {
                font-size: 28px;
                font-weight: 500;
                margin-bottom: 25px;
                color: #2c3e50;
            }

            /* Phần bảng */
            .table-section {
                background-color: #ffffff;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                margin-bottom: 30px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
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

            /* Kiểu cho các nút trong bảng */
            .edit-btn {
                padding: 6px 12px;
                background-color: #28a745;
                color: #ffffff;
                border: none;
                border-radius: 5px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s ease;
                margin-right: 5px;
            }

            .edit-btn:hover {
                background-color: #218838;
            }

            .delete-btn {
                padding: 6px 12px;
                background-color: #dc3545;
                color: #ffffff;
                border: none;
                border-radius: 5px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .delete-btn:hover {
                background-color: #c82333;
            }

            /* Nút Back to Product List */
            a.btn-primary {
                display: inline-block;
                background-color: #3498db;
                color: #ffffff;
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-family: 'Roboto', sans-serif;
                font-size: 14px;
                font-weight: 500;
                text-align: center;
                text-decoration: none;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            a.btn-primary:hover {
                background-color: #2980b9;
            }

            /* Thông báo lỗi */
            p[style*="color: red"] {
                color: #dc3545; 
                font-size: 14px;
                margin-bottom: 15px;
            }

            /* Liên kết Go back */
            a:not(.btn-primary) {
                display: inline-block;
                padding: 8px 16px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                color: #34495e;
                font-weight: 500;
                text-decoration: none;
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            a:not(.btn-primary):hover {
                background-color: #ecf0f1;
                color: #2c3e50;
            }

            /* Thiết kế responsive */
            @media (max-width: 768px) {
                .dashboard {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                    height: auto;
                    padding: 20px;
                }

                .main-content {
                    padding: 10px;
                }

                .header {
                    flex-direction: column;
                    gap: 15px;
                }

                .search-bar form {
                    flex-direction: column;
                    gap: 10px;
                }

                .search-bar input {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard">
       
            <%@include file="dashBoardHeader.jsp" %>

      
            <div class="main-content">
       
                <div class="header">
                    <div class="search-bar">
                        <input type="text" placeholder="Search products...">
                    </div>
                    <div class="user-profile">
                        <i class="fas fa-bell"></i>
                        <span>Admin</span>
                        <i class="fas fa-caret-down"></i>
                        <button onclick="logout()">Logout</button>
                    </div>
                </div>

     
                <div class="content">
                    <% if (product != null) {%>
                    <h2>Product Name: <%= product.getName()%></h2>
                    <% } %>

                    <div class="table-section">
                        <table border="1">
                            <thead>
                                <tr>
                                    <th>Variant ID</th>
                                    <th>Size</th>
                                    <th>Color</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (variants != null && !variants.isEmpty()) {
                                        for (ProductVariant variant : variants) {
                                %>
                                <tr>
                                    <td><%= variant.getVariantId()%></td>
                                    <td><%= variant.getSize()%></td>
                                    <td><%= variant.getColor()%></td>
                                    <td>$<%= variant.getPrice()%></td>
                                    <td><%= variant.getStockQuantity()%></td>
                                    <td>
                               
                                        <form action="ProductMgtController" method="GET" style="display: inline;">
                                            <input type="hidden" name="action" value="editVariant">
                                            <input type="hidden" name="variantId" value="<%= variant.getVariantId()%>">
                                            <button type="submit" class="edit-btn">Edit</button>
                                        </form>


                                  
                                        <form action="ProductMgtController" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="deleteVariant">
                                            <input type="hidden" name="variantId" value="<%= variant.getVariantId()%>">
                                            <input type="hidden" name="productId" value="<%= product.getProductId()%>"> <!-- ✅ Thêm dòng này -->
                                            <button type="submit" class="delete-btn">Delete</button>
                                        </form>

                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="6">No variants found.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>

                        <br>
                        <a href="ProductMgtController" class="btn btn-primary">Back to Product List</a>

                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

