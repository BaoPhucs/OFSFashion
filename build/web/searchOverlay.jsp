<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="OFS.Product.ProductDAO"%>
<%@page import="OFS.Product.Product"%>
<%@page import="OFS.Product.ProductImages"%>
<%@page import="OFS.Wishlist.WishlistDAO"%>
<%@page import="OFS.Wishlist.WishlistDTO"%>
<%@page import="OFS.Users.UsersDTO"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
// Fetch the 4 latest products if not already available in the request (fallback if from home.jsp)
    if (request.getAttribute("latestProducts") == null && request.getAttribute("products") == null) {
        ProductDAO productDAO = new ProductDAO();
        List<Product> latestProducts = null;
        try {
            latestProducts = productDAO.getLatestProducts();
            if (latestProducts != null) {
                for (Product product : latestProducts) {
                    List<ProductImages> images = productDAO.getProductImagesByProductId(product.getProductId());
                    if (!images.isEmpty()) {
                        request.setAttribute("firstImage_" + product.getProductId(), images.get(0).getImageUrl());
                    } else {
                        request.setAttribute("firstImage_" + product.getProductId(), request.getContextPath() + "/Images/default.jpg");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to fetch latest products: " + e.getMessage());
            latestProducts = new ArrayList<>();
        }
        request.setAttribute("latestProducts", latestProducts);
    }

// Check user login status and fetch wishlist if logged in
    HttpSession sessionObj = request.getSession(false);
    UsersDTO user = (UsersDTO) sessionObj.getAttribute("account");
    List<WishlistDTO> userWishlist = null;
    if (user != null) {
        WishlistDAO wishlistDAO = new WishlistDAO();
        userWishlist = wishlistDAO.getWishlistByUserId(user.getUserId());
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Search Overlay - OFS Fashion</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background: #f8f8f8;
            }

            .search-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(255, 255, 255, 0.95);
                z-index: 1000;
                overflow-y: auto;
                display: none;
            }

            .search-overlay.active {
                display: block;
            }

            .corner-close-btn {
                position: absolute;
                top: 20px;
                right: 20px;
                background: none;
                border: none;
                font-size: 24px;
                cursor: pointer;
            }

            .search-header-container {
                text-align: center;
                padding: 20px 0;
                border-bottom: 1px solid #ddd;
            }

            .logo-text {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 10px;
            }

            .search-header {
                max-width: 600px;
                margin: 0 auto;
            }

            .search-input-container {
                position: relative;
                width: 100%;
                max-width: 500px;
            }

            .search-input-container input {
                width: 100%;
                padding: 10px 80px 10px 15px;
                font-size: 16px;
                border: 1px solid #ddd;
                border-radius: 25px;
            }

            .search-clear-btn {
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #666;
                font-size: 14px;
                cursor: pointer;
            }

            .search-results {
                padding: 20px 0;
            }

            .search-results-label, .new-products-label {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 20px;
            }

            .product-item {
                text-align: center;
                transition: transform 0.3s ease;
            }

            .product-item:hover {
                transform: translateY(-5px);
            }

            .product-item img {
                width: 100%;
                height: auto;
                border-radius: 10px;
                margin-bottom: 10px;
            }

            .product-item h3 {
                font-size: 16px;
                margin: 10px 0 5px;
                color: #333;
            }

            .product-item p {
                font-size: 14px;
                color: #666;
                margin: 0;
            }

            .product-wishlist-icon {
                cursor: pointer;
            }

            .product-wishlist-icon svg {
                transition: fill 0.3s ease;
            }

            .product-wishlist-icon.filled svg {
                fill: #ff0000; /* Màu đỏ khi sản phẩm đã trong wishlist */
                stroke: #ff0000;
            }

            .error-message {
                text-align: center;
                margin-top: 20px;
            }

            @media (max-width: 768px) {
                .search-header-container {
                    padding: 15px 0;
                }

                .search-input-container input {
                    padding: 8px 70px 8px 12px;
                }

                .product-item h3 {
                    font-size: 14px;
                }

                .product-item p {
                    font-size: 12px;
                }
            }
        </style>
    </head>
    <body>
        <div class="search-overlay" id="searchOverlay">
            <button class="corner-close-btn" onclick="closeSearch(event)">✕</button>
            <div class="search-header-container">
                <div class="logo-text"><a href="home" style="text-decoration: none; color: black;">OFS Fashion</a></div>  
                <div class="search-header">
                    <form id="searchForm" action="${pageContext.request.contextPath}/search" method="GET" class="d-flex justify-content-center w-100" onsubmit="handleSearch(event)">
                        <div class="search-input-container">
                            <input type="text" name="query" id="searchInput" placeholder="Search in OFS Fashion" value="${fn:escapeXml(param.query)}">
                            <button type="button" class="search-clear-btn" onclick="clearSearchInput()">CLEAR</button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="search-results container" id="searchResults">
                <c:choose>
                    <c:when test="${not empty requestScope.products}">
                        <c:if test="${not empty requestScope.products}">
                            <div class="search-results-label">
                                <c:out value="${fn:length(requestScope.products)}"/> search results
                            </div>
                            <div class="row">
                                <c:forEach var="product" items="${requestScope.products}">
                                    <div class="col-6 col-md-3 mb-4">
                                        <div class="product-item position-relative">
                                            <a href="${pageContext.request.contextPath}/productdetail?product_id=${product.productId}" target="_self">
                                                <c:set var="imageKey" value="firstImage_${product.productId}" />
                                                <img src="${requestScope[imageKey]}" alt="${product.name}" class="img-fluid">
                                                <h3>${fn:escapeXml(product.name)}</h3>
                                                <p>${product.basePrice}</p>
                                            </a>
                                            <%
                                                Product currentProduct = (Product) pageContext.getAttribute("product");
                                                boolean isInWishlist = false;
                                                if (user != null && userWishlist != null && currentProduct != null) {
                                                    for (WishlistDTO item : userWishlist) {
                                                        if (item.getProduct().getProductId() == currentProduct.getProductId()) {
                                                            isInWishlist = true;
                                                            break;
                                                        }
                                                    }
                                                }
                                            %>
                                            <span class="product-wishlist-icon position-absolute top-0 end-0 m-2 <%= user != null && isInWishlist ? "filled" : ""%>" onclick="toggleWishlist(this)">
                                                <form method="POST" action="wishlist" style="margin: 0;" onsubmit="return checkLogin(event)">
                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                    <input type="hidden" name="action" value="<%= user != null && isInWishlist ? "remove" : "add"%>">
                                                    <input type="hidden" name="redirect" value="searchOverlay">
                                                    <button type="submit" style="background: none; border: none; padding: 0;">
                                                        <svg width="24" height="24" fill="none" stroke="black" stroke-width="2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                        <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path>
                                                        </svg>
                                                    </button>
                                                </form>
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:when>
                    <c:when test="${empty param.query}">
                        <c:if test="${not empty requestScope.latestProducts}">
                            <div class="new-products-label">New Products</div>
                            <div class="row">
                                <c:forEach var="product" items="${requestScope.latestProducts}">
                                    <div class="col-6 col-md-3 mb-4">
                                        <div class="product-item position-relative">
                                            <a href="${pageContext.request.contextPath}/productdetail?product_id=${product.productId}" target="_self">
                                                <c:set var="imageKey" value="firstImage_${product.productId}" />
                                                <img src="${requestScope[imageKey]}" alt="${product.name}" class="img-fluid">
                                                <h3>${fn:escapeXml(product.name)}</h3>
                                                <p>${product.basePrice}</p>
                                            </a>
                                            <%
                                                Product currentProduct = (Product) pageContext.getAttribute("product");
                                                boolean isInWishlist = false;
                                                if (user != null && userWishlist != null && currentProduct != null) {
                                                    for (WishlistDTO item : userWishlist) {
                                                        if (item.getProduct().getProductId() == currentProduct.getProductId()) {
                                                            isInWishlist = true;
                                                            break;
                                                        }
                                                    }
                                                }
                                            %>
                                            <span class="product-wishlist-icon position-absolute top-0 end-0 m-2 <%= user != null && isInWishlist ? "filled" : ""%>" onclick="toggleWishlist(this)">
                                                <form method="POST" action="wishlist" style="margin: 0;" onsubmit="return checkLogin(event)">
                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                    <input type="hidden" name="action" value="<%= user != null && isInWishlist ? "remove" : "add"%>">
                                                    <input type="hidden" name="redirect" value="searchOverlay">
                                                    <button type="submit" style="background: none; border: none; padding: 0;">
                                                        <svg width="24" height="24" fill="none" stroke="black" stroke-width="2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                                        <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"></path>
                                                        </svg>
                                                    </button>
                                                </form>
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                        <c:if test="${empty requestScope.latestProducts}">
                            <p>No new products available.</p>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <p>No matching products found.</p>
                    </c:otherwise>
                </c:choose>
                <c:if test="${not empty errorMessage}">
                    <p class="error-message" style="color: red;">${errorMessage}</p>
                </c:if>
            </div>
        </div>

        <script>
            function closeSearch(event) {
                event.preventDefault();
                document.getElementById('searchOverlay').classList.remove('active');
            }

            function handleSearch(event) {
                event.preventDefault();
                const query = document.getElementById('searchInput').value;
                if (query.trim() !== '') {
                    window.location.href = '${pageContext.request.contextPath}/search?query=' + encodeURIComponent(query);
                }
            }

            function clearSearchInput() {
                const input = document.getElementById('searchInput');
                if (input.value.trim() !== '') {
                    input.value = '';
                    document.getElementById('searchForm').submit();
                }
            }

            function checkLogin(event) {
            <% if (user == null) { %>
                window.location.href = "login.jsp";
                return false;
            <% }%>
                return true;
            }

            function toggleWishlist(element) {
                // Toggle class 'filled' để thay đổi màu trái tim ngay lập tức
                element.classList.toggle('filled');
            }
        </script>
    </body>
</html>