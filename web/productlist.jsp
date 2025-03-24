<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="OFS.Wishlist.WishlistDAO"%>
<%@page import="OFS.Wishlist.WishlistDTO"%>
<%@page import="OFS.Users.UsersDTO"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - OFS Fashion</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="CSS/styles.css">
    <style>
        .product-wishlist-icon.filled svg path {
            fill: red;
            stroke: red;
        }
        .product-wishlist-icon svg path {
            fill: none;
            stroke: black;
        }
        .product-wishlist-icon {
            display: block !important;
            opacity: 1 !important;
            visibility: visible !important;
        }
        .an-product-item .product-wishlist-icon {
            display: block !important;
            opacity: 1 !important;
            visibility: visible !important;
        }
        .an-product-item:hover .product-wishlist-icon {
            display: block !important;
            opacity: 1 !important;
            visibility: visible !important;
        }
    </style>
</head>
<body>
    <%@include file="headerhome.jsp"%>

    <%
        HttpSession sessionObj = request.getSession(false);
        user = (UsersDTO) sessionObj.getAttribute("account");
        List<WishlistDTO> userWishlist = null;
        if (user != null) {
            WishlistDAO wishlistDAO = new WishlistDAO();
            userWishlist = wishlistDAO.getWishlistByUserId(user.getUserId());
        }
    %>

    <main class="an-main">
        <h2 class="text-center mb-4">${categoryName}</h2>
        <div class="an-product-grid">
            <c:forEach var="product" items="${productList}">
                <div class="an-product-item">
                    <a href="productdetail?product_id=${product.productId}" target="_self">
                        <img src="${requestScope['firstImage_' += product.productId] != null ? requestScope['firstImage_' += product.productId] : '/Images/default.jpg'}" alt="${product.name}" class="an-product-img">
                        <p class="an-product-name">${product.name}</p>
                        <p class="an-product-name">$ ${product.basePrice}</p>
                    </a>
                    <%
                        boolean isInWishlist = false;
                        if (user != null && userWishlist != null) {
                            for (WishlistDTO item : userWishlist) {
                                if (item.getProduct().getProductId() == ((OFS.Product.Product) pageContext.getAttribute("product")).getProductId()) {
                                    isInWishlist = true;
                                    break;
                                }
                            }
                        }
                    %>
                    <span class="product-wishlist-icon position-absolute top-0 end-0 m-2 <%= user != null && isInWishlist ? "filled" : "" %>">
                        <form method="POST" action="wishlist" style="margin: 0;" onsubmit="return checkLogin()">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <input type="hidden" name="action" value="<%= user != null && isInWishlist ? "remove" : "add" %>">
                            <input type="hidden" name="redirect" value="productlist">
                            <button type="submit" style="background: none; border: none; padding: 0;">
                                <svg width="24" height="24" fill="none" stroke="black" stroke-width="2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path>
                                </svg>
                            </button>
                        </form>
                    </span>
                </div>
            </c:forEach>
        </div>
        <c:if test="${allProducts.size() > 12}">
            <div class="text-center mt-4">
                <c:choose>
                    <c:when test="${param.viewall == 'true'}">
                        <a href="${pageContext.request.contextPath}/productbycategory?category_id=${categoryId}" class="btn btn-dark">Compact</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/productbycategory?category_id=${categoryId}&viewall=true" class="btn btn-dark">View More</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function checkLogin() {
            <% if (user == null) { %>
                window.location.href = "login.jsp?redirect=" + encodeURIComponent(window.location.href);
                return false;
            <% } %>
            return true;
        }
    </script>
    <%@include file="footer.jsp"%>
</body>
</html>