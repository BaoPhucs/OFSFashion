<%-- 
    Document   : AddProduct
    Created on : Mar 15, 2025, 10:47:33 PM
    Author     : Acer
--%>

<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="OFS.Category.CategoryDTO"%>
<%@page import="OFS.Category.CategoryDTO"%>
<%@page import="java.util.List"%>
<%@page import="OFS.Category.CategoryDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Management</title>
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

            /* Bảng */
            table {
                width: 100%;
                max-width: 500px; 
                border-collapse: collapse;
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                margin-bottom: 20px;
            }

            table td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #ecf0f1;
                color: #34495e;
                font-size: 14px;
            }

            /* Ô nhập liệu */
            input[type="text"],
            input[type="number"],
            textarea {
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
            textarea:focus {
                border-color: #3498db;
                outline: none;
            }

            /* Ô readonly */
            input[readonly] {
                background-color: #f5f6fa;
                cursor: not-allowed;
            }

            /* Textarea */
            textarea {
                resize: vertical; 
            }

            /* Nút Save Product */
            input[type="submit"] {
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
            }

            input[type="submit"]:hover {
                background-color: #2980b9;
            }

            /* Thiết kế responsive */
            @media (max-width: 768px) {
                table {
                    max-width: 100%;
                }

                input[type="submit"] {
                    width: 100%;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <%
            Map<String, String> categoryMap = new HashMap<>();
            categoryMap.put("1", "Women's Clothing");
            categoryMap.put("2", "Women's Bags");
            categoryMap.put("3", "Women's Accessories");
            categoryMap.put("4", "Perfume");
            categoryMap.put("5", "Men's Clothing");
            categoryMap.put("6", "Men's Bags");
            categoryMap.put("7", "Men's Accessories");
            categoryMap.put("8", "Men's Sneakers");

            String categoryId = request.getParameter("category_id");
            String categoryName = categoryMap.getOrDefault(categoryId, "Unknown Category");
        %>

        <h2>Add Product</h2>
        <form action="ProductMgtController" method="post">
            <table>
                <tr>
                    <td>Category:</td>
                    <td>
                        <input type="hidden" name="category_id" value="<%= categoryId%>">
                        <input type="text" value="<%= categoryName%>" readonly>
                    </td>
                </tr>
                <tr>
                    <td>Product Name:</td>
                    <td><input type="text" name="name" required></td>
                </tr>
                <tr>
                    <td>Description:</td>
                    <td><textarea name="description" rows="4" cols="30"></textarea></td>
                </tr>
                <tr>
                    <td>Base Price:</td>
                    <td><input type="number" name="base_price" step="0.01" required></td>
                </tr>
                <tr>
                    <td>Brand:</td>
                    <td><input type="text" name="brand" required></td>
                </tr>
                <tr>
                    <td>Material:</td>
                    <td><input type="text" name="material"></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="hidden" name="action" value="insertProduct">
                        <input type="submit" value="Save Product">
                    </td>
                </tr>
            </table>
        </form>

    </body>
</html>
