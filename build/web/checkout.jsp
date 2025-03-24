<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>OFS Fashion - Checkout</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/styles.css" onerror="console.error('Failed to load styles.css');">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f8f8f8;
            }
            .container {
                display: flex;
                max-width: 1200px;
                margin: 20px auto;
                gap: 20px;
            }
            .left-section, .right-section {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .left-section {
                flex: 2;
            }
            .right-section {
                flex: 1;
            }
            .section-title {
                font-weight: bold;
                margin-bottom: 10px;
                border-bottom: 2px solid #ddd;
                padding-bottom: 5px;
            }
            .boxed-section, .delivery-option {
                border: 1px solid #ddd;
                padding-top: 15px;
                padding-left: 15px;
                border-radius: 5px;
                margin-bottom: 10px;
                background-color: #f9f9f9;
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }
            .boxed-section .payment-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                width: 100%;
            }
            .order-summary img {
                width: 60px;
                height: auto;
                border-radius: 5px;
                margin-right: 10px;
            }
            .order-summary {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 10px;
            }
            .order-summary hr {
                width: 100%;
                border: none;
                border-top: 2px solid #ddd;
                margin-top: 10px;
            }
            .total {
                font-size: 20px;
                font-weight: bold;
                color: red;
            }
            .place-order {
                width: 100%;
                padding: 15px;
                background-color: #000;
                color: #fff;
                border: none;
                font-size: 16px;
                cursor: pointer;
                margin-top: 10px;
                border-radius: 5px;
            }
            .place-order:hover {
                background-color: #333;
            }
            hr.divider {
                border: none;
                border-top: 2px solid #ddd;
                margin: 10px 0;
            }
            .icon {
                font-size: 20px;
            }
            .error-message {
                color: red;
                margin-top: 10px;
            }
            .delivery-address {
                margin-left: 20px;
            }
            .credit-card-image {
                margin-top: 10px;
                display: none; 
                width: 60px; 
                height: auto;
            }
        </style>
    </head>
    <body>
        <%@include file="headerhome.jsp" %>
        <form action="${pageContext.request.contextPath}/checkout" method="post">
            <div class="container">
                <div class="left-section">
                    <h2 class="section-title">1. Delivery Options</h2>
                    <div class="delivery-option">
                        <p><input type="radio" name="delivery" value="in-store"> In-Store Pickup</p>
                    </div>
                    <div class="delivery-option">
                        <p><input type="radio" name="delivery" value="home" checked> Home Delivery</p>
                        <p class="delivery-address">
                            <strong>Delivery Address</strong><br>
                            <c:set var="user" value="${sessionScope.account}" />
                            ${user.address != null ? user.address : 'No address set. Please update your profile.'}
                        </p>
                    </div>
                    <h2 class="section-title">2. Payment</h2>
                    <div class="boxed-section">
                        <div class="payment-header">
                            <p><input type="radio" name="payment" value="credit"> QR Code</p>
                        </div>
                        <div id="creditCardImage" class="credit-card-image">
                            <img src="Images/qr.jpg" alt="Credit Card Options" style="width: 300px; height: 400px;">
                        </div>
                    </div>
                    <div class="boxed-section">
                        <div class="payment-header">
                            <p><input type="radio" name="payment" value="cod" checked> Cash on Delivery (COD)</p>
                        </div>
                    </div>
                </div>
                <div class="right-section">
                    <h2 class="section-title">My Shopping Cart (${cartItems.size()})</h2>
                    <c:forEach var="item" items="${cartItems}" varStatus="loop">
                        <div class="order-summary">
                            <c:set var="imageKey" value="firstImage_${item.product.productId}" />
                            <c:if test="${not empty requestScope[imageKey]}">
                                <img src="${requestScope[imageKey]}" alt="${item.product.name}">
                            </c:if>
                            <p>
                                ${item.product.name} 
                                (Size: ${item.variant.size}, 
                                Color: ${item.variant.color}) 
                                - Quantity: ${item.quantity} 
                                - Price: $${item.variant.price}
                            </p>
                        </div>
                        <hr class="divider">
                        <input type="hidden" name="quantity-${loop.index}" value="${item.quantity}">
                        <input type="hidden" name="selectedItems" value="${loop.index}">
                    </c:forEach>
                    <p>Subtotal: $${totalAmount}</p>
                    <p>Shipping: $0.00</p>
                    <p>Tax: $0.00</p>
                    <p class="total">Total: $${totalAmount}</p>
                    <c:if test="${not empty param.error}">
                        <div class="error-message">
                            ${param.error == 'orderFailed' ? 'Order placement failed. Please try again.' : 'No items selected.'}
                        </div>
                    </c:if>
                    <button type="submit" class="place-order">Place Order</button>
                </div>
            </div>
        </form>
        <%@include file="footer.jsp" %>

        <script>
            const creditCardRadio = document.querySelector('input[name="payment"][value="credit"]');
            const codRadio = document.querySelector('input[name="payment"][value="cod"]');
            const creditCardImage = document.getElementById('creditCardImage');

            function toggleCreditCardImage() {
                if (creditCardRadio.checked) {
                    creditCardImage.style.display = 'block';
                } else {
                    creditCardImage.style.display = 'none';
                }
            }

            toggleCreditCardImage();

            creditCardRadio.addEventListener('change', toggleCreditCardImage);
            codRadio.addEventListener('change', toggleCreditCardImage);
        </script>
    </body>
</html>