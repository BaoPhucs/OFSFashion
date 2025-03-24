<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>OFS Fashion - Header</title>
        <link rel="stylesheet" href="CSS/styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    </head>
    <body>
        <header class="an-header">
            <div class="an-header-menu">
                <a href="home"><img class="img-logo" src="Images/logo.jpg"></a>
                <a href="${pageContext.request.contextPath}/search" class="search-link d-flex align-items-center" target="_self">
                    <i class="bi bi-search me-1"></i> Search
                </a>
            </div>

            <h1 class="an-header-title"><a href="home" style="color: black">OFS Fashion</a></h1>

            <div class="an-header-actions">
                <button class="an-btn-contact" onclick="scrollToFooter()">Contact Us</button>
                <a class="an-btn-heart" href="wishlist" target="_self">
                    <i class="fas fa-heart"></i>
                </a>
                <a class="an-btn-user" href="account" target="_self">
                    <i class="fas fa-user-circle"></i>
                </a>
                <a style="text-decoration: none;" class="an-btn-user" href="cart" target="_self">
                    <img src="Images/shopping_cart_icon.png" style="width: 22px" alt="Shopping Cart">
                    <span class="cart-badge">
                        <%
                            OFS.Users.UsersDTO user = (OFS.Users.UsersDTO) session.getAttribute("account");
                            if (user != null) {
                                Integer cartCount = (Integer) session.getAttribute("cartCount_" + user.getUserId());
                                out.print(cartCount != null ? cartCount : 0);
                            } else {
                                out.print(0);
                            }
                        %>
                    </span>
                </a>
            </div>
        </header>

        <script>
            function scrollToFooter() {
                document.getElementById('footer-section').scrollIntoView({behavior: 'smooth'});
            }
        </script>
    </body>
</html>