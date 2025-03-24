<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="OFS.Product.Product, OFS.Category.CategoryDTO, java.util.List" %>

<%
    Product product = (Product) request.getAttribute("product");
    List<CategoryDTO> categories = (List<CategoryDTO>) request.getAttribute("categories");
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Update Product</title>
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
            }

            /* Form */
            form {
                background-color: #ffffff;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                max-width: 500px; 
                margin: 0 auto; 
            }

            /* Nhãn và ô nhập liệu */
            label {
                display: block;
                color: #34495e;
                font-size: 14px;
                margin-bottom: 5px;
                margin-top: 15px;
            }

            input[type="text"],
            input[type="number"],
            textarea,
            select {
                padding: 10px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                background-color: #ffffff;
                color: #333;
                font-size: 14px;
                width: 100%;
                box-sizing: border-box; 
                transition: border-color 0.3s ease;
            }

            input[type="text"]:focus,
            input[type="number"]:focus,
            textarea:focus,
            select:focus {
                border-color: #3498db;
                outline: none;
            }

            /* Textarea */
            textarea {
                resize: vertical; 
                height: 100px; 
            }

            /* Select */
            select {
                cursor: pointer;
            }

            /* Nút Update */
            button[type="submit"] {
                padding: 10px 20px;
                background-color: #3498db;
                color: #ffffff;
                border: none;
                border-radius: 8px;
                font-family: 'Roboto', sans-serif;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s ease;
                margin-top: 20px;
                width: 100%; 
            }

            button[type="submit"]:hover {
                background-color: #2980b9;
            }

            /* Liên kết Back to Product List */
            a {
                display: inline-block;
                padding: 8px 16px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                color: #34495e;
                font-weight: 500;
                text-decoration: none;
                transition: background-color 0.3s ease, color 0.3s ease;
                margin-top: 20px;
                text-align: center;
                width: 100%;
                max-width: 500px; 
                box-sizing: border-box;
            }

            a:hover {
                background-color: #ecf0f1;
                color: #2c3e50;
            }

            /* Thiết kế responsive */
            @media (max-width: 768px) {
                form,
                a {
                    max-width: 100%;
                }

                button[type="submit"],
                a {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <h2>Update Product</h2>
        <form action="ProductMgtController?action=update" method="post">
            <input type="hidden" name="productId" value="<%= product.getProductId()%>">

            <label>Name:</label>
            <input type="text" name="name" value="<%= product.getName()%>" required><br>

            <label>Description:</label>
            <textarea name="description"><%= product.getDescription()%></textarea><br>

            <label>Base Price:</label>
            <input type="text" name="basePrice" value="<%= product.getBasePrice()%>" required><br>

            <label>Brand:</label>
            <input type="text" name="brand" value="<%= product.getBrand()%>"><br>

            <label>Material:</label>
            <input type="text" name="material" value="<%= product.getMaterial()%>"><br>

            <%

                if (categories == null) {
                    categories = new ArrayList<>(); 
                }

                int selectedCategoryId = (product != null && product.getCategory() != null)
                        ? product.getCategory().getCategoryId() : -1;
            %>

            <label>Category:</label>
            <select name="categoryId" required>
                <% for (CategoryDTO category : categories) {%>
                <option value="<%= category.getCategoryId()%>" 
                        <%= category.getCategoryId() == selectedCategoryId ? "selected" : ""%>>
                    <%= category.getName()%>
                </option>
                <% }%>
            </select>

            <label>Image URL:</label>
            <%
                String imageUrl = (product.getProductImage() != null) ? product.getProductImage().getImageUrl() : "";
            %>
            <input type="text" name="imageUrl" value="<%= imageUrl%>"><br>

            <button type="submit">Update</button>
        </form>
            <a href="ProductMgtController">Back to Product List</a>
    </body>
</html>
