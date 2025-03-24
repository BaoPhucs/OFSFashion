<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>OFS Fashion - Product Detail</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f8f8f8;
            }

            .actions {
                display: flex;
                gap: 15px;
            }
            .actions a {
                text-decoration: none;
                color: black;
                font-weight: bold;
            }

            .container {
                display: flex;
                width: 100%;
                max-width: 1200px;
                margin: 20px auto;
                background: white;
                padding: 20px;
                min-height: 80vh;
                align-items: flex-start;
            }

            /* Khu v?c h?nh ?nh */
            .image-container {
                flex: 1;
                max-width: 100%;
                padding: 15px;
            }
            .product-images {
                position: relative;
                width: 100%;

            }
            .product-images .carousel-inner {
                border: 1px solid #ddd;
                border-radius: 8px;
                overflow: hidden;
            }
            .product-images .carousel-item img {
                width: 100%;
                height: 700px;
                object-fit: cover;
                border-radius: 8px;
            }
            .carousel-control-prev, .carousel-control-next {
                filter: invert(1);
            }

            /* Khu v?c chi ti?t s?n ph?m */
            .product-details {
                flex: 1;
                padding: 20px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: flex-start;
                text-align: left;
                width: 50%;
            }
            .product-title {
                font-size: 14px;
                font-weight: bold;
                color: #666;
            }
            .product-name {
                font-size: 24px;
                font-weight: bold;
                margin: 10px 0;
            }
            .price {
                font-size: 28px;
                color: black;
                margin: 10px 0;
                font-weight: 300;
            }
            .color-options button {
                margin: 5px;
                padding: 10px;
                border: 1px solid #000;
                background: white;
                cursor: pointer;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                transition: all 0.3s;
            }
            .color-options button.selected {
                border: 1px solid #000;
                transform: scale(1.1);
            }
            .size-options {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                margin-top: 10px;
            }

            .size-options button {
                margin: 0;
                padding: 10px 15px;
                border: none;
                background: #fff;
                color: #000;
                font-weight: 500;
                font-size: 14px;
                cursor: pointer;
                border-radius: 8px;
                transition: all 0.3s ease;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .size-options button:hover {
                background: #f5f5f5;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            }

            .size-options button.selected {
                padding: 12px 18px;
                border: 1px solid #000;
                background: #fff;
                color: #000;
                transform: scale(1.05);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            .size-options button:active {
                transform: scale(1.05);
            }
            .quantity-display {
                margin-top: 10px;
                font-size: 16px;
                color: #333;
            }
            .quantity-display.out-of-stock {
                color: #dc3545;
            }
            .details {
                margin-top: 20px;
                font-size: 16px;
                color: #333;
                max-height: 100px;
                overflow: hidden;
                transition: max-height 0.3s ease-in-out;
            }
            .details.expanded {
                max-height: 300px;
            }
            .view-more {
                display: inline-block;
                margin-top: 10px;
                color: #007bff;
                cursor: pointer;
                text-decoration: underline;
                font-weight: bold;
            }
            .add-to-cart {
                margin-top: 20px;
                padding: 12px 30px;
                background: #000;
                color: #fff;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                transition: background 0.3s;
            }
            .add-to-cart:hover {
                background: #333;
            }
            .favorite-btn {
                margin-top: 10px;
                padding: 10px 20px;
                background: #fff;
                border: 1px solid #000;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .favorite-btn i {
                color: #ff0000;
            }
            .favorite-btn:hover {
                background: #f0f0f0;
            }
            .no-variants {
                color: #dc3545;
                margin-top: 10px;
                display: none;
            }
            .check-store {
                display: block;
                margin-top: 20px;
                padding: 10px;
                background: white;
                color: black;
                text-align: center;
                border: 1px solid black;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
            }

            /* CSS cho ph?n Reviews */
            .reviews-section {
                margin-top: 30px;
                width: 100%;
            }
            .reviews-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
            }
            .average-rating {
                font-size: 24px;
                font-weight: bold;
                margin-right: 10px;
            }
            .star-rating {
                position: relative;
                display: inline-flex;
                align-items: center;
            }
            .total-reviews {
                font-size: 16px;
                color: #666;
                margin-left: 10px;
            }
            .review-item {
                border-bottom: 1px solid #ddd;
                padding: 15px 0;
                display: flex;
                flex-direction: column;
            }
            .review-header {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }
            .review-username {
                font-weight: bold;
                font-size: 16px;
                margin-right: 10px;
            }
            .review-rating {
                color: #f5c518;
                font-size: 16px;
            }
            .review-comment {
                font-size: 14px;
                color: #333;
                margin-bottom: 5px;
            }
            .review-date {
                font-size: 12px;
                color: #999;
            }
            .no-reviews {
                font-size: 16px;
                color: #666;
                font-style: italic;
            }


            .fa-star.filled {
                color: gold;
            }

            .fa-star.far {
                color: grey;
            }

            .half-star {
                position: relative;
                display: inline-block;
                width: 1em;
                height: 1em;
            }

            .half-star .fas.fa-star {
                position: absolute;
                top: 0;
                left: 0;
                width: 1em;
                height: 1em;
            }

            .half-star .far {
                color: grey; 
            }

            .half-star .half-filled {
                color: gold;
                clip-path: polygon(0 0, 50% 0, 50% 100%, 0 100%); 
            }
        </style>
        <script>
            const colorMap = {
                'blue': 'Blue',
                'black': 'Black',
                'white': 'White',
                'gray': 'Gray',
                'red': 'Red',
                'green': 'Green',
                'beige': 'Beige',
                'yellow': 'Yellow',
                'pink': 'Pink',
                'purple': 'Purple',
                'orange': 'Orange',
                'brown': 'Brown',
                'navy': 'Navy',
                'teal': 'Teal',
                'maroon': 'Maroon',
                'olive': 'Olive',
                'silver': 'Silver',
                'gold': 'Gold',
                'cyan': 'Cyan',
                'lime': 'Lime',
                'magenta': 'Magenta',
                'violet': 'Violet',
                'indigo': 'Indigo',
                'coral': 'Coral',
                'salmon': 'Salmon',
                'khaki': 'Khaki',
                'lavender': 'Lavender',
                'peach': 'Peach',
                'turqoise': 'Turquoise'
            };

            let variants = [];
            <c:forEach var="variant" items="${variants}">
            variants.push({
                size: '${variant.size}',
                color: '${variant.color}',
                price: '${variant.price}',
                quantity: ${variant.stockQuantity}
            });
            </c:forEach>

            function toggleDetails() {
                var details = document.querySelector(".details");
                details.classList.toggle("expanded");
            }

            function updateQuantityDisplay() {
                var selectedSizeButton = document.querySelector(".size-options button.selected");
                var selectedColorButton = document.querySelector(".color-options button.selected");
                var quantityDisplay = document.querySelector(".quantity-display");

                if (!selectedSizeButton || !selectedColorButton) {
                    quantityDisplay.textContent = "Please select a size and color.";
                    quantityDisplay.classList.remove("out-of-stock");
                    return;
                }

                var size = selectedSizeButton.textContent;
                var selectedColorCSS = selectedColorButton.style.backgroundColor.toLowerCase();
                var selectedColor = colorMap[selectedColorCSS] || selectedColorCSS.charAt(0).toUpperCase() + selectedColorCSS.slice(1);

                var matchingVariant = variants.find(variant =>
                    variant.size === size && variant.color.toLowerCase() === selectedColor.toLowerCase()
                );

                if (matchingVariant) {
                    quantityDisplay.textContent = "In stock: " + matchingVariant.quantity + " items";
                    quantityDisplay.classList.remove("out-of-stock");
                    if (matchingVariant.quantity === 0) {
                        quantityDisplay.classList.add("out-of-stock");
                    }
                } else {
                    quantityDisplay.textContent = "Out of stock";
                    quantityDisplay.classList.add("out-of-stock");
                }
            }

            function selectSize(element) {
                var buttons = document.querySelectorAll(".size-options button");
                buttons.forEach(button => button.classList.remove("selected"));
                element.classList.add("selected");
                updateQuantityDisplay();
            }

            function selectColor(element) {
                var buttons = document.querySelectorAll(".color-options button");
                buttons.forEach(button => button.classList.remove("selected"));
                element.classList.add("selected");

                var selectedColorCSS = element.style.backgroundColor.toLowerCase();
                var selectedColor = colorMap[selectedColorCSS] || selectedColorCSS.charAt(0).toUpperCase() + selectedColorCSS.slice(1);
                console.log("Selected Color CSS:", selectedColorCSS, "Mapped to:", selectedColor);

                var sizeOptionsDiv = document.querySelector(".size-options");
                var noVariantsMsg = document.querySelector(".no-variants");

                sizeOptionsDiv.innerHTML = '';

                var hasMatchingVariants = false;
                variants.forEach(variant => {
                    if (variant.color.toLowerCase() === selectedColor.toLowerCase()) {
                        var sizeButton = document.createElement('button');
                        sizeButton.textContent = variant.size;
                        sizeButton.onclick = function () {
                            selectSize(this);
                        };
                        sizeOptionsDiv.appendChild(sizeButton);
                        hasMatchingVariants = true;
                    }
                });

                if (!hasMatchingVariants) {
                    noVariantsMsg.style.display = "block";
            <c:forEach var="variant" items="${variants}" varStatus="status">
                    var sizeButton = document.createElement('button');
                    sizeButton.textContent = '${variant.size}';
                    sizeButton.onclick = function () {
                        selectSize(this);
                    };
                    if (${status.index} === 0)
                        sizeButton.classList.add("selected");
                    sizeOptionsDiv.appendChild(sizeButton);
            </c:forEach>
                } else {
                    noVariantsMsg.style.display = "none";
                    if (sizeOptionsDiv.children.length > 0) {
                        sizeOptionsDiv.children[0].classList.add("selected");
                    }
                }

                updateQuantityDisplay();
            }

            function addToCart() {
                console.log("addToCart function called"); // Debug

                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/productdetail';

                var selectedSizeButton = document.querySelector(".size-options button.selected");
                var selectedColorButton = document.querySelector(".color-options button.selected");

                console.log("Selected Size Button:", selectedSizeButton); // Debug
                console.log("Selected Color Button:", selectedColorButton); // Debug

                if (!selectedSizeButton || !selectedColorButton) {
                    alert("Please select a size and color!");
                    return;
                }

                var size = selectedSizeButton.textContent;
                var selectedColorCSS = selectedColorButton.style.backgroundColor.toLowerCase();
                var color = colorMap[selectedColorCSS] || selectedColorCSS.charAt(0).toUpperCase() + selectedColorCSS.slice(1);
                console.log("Adding to cart - Size:", size, "Color:", color);

                var matchingVariant = variants.find(variant =>
                    variant.size === size && variant.color.toLowerCase() === color.toLowerCase()
                );

                console.log("Matching Variant:", matchingVariant); // Debug

                if (!matchingVariant || matchingVariant.quantity <= 0) {
                    alert("This variant is out of stock!");
                    return;
                }

                var productIdInput = document.createElement('input');
                productIdInput.type = 'hidden';
                productIdInput.name = 'productId';
                productIdInput.value = "${product.productId}";

                var sizeInput = document.createElement('input');
                sizeInput.type = 'hidden';
                sizeInput.name = 'size';
                sizeInput.value = size;

                var colorInput = document.createElement('input');
                colorInput.type = 'hidden';
                colorInput.name = 'color';
                colorInput.value = color;

                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'addToCart';

                form.appendChild(productIdInput);
                form.appendChild(sizeInput);
                form.appendChild(colorInput);
                form.appendChild(actionInput);
                document.body.appendChild(form);
                console.log("Form created and submitted:", form); // Debug
                form.submit();
            }

            window.onload = function () {
                var sizeButtons = document.querySelectorAll(".size-options button");
                if (sizeButtons.length > 0) {
                    sizeButtons[0].classList.add("selected");
                }
                var colorButtons = document.querySelectorAll(".color-options button");
                if (colorButtons.length > 0) {
                    colorButtons[0].classList.add("selected");
                    selectColor(colorButtons[0]);
                }
            };
        </script>
    </head>
    <body>
        <%@include file="headerhome.jsp" %>
        <div class="container">
            <div class="image-container">
                <div class="product-images">
                    <div id="productCarousel" class="carousel slide" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <c:forEach var="image" items="${productImages}" varStatus="status">
                                <div class="carousel-item ${status.first ? 'active' : ''}">
                                    <img src="${not empty image.imageUrl ? image.imageUrl : '/Images/default.jpg'}" alt="${product.name}" class="d-block w-100">
                                </div>
                            </c:forEach>
                        </div>
                        <c:if test="${fn:length(productImages) > 1}">
                            <button class="carousel-control-prev" type="button" data-bs-target="#productCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#productCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>
            <div class="product-details">
                <p class="product-title">${product.productId}</p>
                <h2 class="product-name">${product.name}</h2>
                <p class="price">$ ${product.basePrice}</p>
                <div class="color-options">
                    <c:forEach var="color" items="${uniqueColors}">
                        <button style="background-color: ${color};" onclick="selectColor(this)"></button>
                    </c:forEach>
                </div>
                <div class="size-options">
                    <c:forEach var="variant" items="${variants}" varStatus="status">
                        <button onclick="selectSize(this)">${variant.size}</button>
                    </c:forEach>
                </div>
                <p class="quantity-display">Please select a size and color.</p>
                <p class="details">${product.description}</p>
                <a href="#" class="view-more" onclick="toggleDetails()">Read more</a>
                <button class="add-to-cart" onclick="addToCart()">Add to Cart</button>
                <div class="no-variants">No variants available for this color.</div>

                <!-- Ph?n hi?n th? Reviews -->
                <div class="reviews-section">
                    <div class="reviews-header">
                        <span class="average-rating">
                            <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/> / 5
                        </span>
                        <span class="star-rating">

                            <c:set var="intPart" value="${averageRating - (averageRating % 1)}"/>
                            <c:set var="decPart" value="${averageRating - intPart}"/>
                            <c:set var="nextIntPart" value="${intPart + 1}"/>
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= intPart}">

                                        <i class="fas fa-star filled"></i>
                                    </c:when>
                                    <c:when test="${i == nextIntPart && decPart > 0}">

                                        <span class="half-star">
                                            <i class="fas fa-star far"></i>
                                            <i class="fas fa-star filled half-filled"></i>
                                        </span>
                                    </c:when>
                                    <c:otherwise>

                                        <i class="fas fa-star far"></i>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </span>
                        <span class="total-reviews">(${totalReviews} reviews)</span>
                    </div>

                    <p style="display: none;">Debug: Number of reviews = ${fn:length(reviews)}</p>
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <p class="no-reviews">No reviews yet for this product.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="review" items="${reviews}" varStatus="loop">
                                <div class="review-item">
                                    <div class="review-header">
                                        <span class="review-username">${review.user.firstName} ${review.user.lastName}</span>
                                        <span class="review-rating">
                                            <!-- L?y ph?n nguy?n c?a review.rating -->
                                            <c:set var="revIntPart" value="${review.rating - (review.rating % 1)}"/>
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= revIntPart}">
                                                        <i class="fas fa-star filled"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-star far"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </span>
                                    </div>
                                    <p class="review-comment">${review.comment}</p>
                                    <p class="review-date">
                                        <c:choose>
                                            <c:when test="${not empty review.createdAt}">
                                                ${review.format('dd/MM/yyyy HH:mm')}
                                            </c:when>
                                            <c:otherwise>Unknown Date</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <span style="display: none;">Debug Review ${loop.count}: ProductId=${review.product.productId}, UserId=${review.user.userId}, Rating=${review.rating}</span>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <%@include file="footer.jsp" %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>