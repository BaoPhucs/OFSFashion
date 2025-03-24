<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Order</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .order-item {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
            position: relative;
        }
        .remove-item {
            position: absolute;
            top: 10px;
            right: 10px;
            color: red;
            cursor: pointer;
        }
        .total-amount {
            font-size: 1.2em;
            font-weight: bold;
            margin-top: 20px;
        }
        .select2-container--open {
            z-index: 9999;
        }
        .select2-container .select2-selection--single {
            height: 38px;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
        }
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            line-height: 38px;
            padding-left: 12px;
        }
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 36px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="mb-4">Create New Order</h2>
        <form action="OrderMgtController" method="POST">
            <input type="hidden" name="action" value="submitCreateOrder">

            <div class="mb-3">
                <label for="userId" class="form-label">Select User</label>
                <select class="form-select searchable-select" id="userId" name="userId" required>
                    <option value="">-- Select User --</option>
                    <c:forEach var="user" items="${users}">
                        <option value="${user.userId}">${user.firstName} ${user.lastName} (${user.email})</option>
                    </c:forEach>
                </select>
            </div>

            <div id="orderItems">
                <div class="order-item">
                    <div class="mb-3">
                        <label class="form-label">Product</label>
                        <select class="form-select product-select searchable-select" name="productIds" onchange="filterVariants(this)">
                            <option value="">-- Select Product --</option>
                            <c:forEach var="product" items="${products}">
                                <option value="${product.productId}">${product.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Variant</label>
                        <select class="form-select variant-select" name="variantIds" onchange="updatePrice(this)">
                            <option value="">-- Select Variant --</option>
                            <c:forEach var="product" items="${products}">
                                <c:forEach var="variant" items="${productVariants[product.productId]}">
                                    <option value="${variant.variantId}" 
                                            data-product-id="${product.productId}" 
                                            data-price="${variant.price != null ? variant.price : 0}" 
                                            style="display: none;">
                                        Size: ${fn:escapeXml(variant.size != null ? variant.size : 'N/A')}, 
                                        Color: ${fn:escapeXml(variant.color != null ? variant.color : 'N/A')}, 
                                        Price: $${variant.price != null ? variant.price : 0}
                                    </option>
                                </c:forEach>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Quantity</label>
                        <input type="number" class="form-control quantity" name="quantities" min="1" value="1" onchange="calculateTotal()">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price</label>
                        <input type="text" class="form-control price" name="prices" readonly>
                    </div>
                    <span class="remove-item" onclick="removeItem(this)">Remove</span>
                </div>
            </div>

            <button type="button" class="btn btn-secondary mb-3" onclick="addOrderItem()">Add Another Item</button>

            <div class="total-amount">
                Total Amount: <span id="totalAmount">0.00</span>
            </div>
            <input type="hidden" name="totalAmount" id="totalAmountInput">

            <div class="mb-3">
                <label for="paymentMethod" class="form-label">Payment Method</label>
                <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                    <option value="">-- Select Payment Method --</option>
                    <option value="Cash on Delivery">Cash on Delivery</option>
                    <option value="Credit Card">Credit Card</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="orderStatus" class="form-label">Order Status</label>
                <select class="form-select" id="orderStatus" name="orderStatus" required>
                    <option value="">-- Select Order Status --</option>
                    <option value="Pending">Pending</option>
                    <option value="Processing">Processing</option>
                    <option value="Delivered">Delivered</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="deliveryOptions" class="form-label">Delivery Options</label>
                <select class="form-select" id="deliveryOptions" name="deliveryOptions" required>
                    <option value="">-- Select Delivery Option --</option>
                    <option value="Home Delivery">Home Delivery</option>
                    <option value="In-Store Pickup">In-Store Pickup</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Create Order</button>
            <a href="OrderMgtController" class="btn btn-secondary">Cancel</a>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <!-- Custom JavaScript -->
    <script>
        $(document).ready(function() {
            initializeSelect2ForInitialDropdowns();
        });

        function initializeSelect2ForInitialDropdowns() {
            $('#userId').select2({
                width: '100%',
                placeholder: $('#userId').find('option:first').text(),
                allowClear: true
            });
            
            $('.product-select').each(function() {
                $(this).select2({
                    width: '100%',
                    placeholder: $(this).find('option:first').text(),
                    allowClear: true
                });
            });
        }

        function initializeSelect2ForNewItem(newItem) {
            $(newItem).find('.product-select').select2({
                width: '100%',
                placeholder: $(newItem).find('.product-select option:first').text(),
                allowClear: true
            });
        }

        function filterVariants(select) {
            const productId = parseInt(select.value);
            const orderItem = select.closest('.order-item');
            const variantSelect = orderItem.querySelector('.variant-select');
            const priceInput = orderItem.querySelector('.price');

            variantSelect.selectedIndex = 0;
            priceInput.value = '';

            Array.from(variantSelect.options).forEach(option => {
                if (option.value === "") {
                    option.style.display = "block"; 
                    return;
                }
                const optionProductId = parseInt(option.getAttribute('data-product-id'));
                if (productId && optionProductId === productId) {
                    option.style.display = "block";
                } else {
                    option.style.display = "none";
                }
            });

            calculateTotal();
        }

        // Cập nhật giá khi chọn biến thể - keep original functionality
        function updatePrice(select) {
            const orderItem = select.closest('.order-item');
            const priceInput = orderItem.querySelector('.price');
            const selectedOption = select.options[select.selectedIndex];

            if (selectedOption.value) {
                const price = parseFloat(selectedOption.getAttribute('data-price'));
                priceInput.value = price ? price.toFixed(2) : 'N/A';
            } else {
                priceInput.value = '';
            }
            calculateTotal();
        }

        // Tính tổng tiền - keep original functionality
        function calculateTotal() {
            let total = 0;
            const orderItems = document.querySelectorAll('.order-item');
            orderItems.forEach(item => {
                const quantity = parseInt(item.querySelector('.quantity').value) || 0;
                const price = parseFloat(item.querySelector('.price').value) || 0;
                total += quantity * price;
            });
            document.getElementById('totalAmount').textContent = total.toFixed(2);
            document.getElementById('totalAmountInput').value = total.toFixed(2);
        }

        // Thêm mục đơn hàng mới
        function addOrderItem() {
            const orderItemsDiv = document.getElementById('orderItems');
            const newItem = document.createElement('div');
            newItem.className = 'order-item';
            newItem.innerHTML = `
                <div class="mb-3">
                    <label class="form-label">Product</label>
                    <select class="form-select product-select searchable-select" name="productIds" onchange="filterVariants(this)">
                        <option value="">-- Select Product --</option>
                        <c:forEach var="product" items="${products}">
                            <option value="${product.productId}">${product.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Variant</label>
                    <select class="form-select variant-select" name="variantIds" onchange="updatePrice(this)">
                        <option value="">-- Select Variant --</option>
                        <c:forEach var="product" items="${products}">
                            <c:forEach var="variant" items="${productVariants[product.productId]}">
                                <option value="${variant.variantId}" 
                                        data-product-id="${product.productId}" 
                                        data-price="${variant.price != null ? variant.price : 0}" 
                                        style="display: none;">
                                    Size: ${fn:escapeXml(variant.size != null ? variant.size : 'N/A')}, 
                                    Color: ${fn:escapeXml(variant.color != null ? variant.color : 'N/A')}, 
                                    Price: $${variant.price != null ? variant.price : 0}
                                </option>
                            </c:forEach>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Quantity</label>
                    <input type="number" class="form-control quantity" name="quantities" min="1" value="1" onchange="calculateTotal()">
                </div>
                <div class="mb-3">
                    <label class="form-label">Price</label>
                    <input type="text" class="form-control price" name="prices" readonly>
                </div>
                <span class="remove-item" onclick="removeItem(this)">Remove</span>
            `;
            orderItemsDiv.appendChild(newItem);
            
            // Initialize Select2 only on the new product selector
            initializeSelect2ForNewItem(newItem);
        }

        // Xóa mục đơn hàng - keep original functionality
        function removeItem(element) {
            const orderItems = document.querySelectorAll('.order-item');
            if (orderItems.length > 1) {
                element.closest('.order-item').remove();
                calculateTotal();
            }
        }
    </script>
</body>
</html>