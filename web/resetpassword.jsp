<%-- 
    Document   : resetpassword
    Created on : Mar 1, 2025, 9:05:21 PM
    Author     : nguye
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <title>Reset Password</title>
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
            width: 600px;
            padding: 40px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-top: 40px; 
            margin-bottom: auto; 
        }

        .form-title {
            text-align: center;
            margin-bottom: 20px;
        }

        .form-group {
            margin-top: 30px;
            margin-bottom: 20px;
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

        .form-group input[type="submit"] {
            background-color: black;
            color: white;
            cursor: pointer;
            border: none;
            padding: 12px;
        }

        .form-group input[type="submit"]:hover {
            background-color: #333;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 10px;
        }

        .success-message {
            color: green;
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
    </style>
</head>
<body>
    <div class="header-create">
        <div class="main-page"><h3><a href="#">OFS Fashion</a></h3></div> 
        <h3>|</h3>
        <h5>Reset Password</h5>
    </div>
    <div class="form-container">
        <h3 class="form-title">RESET PASSWORD</h3>
        <p class="form-title">Enter the email and your new password</p>

        <c:if test="${not empty requestScope.error}">
            <p class="error-message">${requestScope.error}</p>
        </c:if>
        <c:if test="${not empty requestScope.successMessage}">
            <p class="success-message">${requestScope.successMessage}</p>
        </c:if>

        <form action="resetpassword" method="POST">
            <input type="hidden" name="email" value="${param.email}">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="text" id="email" name="email" required placeholder="Enter your email">
            </div>
            <div class="form-group">
                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword" required placeholder="Enter new password">
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Confirm new password">
            </div>
            <div class="form-group">
                <input type="submit" value="Reset Password">
            </div>
        </form>
        <div class="login-link">
            <span>Remember your password?</span> <a href="login.jsp">Login here</a>
        </div>
    </div>
</body>
</html>
