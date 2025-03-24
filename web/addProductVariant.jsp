<%-- 
    Document   : AddProductVariant
    Created on : Mar 16, 2025, 7:57:40 AM
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Product Variant</title>
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

            /* Thông báo lỗi */
            p[style*="color: red"] {
                color: #dc3545; 
                font-size: 14px;
                margin-bottom: 15px;
            }

            /* Liên kết Go back */
            a {
                display: inline-block;
                padding: 8px 16px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                color: #34495e;
                font-weight: 500;
                text-decoration: none;
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            a:hover {
                background-color: #ecf0f1;
                color: #2c3e50;
            }

            /* Bảng */
            table {
                width: 100%;
                max-width: 600px; 
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

            input[type="number"]:focus {
                border-color: #3498db;
                outline: none;
            }

            /* Checkbox */
            label {
                display: inline-flex;
                align-items: center;
                margin-right: 15px;
                color: #34495e;
                font-size: 14px;
            }

            input[type="checkbox"] {
                margin-right: 5px;
                accent-color: #3498db; 
            }

            /* Nút Finish */
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

                input[type="number"],
                input[type="submit"] {
                    width: 100%;
                    text-align: center;
                }

                label {
                    display: block;
                    margin-bottom: 10px;
                }
            }
        </style>
    </head>
    <body>
        <h2>Add Product Variant</h2>
        <%
            String productId = request.getParameter("product_id");
            if (productId == null) {
        %>
        <p style="color: red;">Error: Product ID is missing!</p>
        <a href="productmanagement.jsp">Go back</a>
        <%
                return;
            }
        %>

        <form id="variantForm" action="ProductMgtController" method="post">
            <input type="hidden" name="product_id" value="<%= productId%>">

            <table>
                <tr>
                    <td><label>Size:</label></td>
                    <td>
                        <label><input type="checkbox" name="sizes" value="XS"> XS</label>
                        <label><input type="checkbox" name="sizes" value="S"> S</label>
                        <label><input type="checkbox" name="sizes" value="M"> M</label>
                        <label><input type="checkbox" name="sizes" value="L"> L</label>
                        <label><input type="checkbox" name="sizes" value="XL"> XL</label>
                        <label><input type="checkbox" name="sizes" value="XXL"> XXL</label>
                        <label><input type="checkbox" name="sizes" value="One Size"> One Size</label>
                    </td>
                </tr>

                <tr>
                    <td><label>Color:</label></td>
                    <td>
                        <label><input type="checkbox" name="colors" value="Red"> Red</label>
                        <label><input type="checkbox" name="colors" value="Blue"> Blue</label>
                        <label><input type="checkbox" name="colors" value="Green"> Green</label>
                        <label><input type="checkbox" name="colors" value="Black"> Black</label>
                        <label><input type="checkbox" name="colors" value="White"> White</label>
                    </td>
                </tr>

                <tr>
                    <td><label for="price">Price:</label></td>
                    <td><input id="price" name="price" type="number" step="0.01" required></td>
                </tr>
                <tr>
                    <td><label for="stock_quantity">Stock Quantity:</label></td>
                    <td><input id="stock_quantity" name="stock_quantity" type="number" required></td>
                </tr>

                <tr>
                    <td colspan="2">
                        <input name="action" value="insertProductVariant" type="hidden">
                        <input type="submit" value="Finish">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
