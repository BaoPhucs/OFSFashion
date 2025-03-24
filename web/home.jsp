<%-- 
    Document   : home
    Created on : Feb 26, 2025, 10:41:01 PM
    Author     : Hoài Ân
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>OFS Fashion</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="CSS/styles.css">
        <link rel="stylesheet" href="CSS/search.css">
    </head>
    <body>
        <script src="${pageContext.request.contextPath}/js/search.js"></script>  
        <%@include file="headerhome.jsp"%>

        <main class="an-main">
            <div class="an-product-grid">
                <c:forEach var="category" items="${categoryList}" varStatus="loop">
                    <c:if test="${loop.index < 8}"> <!-- Hiển thị tối đa 8 category -->
                        <div class="an-product-item">
                            <a href="${pageContext.request.contextPath}/productbycategory?category_id=${category.categoryId}" target="_self">
                                <img src="${category.imageUrl}" alt="${category.name}" class="an-product-img">
                                <p class="an-product-name">${category.name}</p>
                            </a>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </main>

        <jsp:include page="searchOverlay.jsp" />
        <script>
            // Truyền giá trị openOverlay từ JSP sang JavaScript
            window.shouldOpenOverlay = ${param.openOverlay == 'true' ? 'true' : 'false'};
            console.log('shouldOpenOverlay from JSP:', window.shouldOpenOverlay); // Debug

            // Mở overlay khi trang load nếu có openOverlay=true
            window.addEventListener('load', function() {
                if (window.shouldOpenOverlay === true) {
                    document.getElementById('searchOverlay').classList.add('active');
                }
            });
        </script>

        <!-- Nhúng Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
        <%@include file="footer.jsp"%>
    </body>
</html>