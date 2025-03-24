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
                justify-content: right; /* C?n gi?a các m?c */
                background-color: #FFFFFF; /* Màu n?n xám nh?t (tùy ch?n) */
                padding: 0 10px; /* Kho?ng cách trên và d??i */
                border: black solid 1px;
            }
            .user-menu a {
                padding: 15px 30px; /* Kho?ng cách trong m?i m?c */
                text-decoration: none; /* Lo?i b? g?ch chân liên k?t */
                color: #333; /* Màu ch? */
                border-left: black solid 1px;
            }
            .user-menu a:hover {
                background-color: #ddd; /* Màu n?n khi di chu?t qua (tùy ch?n) */
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
