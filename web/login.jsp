<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <title>Login</title>
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

            .form-group a {
                text-decoration: none;
                color: #007bff;
            }

            .form-group a:hover {
                text-decoration: underline;
            }

            .error-message {
                color: red;
                text-align: center;
                margin-bottom: 10px;
            }

            .signup-link {
                text-align: center;
                margin-top: 20px;
            }

            .signup-link a {
                color: #007bff;
                text-decoration: none;
            }

            .signup-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="header-create">
            <div class="main-page"><h3><a href="home">OFS Fashion</a></h3></div> 
            <h3>|</h3>
            <h5>Login OFS</h5>
        </div>
        <div class="form-container">
            <h3 class="form-title">LOGIN</h3>
            <p class="form-title">Welcome back</p>
            <p class="form-title">Login with your email and password</p>



            <c:set var="cookie" value="${pageContext.request.cookies}"/>
            <form action="login" method="POST">
                <div class="form-group">
                    <label for="user">Email</label>
                    <input type="text" id="user" placeholder="Email" name="user" value="${cookie.cuser.value}">
                </div>
                <div class="form-group">
                    <label for="pass">Password</label>
                    <input type="password" id="pass" name="pass" value="${cookie.cpass.value}">
                </div>
                <div class="form-group">
                    <a href="forgotpassword">Forgot password?</a>
                </div>
                <div class="form-groupp">
                    <input type="checkbox" id="rem" ${(cookie.crem != null ? 'checked' : '')} name="rem" value="ON">
                    <label for="rem">Remember me</label>
                </div>
                <div class="form-group">
                    <input type="submit" value="Login">
                </div>
            </form>
            <c:if test="${not empty requestScope.error}">
                <p class="error-message">${requestScope.error}</p>
            </c:if>
            <div class="signup-link">
                <span>Don't have an account?</span> <a href="register">Create one</a>
            </div>
        </div>
    </body>
</html>