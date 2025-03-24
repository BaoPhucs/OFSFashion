<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Shopping Cart</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f5f5f5;
            }

            .top-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 20px;
                background: white;
                border-bottom: 2px solid #ddd;
            }
            .top-bar .menu-search {
                display: flex;
                align-items: center;
                gap: 20px;
            }
            .top-bar .menu-search a {
                text-decoration: none;
                color: black;
                font-size: 20px;
            }
            .top-bar .icon-bar {
                display: flex;
                align-items: center;
                gap: 15px;
            }
            .icon-bar a {
                text-decoration: none;
                color: black;
                font-size: 18px;
                position: relative;
            }
            .icon-bar .cart-badge {
                position: absolute;
                top: -5px;
                right: -10px;
                background: black;
                color: white;
                font-size: 12px;
                width: 18px;
                height: 18px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .main-container {
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .cart-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                width: 100%;
            }

            .left-section {
                width: 65%;
            }
            .cart-section {
                width: 90%;
                display: flex;
                justify-content: space-between;
                padding: 20px;
                align-items: flex-start;
            }
            .cart-items {
                width: 65%;
                height: 600px;
                display: flex;
                flex-direction: column;
                border: 1px solid #ddd;
                border-radius: 10px;
                overflow-y: auto;
                background: #fff;
            }
            .cart-item {
                display: flex;
                align-items: center;
                padding: 20px;
                border-bottom: 1px solid #ddd;
            }
            .cart-item input[type="checkbox"] {
                margin-right: 10px;
                width: 20px;
                height: 20px;
            }
            .cart-item-image {
                flex: 1;
                padding: 20px;
                border-right: 1px solid #ddd;
            }
            .cart-item-image img {
                width: 100%;
                max-width: 300px;
                border-radius: 10px;
            }
            .product-code {
                font-size: 12px;
                color: gray;
                margin-bottom: 5px;
            }
            .cart-item-details {
                flex: 2;
                padding: 20px;
            }
            .cart-item-details p {
                margin: 15px 0;
            }
            .cart-item-details hr {
                margin: 10px 0;
                border: 0;
                border-top: 1px solid #ddd;
            }
            .cart-item-details button {
                border-radius: 5px;
            }
            .wishlist-remove {
                display: flex;
                gap: 20px;
                margin-top: 10px;
            }
            .wishlist-remove button {
                background: none;
                border: black solid 1px;
                font-size: 16px;
                color: black;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 5px;
                padding: 8px 12px;
                transition: all 0.3s ease;
            }
            .wishlist-remove button:hover {
                background: #ddd;
                color: black;
                transform: scale(1.05);
            }
            .price {
                font-size: 18px;
                font-weight: bold;
                margin-left: auto;
            }
            .quantity-section {
                display: flex;
                align-items: center;
                gap: 10px;
                margin: 10px 0px;
            }
            .quantity-section p {
                margin-left: auto;
            }
            .quantity-section button {
                border-radius: 5px;
            }
            .checkout-container {
                width: 30%;
                align-self: flex-start;
            }
            .checkout-section {
                text-align: right;
                border-radius: 10px;
                padding: 20px;
                background: #fff;
                border: 1px solid #ddd;
                min-height: 200px;
                width: 100%;
            }
            .checkout-summary {
                padding: 15px;
                border-radius: 10px;
                width: 100%;
                text-align: left;
            }
            .checkout-summary p {
                margin: 10px 0;
            }
            .btn {
                display: block;
                width: 100%;
                padding: 10px;
                background: black;
                color: white;
                text-align: center;
                border: none;
                cursor: pointer;
                font-size: 16px;
                margin-top: 15px;
                border-radius: 5px;
            }
            .btn:disabled {
                background: #ccc;
                cursor: not-allowed;
            }
            .continue-shopping {
                text-decoration: underline;
                color: black;
            }
            .empty-cart {
                text-align: center;
                padding: 20px;
                color: #666;
            }
            .proceed-btn {
                margin-top: 15px;
            }
            .error-message {
                display: none;
                color: #dc3545;
                font-size: 14px;
                margin-top: 20px;
                text-align: left;
                font-weight: bold;
                font-size: 20px;
            }
        </style>
        <script>
            const stockQuantities = [];
            <c:forEach var="item" items="${cart}" varStatus="loop">
                stockQuantities[${loop.index}] = ${item.variant.stockQuantity};
            </c:forEach>

            function updateQuantity(itemId, change) {
                let quantityElement = document.getElementById("quantity-" + itemId);
                let currentQuantity = parseInt(quantityElement.textContent);
                let newQuantity = currentQuantity + change;

                // kiem tra so luong moi co hop le khong
                if (newQuantity <= 0) {
                    return; // khong co phep < 1
                }

                // kt vs stockQuantity
                let stockQuantity = stockQuantities[itemId];
                let errorMessage = document.getElementById("stock-error-message");
                if (newQuantity > stockQuantity) {
                    // hien thi loi
                    errorMessage.innerHTML = "Cannot increase quantity. Only " + stockQuantity + " items in stock.";
                    errorMessage.style.display = "block";
                    return;
                }

                // cap nhat sl neu hop le
                quantityElement.textContent = newQuantity;

                // cap nhat gtri
                let quantityInput = document.getElementById("quantity-input-" + itemId);
                if (quantityInput) {
                    quantityInput.value = newQuantity;
                    console.log("Updated quantity for item " + itemId + ": " + quantityInput.value);
                } else {
                    console.error("Quantity input for item " + itemId + " not found!");
                }

                // in tbao loi if < 1
                errorMessage.style.display = "none";

                updateTotal();
                checkStockBeforeCheckout();
            }

            function updateTotal() {
                let cartItems = document.querySelectorAll(".cart-item");
                let subtotal = 0;
                cartItems.forEach(item => {
                    let checkbox = item.querySelector("input[type='checkbox']");
                    if (checkbox.checked) {
                        let price = parseFloat(item.querySelector(".price").textContent.replace("$", ""));
                        let quantity = parseInt(item.querySelector(".quantity-section span").textContent);
                        subtotal += price * quantity;
                    }
                });
                document.getElementById("subtotal").textContent = "$" + subtotal.toFixed(2);
                document.querySelector(".checkout-summary p:nth-child(2) strong").textContent = "$0.00";
                document.getElementById("total").textContent = "$" + subtotal.toFixed(2);
                let totalItems = Array.from(cartItems).reduce((sum, item) => sum + (item.querySelector("input[type='checkbox']").checked ? parseInt(item.querySelector(".quantity-section span").textContent) : 0), 0);
            <%
                Integer userId = ((OFS.Users.UsersDTO) session.getAttribute("account")).getUserId();
                pageContext.setAttribute("userId", userId);
            %>
                document.getElementById("cart-count").textContent = totalItems;
            }

            function checkStockBeforeCheckout() {
                let cartItems = document.querySelectorAll(".cart-item");
                let errorMessage = document.getElementById("stock-error-message");
                let proceedButton = document.querySelector(".proceed-btn");
                let hasError = false;
                let errorText = "";

                cartItems.forEach(item => {
                    let checkbox = item.querySelector("input[type='checkbox']");
                    let itemIndex = checkbox.value;
                    let quantity = parseInt(document.getElementById("quantity-" + itemIndex).textContent);
                    let stockQuantity = stockQuantities[itemIndex];
                    if (quantity > stockQuantity) {
                        hasError = true;
                        errorText = "Cannot increase quantity. Only " + stockQuantity + " items in stock.";
                    }
                });

                if (hasError) {
                    errorMessage.innerHTML = errorText;
                    errorMessage.style.display = "block";
                    proceedButton.disabled = true;
                } else {
                    errorMessage.style.display = "none";
                    proceedButton.disabled = false;
                }
            }

            function addToWishlist(productId) {
                let form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/wishlist';
                let actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'add';
                let productIdInput = document.createElement('input');
                productIdInput.type = 'hidden';
                productIdInput.name = 'productId';
                productIdInput.value = productId;
                form.appendChild(actionInput);
                form.appendChild(productIdInput);
                document.body.appendChild(form);
                form.submit();
            }

            function removeFromCart(itemIndex) {
                let form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/cart';
                let actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'remove';
                let indexInput = document.createElement('input');
                indexInput.type = 'hidden';
                indexInput.name = 'index';
                indexInput.value = itemIndex;
                form.appendChild(actionInput);
                form.appendChild(indexInput);
                document.body.appendChild(form);
                form.submit();
            }

            function proceedToCheckout(event) {
                event.preventDefault();
                let form = document.querySelector('#checkout-form');
                let selectedItems = [];
                let hasCheckedItems = false;

                // Xóa các input c?
                form.querySelectorAll('input[name="selectedItems"]').forEach(input => input.remove());

                // lay các checkbox 
                document.querySelectorAll('.cart-item input[type="checkbox"]:checked').forEach((checkbox) => {
                    hasCheckedItems = true;
                    let itemIndex = checkbox.value;

                    // Thêm selectedItems input
                    let input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'selectedItems';
                    input.value = itemIndex;
                    form.appendChild(input);

                    // lay s luong hien tai span
                    let quantitySpan = document.getElementById("quantity-" + itemIndex);
                    let currentQuantity = parseInt(quantitySpan.textContent);

                    let quantityInput = document.createElement('input');
                    quantityInput.type = 'hidden';
                    quantityInput.name = 'quantity-' + itemIndex;
                    quantityInput.value = currentQuantity;
                    form.appendChild(quantityInput);

                    console.log("Adding item " + itemIndex + " with quantity: " + currentQuantity);
                });

                if (!hasCheckedItems) {
                    alert("Please select at least one item to proceed to checkout.");
                    return;
                }

                let formData = new FormData(form);
                console.log("Form data before submit:");
                for (let [key, value] of formData.entries()) {
                    console.log(key + ': ' + value);
                }

                form.submit();
            }

            window.onload = function () {
                document.querySelectorAll(".cart-item input[type='checkbox']").forEach(checkbox => {
                    checkbox.checked = true;
                });

                updateTotal();
                checkStockBeforeCheckout();
                let cartItems = document.querySelectorAll(".cart-item");
                let initialCount = Array.from(cartItems).reduce((sum, item) => sum + parseInt(item.querySelector(".quantity-section span").textContent), 0);
            <%
                userId = ((OFS.Users.UsersDTO) session.getAttribute("account")).getUserId();
                pageContext.setAttribute("userId", userId);
            %>
                document.getElementById("cart-count").textContent = initialCount;
            }
        </script>
    </head>
    <body>
        <%@include file="headerhome.jsp" %>
        <main class="main-container">
            <div class="cart-header">
                <h2>My Shopping Cart</h2>
                <a href="home" class="continue-shopping">Continue Shopping</a>
            </div>
            <div class="cart-section">
                <div class="cart-items">
                    <c:choose>
                        <c:when test="${empty cart}">
                            <p class="empty-cart">Your cart is empty.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="item" items="${cart}" varStatus="loop">
                                <div class="cart-item">
                                    <input type="checkbox" name="item-checkbox" value="${loop.index}" onchange="updateTotal(); checkStockBeforeCheckout()">
                                    <div class="cart-item-image">
                                        <c:set var="imageKey" value="firstImage_${item.product.productId}" />
                                        <c:if test="${not empty requestScope[imageKey]}">
                                            <img src="${requestScope[imageKey]}" alt="${item.product.name != null ? item.product.name : 'Unnamed Product'}">
                                        </c:if>
                                    </div>
                                    <div class="cart-item-details">
                                        <p class="product-code">Product Code: ${item.product.productId}</p>
                                        <p><strong>${item.product.name != null ? item.product.name : "Unnamed Product"}</strong></p>
                                        <hr>
                                        <p>Color: ${item.variant.color}</p>
                                        <p>Size: ${item.variant.size}</p>
                                        <div class="quantity-section">
                                            <button type="button" onclick="updateQuantity(${loop.index}, -1)">-</button>
                                            <span id="quantity-${loop.index}">${item.quantity}</span>
                                            <button type="button" onclick="updateQuantity(${loop.index}, 1)">+</button>
                                            <p class="price">$${item.variant.price}</p>
                                        </div>
                                        <div class="wishlist-remove">
                                            <button type="button" onclick="addToWishlist(${item.product.productId})">Add to Wishlist</button>
                                            <button type="button" onclick="removeFromCart(${loop.index})">Remove</button>
                                        </div>
                                    </div>
                                    <input type="hidden" id="quantity-input-${loop.index}" name="quantity-${loop.index}" value="${item.quantity}">
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="checkout-container">
                    <div class="checkout-section">
                        <div class="checkout-summary">
                            <p>Subtotal: <strong id="subtotal">$0.00</strong></p>
                            <p>Shipping: <strong>$0.00</strong></p>
                            <hr>
                            <p><strong>Total: <strong id="total">$0.00</strong></strong></p>
                            <div id="stock-error-message" class="error-message"></div>
                        </div>
                        <form id="checkout-form" action="${pageContext.request.contextPath}/checkout" method="get">
                            <button type="button" class="btn btn-primary proceed-btn" onclick="proceedToCheckout(event)">Proceed to Checkout</button>
                        </form>
                    </div>
                </div>
            </div>
        </main>
        <%@include file="footer.jsp" %>
    </body>
</html>