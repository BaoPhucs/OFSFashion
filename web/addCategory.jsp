<%-- 
    Document   : AddCategory
    Created on : Mar 16, 2025, 8:06:49 AM
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
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

            /* Select */
            select {
                padding: 10px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                background-color: #ffffff;
                color: #333;
                font-size: 14px;
                width: 100%;
                cursor: pointer;
                transition: border-color 0.3s ease;
            }

            select:focus {
                border-color: #3498db;
                outline: none;
            }

            /* Nút Continue */
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

            /* Liên kết Back */
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

            /* Thiết kế responsive */
            @media (max-width: 768px) {
                table {
                    max-width: 100%;
                }

                input[type="submit"],
                a {
                    width: 100%;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        
        <h2>Select Category</h2>
        <form action="addProduct.jsp" method="get">
            <table>
                <tr>
                    <td>Category Name:</td>
                    <td>
                        <select name="category_id" required>
                            <option value="1">Women's Clothing</option>
                            <option value="2">Women's Bags</option>
                            <option value="3">Women's Accessories</option>
                            <option value="4">Perfume</option>
                            <option value="5">Men's Clothing</option>
                            <option value="6">Men's Bags</option>
                            <option value="7">Men's Accessories</option>
                            <option value="8">Men's Sneakers</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input type="submit" value="Continue">
                    </td>
                </tr>
            </table>
        </form>


        <br>
        <a href="ProductMgtController">Back to Product Management</a>
    </body>
</html>
