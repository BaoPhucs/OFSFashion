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
                justify-content: right; 
                background-color: #FFFFFF; 
                padding: 0 10px; 
                border: black solid 1px;
            }
            .user-menu a {
                padding: 15px 30px; 
                text-decoration: none; 
                color: #333; 
                border-left: black solid 1px;
            }
            .user-menu a:hover {
                background-color: #ddd; 
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
