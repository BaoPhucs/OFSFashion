<%-- 
    Document   : UpdateUser
    Created on : Mar 19, 2025, 8:19:11 PM
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="OFS.Users.UsersDTO" %>
<%
    UsersDTO user = (UsersDTO) request.getAttribute("user");
%>

<html>
<head>
    <title>Update User</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2>Update User</h2>
        <form action="UserMgtController" method="post">
            <input type="hidden" name="action" value="updateUser">
            <input type="hidden" name="userId" value="<%= user.getUserId() %>">

            <div class="form-group">
                <label>First Name:</label>
                <input type="text" name="firstName" class="form-control" value="<%= user.getFirstName() %>" required>
            </div>

            <div class="form-group">
                <label>Last Name:</label>
                <input type="text" name="lastName" class="form-control" value="<%= user.getLastName() %>" required>
            </div>

            <div class="form-group">
                <label>Email:</label>
                <input type="email" name="email" class="form-control" value="<%= user.getEmail() %>" required>
            </div>

            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" class="form-control" value="<%= user.getPassword() %>" required>
            </div>

            <div class="form-group">
                <label>Phone:</label>
                <input type="text" name="phone" class="form-control" value="<%= user.getPhone() %>">
            </div>

            <div class="form-group">
                <label>Address:</label>
                <input type="text" name="address" class="form-control" value="<%= user.getAddress() %>">
            </div>

            <div class="form-group">
                <label>User Type:</label>
                <select name="userType" class="form-control">
                    <option value="customer" <%= "customer".equals(user.getUserType()) ? "selected" : "" %>>Customer</option>
                    <option value="admin" <%= "admin".equals(user.getUserType()) ? "selected" : "" %>>Admin</option>
                </select>
            </div>

            <div class="form-group">
                <label>Date of Birth:</label>
                <input type="date" name="dob" class="form-control" value="<%= user.getDob() %>">
            </div>

            <button type="submit" class="btn btn-primary">Update</button>
            <a href="UserMgtController" class="btn btn-secondary">Cancel</a>
        </form>
    </div>
</body>
</html>
