<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="OFS.Wishlist.WishlistDTO"%>
<%@page import="javax.servlet.http.HttpSession"%>
<%@page import="OFS.Users.UsersDTO"%>
<%@page import="java.util.ArrayList"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wishlist - OFS Fashion</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="CSS/styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
        }

        .header {
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            padding: 15px 0;
            background-color: #f8f8f8;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .user-menu {
            display: flex;
            justify-content: flex-end;
            background-color: #FFFFFF;
            padding: 0 10px;
            border: 1px solid black;
            border-top: none;
        }

        .user-menu a {
            padding: 15px 30px;
            text-decoration: none;
            color: #333;
            border-left: 1px solid black;
        }

        .user-menu a:hover {
            background-color: #ddd;
        }

        .container {
            max-width: 100%;
            margin: 20px auto;
            padding: 20px;
            background-color: #f0f0f0;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: left;
            color: #333;
            font-weight: bold;
            margin-bottom: 20px;
            font-size: 24px;
        }

        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .wishlist-item {
            position: relative;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            background-color: #fff;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            height: 300px;
            box-sizing: border-box;
        }

        .wishlist-item a {
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            height: 100%;
        }

        .wishlist-item img {
            width: 100%;
            height: 200px;
            object-fit: contain;
            margin-bottom: 10px;
        }

        .wishlist-item .details {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .wishlist-item .details h4 {
            margin: 0 0 5px 0;
            font-size: 16px;
            font-weight: bold;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            width: 100%;
        }

        .wishlist-item .price {
            font-size: 16px;
            font-weight: bold;
            color: #000;
            margin: 5px 0;
        }

        .wishlist-item .remove-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #ff4d4d;
            color: white;
            border: none;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            font-size: 14px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .wishlist-item .remove-btn:hover {
            background-color: #cc0000;
        }

        .no-wishlist {
            text-align: center;
            font-size: 18px;
            color: #888;
            margin-top: 20px;
        }

        .message {
            text-align: center;
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 5px;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <%@include file="headerhome.jsp" %>
    <%@include file="usermenu.jsp" %>
    <div class="container">
        <h2>Wishlist</h2>
        <%
            HttpSession sessionObj = request.getSession();
            user = (UsersDTO) sessionObj.getAttribute("account");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            } else {
                List<WishlistDTO> wishlist = (List<WishlistDTO>) request.getAttribute("wishlist");
                System.out.println("Wishlist in JSP: " + (wishlist != null ? wishlist.size() : "null"));
        %>

        <p>Welcome, <b><%= user.getFirstName() %></b>! Here are your wishlist items:</p>

        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="message success-message">
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error-message">
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <% if (wishlist == null || wishlist.isEmpty()) { %>
            <p class="no-wishlist">Your wishlist is empty.</p>
        <% } else { %>
            <div class="wishlist-grid">
                <% for (WishlistDTO item : wishlist) { 
                    int productId = item.getProduct().getProductId();
                    String imageUrl = (String) request.getAttribute("firstImage_" + productId);
                    if (imageUrl == null) {
                        imageUrl = request.getContextPath() + "/Images/default.jpg";
                        System.out.println("No image found for productId: " + productId + ", using default: " + imageUrl);
                    }
                %>
                    <div class="wishlist-item">
                        <form method="POST" action="wishlist" style="margin: 0;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <input type="hidden" name="redirect" value="wishlist">
                            <button type="submit" class="remove-btn">x</button>
                        </form>
                        <a href="${pageContext.request.contextPath}/productdetail?product_id=<%= productId %>">
                            <img src="<%= imageUrl %>" alt="<%= item.getProduct().getName() %>">
                            <div class="details">
                                <h4><%= item.getProduct().getName() %></h4>
                            </div>
                            <div class="price">$ <%= item.getProduct().getBasePrice() %></div>
                        </a>
                    </div>
                <% } %>
            </div>
        <% } %>

        <% } %>
    </div>
    <%@include file="footer.jsp" %>
</body>
</html>