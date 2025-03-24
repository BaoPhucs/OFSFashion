<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Order Details - OFS Fashion</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            .container {
                max-width: 1200px;
                margin: 20px auto;
                padding: 20px;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }

            h2 {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
                font-weight: bold;
            }

            .order-summary {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }

            .order-summary .row {
                margin-bottom: 10px;
            }

            .order-summary .label {
                font-weight: bold;
                color: #555;
            }

            .order-items {
                margin-top: 20px;
            }

            .order-item {
                display: flex;
                align-items: center;
                padding: 15px;
                border-bottom: 1px solid #ddd;
                gap: 15px;
            }

            .order-item img {
                width: 100px;
                height: 100px;
                object-fit: contain;
                border: 1px solid #ddd;
                border-radius: 5px;
                margin-right: 10px;
            }

            .order-item .details {
                flex-grow: 1;
            }

            .order-item .details p {
                margin: 5px 0;
                color: #666;
            }

            .order-item .details a {
                color: #000; 
                text-decoration: none;
            }

            .order-item .details a:hover {
                color: #333; 
            }

            .order-item .price {
                font-weight: bold;
                color: #000;
            }

            .back-btn {
                display: inline-block;
                margin-top: 20px;
                padding: 10px 20px;
                background-color: #000;
                color: #fff;
                text-decoration: none;
                border-radius: 5px;
                text-align: center;
            }

            .back-btn:hover {
                background-color: #333;
            }

            .review-form {
                margin-top: 10px;
                display: none; 
            }

            .review-form.active {
                display: block;
            }

            .review-form label {
                font-weight: bold;
                margin-right: 10px;
            }

            .review-form select, .review-form textarea {
                width: 100%;
                padding: 5px;
                margin-bottom: 10px;
            }

            .review-form button {
                background-color: #000;
                color: #fff;
                border: none;
                padding: 8px 15px;
                border-radius: 5px;
                cursor: pointer;
            }

            .review-form button:hover {
                background-color: #333;
            }
        </style>
    </head>
    <body>
        <%@include file="headerhome.jsp" %>
        <div class="container">
            <h2>Order Details</h2>
            <div class="order-summary">
                <div class="row">
                    <div class="col-4"><span class="label">Order ID:</span></div>
                    <div class="col-8">${order.orderId}</div>
                </div>
                <div class="row">
                    <div class="col-4"><span class="label">Date:</span></div>
                    <div class="col-8">${order.createdAt}</div>
                </div>
                <div class="row">
                    <div class="col-4"><span class="label">Total Amount:</span></div>
                    <div class="col-8">$${order.totalAmount}</div>
                </div>
                <div class="row">
                    <div class="col-4"><span class="label">Payment Method:</span></div>
                    <div class="col-8">${order.paymentMethod}</div>
                </div>
                <div class="row">
                    <div class="col-4"><span class="label">Status:</span></div>
                    <div class="col-8">${order.orderStatus}</div>
                </div>
                <div class="row">
                    <div class="col-4"><span class="label">Delivery Options:</span></div>
                    <div class="col-8">${order.deliveryOptions}</div>
                </div>
            </div>
            <div class="order-items">
                <c:forEach var="item" items="${orderItems}">
                    <c:set var="productId" value="${item.variantId.product.productId}" />
                    <div class="order-item">
                        <a href="${pageContext.request.contextPath}/productdetail?product_id=${item.variantId.product.productId}">
                            <img src="${requestScope['firstImage_' += productId] != null ? requestScope['firstImage_' += productId] : request.getContextPath() + '/Images/default.jpg'}" alt="Product Image">
                            <div class="details"> 
                                <p><strong>Product:</strong> ${item.variantId.product.name} (Size: ${item.variantId.size}, Color: ${item.variantId.color})</p>
                                <p><strong>Quantity:</strong> ${item.quantity}</p>
                                <p class="price"><strong>Price:</strong> $${item.price}</p>
                        </a>
                    </div>
                    <c:if test="${fn:toLowerCase(order.orderStatus) == 'delivered'}">
                        <button onclick="toggleReviewForm(this, ${productId}, ${item.orderItemId})">Write a Review</button>
                        <div class="review-form" id="reviewForm_${productId}_${item.orderItemId}">
                            <form action="${pageContext.request.contextPath}/productdetail?action=submitReview" method="POST">
                                <input type="hidden" name="productId" value="${productId}">
                                <input type="hidden" name="orderItemId" value="${item.orderItemId}">
                                <label for="rating_${productId}_${item.orderItemId}">Rating:</label>
                                <select name="rating" id="rating_${productId}_${item.orderItemId}" required>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                                <label for="comment_${productId}_${item.orderItemId}">Comment:</label>
                                <textarea name="comment" id="comment_${productId}_${item.orderItemId}" rows="3" required></textarea>
                                <button type="submit">Submit Review</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
        <a href="order" class="back-btn">Back to Orders</a>
    </div>
    <%@include file="footer.jsp" %>

    <script>
        function toggleReviewForm(button, productId, orderItemId) {
            console.log("productId:", productId, "orderItemId:", orderItemId);
            const form = document.getElementById("reviewForm_" + productId + "_" + orderItemId);
            console.log("Form element:", form);
            if (form) {
                form.classList.toggle("active");
            } else {
                console.error("Form not found with ID: reviewForm_" + productId + "_" + orderItemId);
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>