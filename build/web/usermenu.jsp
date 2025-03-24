<%-- 
    Document   : usermenu
    Created on : Feb 26, 2025, 10:20:15 PM
    Author     : nguye
--%>

<!DOCTYPE html>
<html>
    <head>
        <title>User Menu</title>
        <style>
            .user-menu {
                display: flex;
                justify-content: right; /* C?n gi?a c�c m?c */
                background-color: #FFFFFF; /* M�u n?n x�m nh?t (t�y ch?n) */
                padding: 0 10px; /* Kho?ng c�ch tr�n v� d??i */
                border: black solid 1px;
            }
            .user-menu a {
                padding: 15px 30px; /* Kho?ng c�ch trong m?i m?c */
                text-decoration: none; /* Lo?i b? g?ch ch�n li�n k?t */
                color: #333; /* M�u ch? */
                border-left: black solid 1px;
            }
            .user-menu a:hover {
                background-color: #ddd; /* M�u n?n khi di chu?t qua (t�y ch?n) */
            }
        </style>
    </head>
    <body>

        <div class="user-menu">
            <a href="${pageContext.request.contextPath}/account.jsp">My Account</a>
            <a href="${pageContext.request.contextPath}/order">My Order</a>
            <a href="${pageContext.request.contextPath}/wishlist">My Wishlist</a>
        </div>

    </body>
</html>
