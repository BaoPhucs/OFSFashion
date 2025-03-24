<%-- 
    Document   : UpdateVariant
    Created on : Mar 16, 2025, 8:35:47 PM
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:useBean id="variant" class="OFS.Product.ProductVariant" scope="request"/>
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
            input[type="number"] {
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
            input[type="number"]:focus {
                border-color: #3498db;
                outline: none;
            }

            /* Nút Update Variant */
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

            /* Thiết kế responsive */
            @media (max-width: 768px) {
                form {
                    max-width: 100%;
                }

                button[type="submit"] {
                    width: 100%;
                }
            }
        </style>

<h2>Update Product Variant</h2>
<form action="ProductMgtController" method="POST">
    <input type="hidden" name="action" value="updateVariant">
    <input type="hidden" name="productId" value="${productId}">
    <input type="hidden" name="variantId" value="${variant.variantId}">

    <label>Size:</label>
    <input type="text" name="size" value="${variant.size}" required>

    <label>Color:</label>
    <input type="text" name="color" value="${variant.color}" required>

    <label>Price:</label>
    <input type="number" name="price" step="0.01" value="${variant.price}" required>

    <label>Stock Quantity:</label>
    <input type="number" name="stockQuantity" value="${variant.stockQuantity}" required>

    <button type="submit">Update Variant</button>


</form>

