<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Confirmation - OFS Fashion</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"> <!-- Thêm Font Awesome cho icon -->
        <style>
            body {
                font-family: 'Arial', sans-serif;
                margin: 0;
                padding: 0;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .container {
                flex: 1;
                max-width: 600px;
                margin: 50px auto;
                padding: 30px;
                background: #ffffff;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                text-align: center;
                animation: fadeIn 0.5s ease-in;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(-20px); }
                to { opacity: 1; transform: translateY(0); }
            }

            h2 {
                color: #333;
                font-size: 2.5rem;
                margin-bottom: 20px;
                font-weight: 700;
            }

            p {
                color: #666;
                font-size: 1.1rem;
                line-height: 1.6;
                margin-bottom: 15px;
            }

            .order-id {
                color: #007bff;
                font-weight: bold;
                font-size: 1.3rem;
                background: #e9f0ff;
                padding: 10px 20px;
                border-radius: 10px;
                display: inline-block;
            }

            .btn-custom {
                display: inline-block;
                margin-top: 20px;
                padding: 12px 30px;
                font-size: 1rem;
                font-weight: 500;
                text-decoration: none;
                border-radius: 25px;
                transition: all 0.3s ease;
            }

            .btn-view-orders {
                background: linear-gradient(90deg, #007bff, #00c6ff);
                color: #fff;
            }

            .btn-view-orders:hover {
                background: linear-gradient(90deg, #0056b3, #0099cc);
                color: #fff;
                transform: translateY(-2px);
            }

            .btn-primary {
                background-color: #000;
                color: #fff;
            }

            .btn-primary:hover {
                background-color: #333;
                color: #fff;
                transform: translateY(-2px);
            }

            .confirmation-icon {
                font-size: 4rem;
                color: #28a745;
                margin-bottom: 20px;
            }

            @media (max-width: 768px) {
                .container {
                    margin: 20px;
                    padding: 20px;
                }

                h2 {
                    font-size: 2rem;
                }

                p {
                    font-size: 1rem;
                }

                .btn-custom {
                    padding: 10px 20px;
                    font-size: 0.9rem;
                    margin-top: 10px;
                    width: 100%;
                    margin-right: 0;
                }

                .btn-view-orders + .btn-primary {
                    margin-top: 10px;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="headerhome.jsp" %>
        <div class="container">
            <div class="confirmation-icon">
                <i class="fas fa-check-circle"></i> 
            </div>
            <h2>Order Confirmation</h2>
            <p>Thank you for your purchase with OFS Fashion!</p>
            <p>Your order has been successfully placed.</p>
            <p class="order-id">Order ID: ${param.orderId}</p></br>
            <a href="${pageContext.request.contextPath}/order" class="btn-custom btn-view-orders">View My Orders</a></br>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-custom">Continue Shopping</a>
        </div>
        <%@include file="footer.jsp" %>
    </body>
</html>