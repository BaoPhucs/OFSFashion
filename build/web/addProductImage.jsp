<%-- 
    Document   : AddProductImage
    Created on : Mar 16, 2025, 7:53:19 AM
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
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

            /* Ô chứa ô nhập liệu và nút Generate */
            .input-group {
                display: flex;
                align-items: center;
                gap: 10px; 
            }

            /* Ô nhập liệu */
            input[type="number"],
            input[type="text"] {
                padding: 10px;
                border: 1px solid #dfe6e9;
                border-radius: 8px;
                background-color: #ffffff;
                color: #333;
                font-size: 14px;
                width: 250px; 
                box-sizing: border-box; 
                transition: border-color 0.3s ease;
            }

            input[type="number"]:focus,
            input[type="text"]:focus {
                border-color: #3498db;
                outline: none;
            }

            /* Các ô nhập liệu trong #image_fields */
            #image_fields input[type="text"] {
                width: 100%; 
            }

            /* Nút Generate */
            button[type="button"] {
                padding: 10px 20px;
                background-color: #28a745; 
                color: #ffffff;
                border: none;
                border-radius: 8px;
                font-family: 'Roboto', sans-serif;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s ease;
                white-space: nowrap; 
            }

            button[type="button"]:hover {
                background-color: #218838;
            }

            /* Nút Next */
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

            /* Khung chứa các input động */
            #image_fields {
                margin-top: 10px;
            }

            #image_fields div {
                margin-bottom: 10px;
            }

            #image_fields label {
                display: block;
                color: #34495e;
                font-size: 14px;
                margin-bottom: 5px;
            }

            /* Thiết kế responsive */
            @media (max-width: 768px) {
                table {
                    max-width: 100%;
                }

                .input-group {
                    flex-direction: column;
                    gap: 10px;
                }

                input[type="number"],
                input[type="text"],
                input[type="submit"],
                button[type="button"],
                a {
                    width: 100%;
                    text-align: center;
                }
            }
        </style>
    </head>
    <body>
        <h2>Add Product Image</h2>
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

        <form action="ProductMgtController" method="post">
            <input type="hidden" name="product_id" value="<%= productId%>">

            <table>
                <tr>
                    <td><label for="image_count">Number of Images:</label></td>
                    <td>
                        <input type="number" id="image_count" name="image_count" min="1" max="10" required>
                        <button type="button" onclick="generateImageFields()">Generate</button>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                        <div id="image_fields"></div>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                        <input name="action" value="insertProductImage" type="hidden">
                        <input type="submit" value="Next">
                    </td>
                </tr>
            </table>
        </form>

        <script>
            function generateImageFields() {
                const count = document.getElementById("image_count").value;
                const container = document.getElementById("image_fields");
                container.innerHTML = ""; 

                for (let i = 1; i <= count; i++) {
                    const div = document.createElement("div");
                    div.innerHTML = `
                <label for="image_url_${i}">Image URL ${i}:</label>
                <input type="text" id="image_url_${i}" name="image_url" required>
            `;
                    container.appendChild(div);
                }
            }
        </script>


    </body>
</html>
