<%@page import="OFS.Product.ProductVariant"%>
<%@page import="OFS.Product.ProductImages"%>
<%@page import="java.util.List"%>
<%@page import="OFS.Product.Product"%>
<%@page import="OFS.Product.ProductDAO"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" pageEncoding="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Management</title>
        <link rel="stylesheet" href="CSS/product.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

    </head>
    <body>
        <div class="dashboard">
            
            <%@include file="dashBoardHeader.jsp" %>

           
            <div class="main-content">
               
                <div class="header">
                    <div class="search-bar">
                        <form action="ProductMgtController" method="get">
                            <input type="text" name="keyword" placeholder="Search products..." value="${param.keyword}">
                            <button type="submit">Search</button>
                            <a href="ProductMgtController" class="clear-search-btn">Clear Search</a>
                        </form>
                    </div>

                    <div class="user-profile">
                        <strong><span>Admin</span></strong>
                        <a href="logout" class="a-logout">Logout</a>
                    </div>
                </div>

                
                <div class="content">
                    <h1>Product Management</h1>
                    
                    <div class="quick-actions">
                        <form action="addCategory.jsp" method="get">
                            <input type="submit" value="Add Product">
                        </form>
                        <form method="get" action="ProductMgtController">
                            <select name="category" id="category-filter">
                                <option value="all" ${"all".equals(request.getParameter("category")) ? "selected" : ""}>All Categories</option>
                                <option value="Women's Clothing" ${"Women's Clothing".equals(request.getParameter("category")) ? "selected" : ""}>Women's Clothing</option>
                                <option value="Women's Bags" ${"Women's Bags".equals(request.getParameter("category")) ? "selected" : ""}>Women's Bags</option>
                                <option value="Women's Accessories" ${"Women's Accessories".equals(request.getParameter("category")) ? "selected" : ""}>Women's Accessories</option>
                                <option value="Perfume" ${"Perfume".equals(request.getParameter("category")) ? "selected" : ""}>Perfume</option>
                                <option value="Men's Clothing" ${"Men's Clothing".equals(request.getParameter("category")) ? "selected" : ""}>Men's Clothing</option>
                                <option value="Men's Bags" ${"Men's Bags".equals(request.getParameter("category")) ? "selected" : ""}>Men's Bags</option>
                                <option value="Men's Accessories" ${"Men's Accessories".equals(request.getParameter("category")) ? "selected" : ""}>Men's Accessories</option>
                                <option value="Men's Sneakers" ${"Men's Sneakers".equals(request.getParameter("category")) ? "selected" : ""}>Men's Sneakers</option>
                            </select>

                            <select name="sort" class="sort-option">
                                <option value="none" <%= "none".equals(request.getParameter("sort")) ? "selected" : ""%>>Default</option>
                                <option value="asc" <%= "asc".equals(request.getParameter("sort")) ? "selected" : ""%>>Price: Low to High</option>
                                <option value="desc" <%= "desc".equals(request.getParameter("sort")) ? "selected" : ""%>>Price: High to Low</option>
                                <option value="category_asc" <%= "category_asc".equals(request.getParameter("sort")) ? "selected" : ""%>>Category: A to Z</option>
                                <option value="category_desc" <%= "category_desc".equals(request.getParameter("sort")) ? "selected" : ""%>>Category: Z to A</option>
                            </select>

                            <input type="hidden" name="keyword" value="${param.keyword}">
                            <button type="submit">Apply</button>
                        </form>
                    </div>

                    <% if (request.getParameter("keyword") != null && !request.getParameter("keyword").trim().isEmpty()) {%>
                    <p>Search results for: "<%= request.getParameter("keyword")%>"</p>
                    <% } %>

                    
                    <div class="table-section">
                        <table border="1">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Brand</th>
                                    <th>Material</th>
                                    <th>Base Price</th>
                                    <th>Image</th>
                                    <th>Variants</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Product> productList = (List<Product>) request.getAttribute("products");
                                    if (productList != null && !productList.isEmpty()) {
                                        for (Product product : productList) {
                                %>
                                <tr>
                                    <td><%= product.getProductId()%></td>
                                    <td><%= product.getName()%></td>
                                    <td><%= product.getCategory().getName()%></td>
                                    <td><%= product.getBrand()%></td>
                                    <td><%= product.getMaterial()%></td>
                                    <td>$<%= product.getBasePrice()%></td>
                                    <td>
                                        <img src="<%= product.getProductImage() != null ? product.getProductImage().getImageUrl() : "https://via.placeholder.com/50"%>" width="50">
                                    </td>
                                    <td>
                                        <a href="ProductMgtController?action=viewVariants&productId=<%= product.getProductId()%>" class="btn btn-primary">
                                            View Variants
                                        </a>
                                    </td>
                                    <td>
                                        <a href="ProductMgtController?action=edit&productId=<%= product.getProductId()%>" class="edit-btn">Edit</a>
                                        <a href="ProductMgtController?action=deleteProduct&productId=<%= product.getProductId()%>" class="delete-link" onclick="return confirm('Are you sure you want to delete this product?');">Delete</a>
                                    </td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr>
                                    <td colspan="9">No products found.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>

                        <style>
                            a.delete-link {
                                color: red;
                                text-decoration: none;
                                font-weight: bold;
                            }

                            a.delete-link:hover {
                                text-decoration: underline;
                            }

                            .btn-primary {
                                display: inline-block;
                                background-color: #007bff;
                                color: white;
                                padding: 6px 12px;
                                border: none;
                                border-radius: 5px;
                                font-size: 14px;
                                font-weight: bold;
                                text-align: center;
                                text-decoration: none;
                                cursor: pointer;
                                transition: background-color 0.3s;
                            }

                            .btn-primary:hover {
                                background-color: #0056b3;
                            }
                        </style>

                        <!-- Pagination -->
                        <%
                            if (request.getAttribute("currentPage") != null && request.getAttribute("totalPages") != null) {
                                int currentPage = (int) request.getAttribute("currentPage");
                                int totalPages = (int) request.getAttribute("totalPages");
                                String category = request.getParameter("category") != null ? request.getParameter("category") : "all";
                                String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "none";
                                String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
                        %>
                        <div class="pagination">
                            <% if (currentPage > 1) {%>
                            <a href="?category=<%= category%>&sort=<%= sort%>&page=<%= currentPage - 1%>&keyword=<%= keyword%>">Previous</a>
                            <% }%>

                            <span>Page <%= currentPage%> of <%= totalPages%></span>

                            <% if (currentPage < totalPages) {%>
                            <a href="?category=<%= category%>&sort=<%= sort%>&page=<%= currentPage + 1%>&keyword=<%= keyword%>">Next</a>
                            <% } %>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <script>
            
            function viewProduct(productId) {
                alert(`Viewing product details for ID: ${productId}`);
            }

            function editProduct(productId) {
                alert(`Editing product with ID: ${productId}`);
            }

            function deleteProduct(productId) {
                alert(`Deleting product with ID: ${productId}`);
            }

            
            const modal = document.getElementById('variantsModal');
            const closeModal = document.querySelector('.close');
            const viewVariantsButtons = document.querySelectorAll('.view-variants-btn');

            if (viewVariantsButtons) {
                viewVariantsButtons.forEach(button => {
                    button.addEventListener('click', () => {
                        modal.style.display = 'block';
                    });
                });
            }

            if (closeModal) {
                closeModal.addEventListener('click', () => {
                    modal.style.display = 'none';
                });
            }

            window.addEventListener('click', (event) => {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });

            
            document.querySelectorAll('.view-btn').forEach(button => {
                button.addEventListener('click', () => viewProduct(button.closest('tr').querySelector('td').textContent));
            });

            document.querySelectorAll('.edit-btn').forEach(button => {
                button.addEventListener('click', () => editProduct(button.closest('tr').querySelector('td').textContent));
            });

            document.querySelectorAll('.delete-btn').forEach(button => {
                button.addEventListener('click', () => deleteProduct(button.closest('tr').querySelector('td').textContent));
            });

            document.querySelector('.add-product-btn')?.addEventListener('click', () => {
                showNotification("S?n ph?m ?ã ???c thêm thành công!");
            });
        </script>
    </body>
</html>