<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            body {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
                min-height: 100vh;
                margin: 0;
                padding: 20px 0;
                background-color: #f9f9f9;
            }

            .header-create {
                display: flex;
                align-items: center;
                gap: 10px;
                border-bottom: black solid 1px;
                width: 100%;
                padding-bottom: 10px;
                margin-bottom: 30px; 
            }

            .main-page a {
                text-decoration: none;
                font-weight: bold;
                color: black;
                transition: color 0.3s ease;
                margin-left: 10px;
            }

            .main-page a:hover {
                color: #555; 
            }

            .form-container {
                align-self: center;
                width: 100%;
                padding: 40px;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .form-title {
                text-align: center;
                margin-bottom: 20px;
            }

            .form-content {
                display: flex;
                gap: 20px;
            }

            .form-column {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            .form-group {
                margin-bottom: 25px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
            }

            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }

            .register-btn {
                display: block;   
                margin: 0 auto; 
                background-color: black;
                color: white;
                cursor: pointer;
                border: none;
                padding: 12px;
                width: 100%;       
                max-width: 400px;
            }

            .register-btn:hover {
                background-color: #333;
            }

            .error-message {
                color: red;
                text-align: center;
                margin-bottom: 10px;
            }

            .login-link {
                text-align: center;
                margin-top: 20px;
            }

            .login-link a {
                color: #007bff;
                text-decoration: none;
            }

            .login-link a:hover {
                text-decoration: underline;
            }

            /* Ẩn modal mặc định */
            #successModal {
                display: none;
            }
        </style>
    </head>
    <body>
        <div class="header-create">
            <div class="main-page"><h3><a href="home">OFS Fashion</a></h3></div> 
            <h3>|</h3>
            <h5>Create account OFS</h5>
        </div>

        <div class="form-container">
            <h3 class="form-title">REGISTER</h3>
            <p class="form-title">Create your account</p>

            <c:if test="${not empty requestScope.error}">
                <p class="error-message">${requestScope.error}</p>
            </c:if>

            <form action="register" method="POST">
                <div class="form-content">
                  
                    <div class="form-column">
                        <div class="form-group">
                            <label for="firstName">First Name *</label>
                            <input type="text" id="firstName" name="firstName" required>
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last Name *</label>
                            <input type="text" id="lastName" name="lastName" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email *</label>
                            <input type="email" id="email" name="email" required>
                        </div>
                    </div>

                  
                    <div class="form-column">
                        <div class="form-group">
                            <label for="password">Password *</label>
                            <input type="password" id="password" name="password" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="text" id="phone" name="phone">
                        </div>
                        <div class="form-group">
                            <label for="address">Address</label>
                            <input type="text" id="address" name="address">
                        </div>
                        <div class="form-group">
                            <label for="dob">Date of Birth</label>
                            <input type="date" id="dob" name="dob">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <input type="submit" class="register-btn" value="Register">
                </div>
            </form>

            <div class="login-link">
                <span>Already have an account?</span> <a href="login.jsp">Login here</a>
            </div>

            
            <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="successModalLabel">Success</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p style="color: green; text-align: center;">${successMessage}</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

       
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Hiển thị modal khi có successMessage
            <c:if test="${not empty successMessage}">
            $(document).ready(function () {
                $('#successModal').modal('show');
                // Chuyển hướng sau 3 giây
                setTimeout(function () {
                    window.location.href = "login.jsp";
                }, 3000);
            });
            </c:if>
        </script>
    </body>
</html>
