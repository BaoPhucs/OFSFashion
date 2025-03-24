<%-- 
    Document   : AddUser
    Created on : Mar 19, 2025, 7:56:02 PM
    Author     : Acer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add User</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>
    <body>
        <div class="container mt-5">
            <h2>Add New User</h2>
            <form action="UserMgtController" method="post">
                <input type="hidden" name="action" value="insert">

                <div class="form-group">
                    <label>First Name:</label>
                    <input type="text" name="firstName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Last Name:</label>
                    <input type="text" name="lastName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Password:</label>
                    <input type="password" name="password" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Phone:</label>
                    <input type="text" name="phone" class="form-control">
                </div>

                <div class="form-group">
                    <label>Address:</label>
                    <input type="text" name="address" class="form-control">
                </div>

                <div class="form-group">
                    <label>User Type:</label>
                    <select name="userType" class="form-control">
                        <option value="customer">Customer</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Date of Birth:</label>
                    <input type="date" name="dob" class="form-control">
                </div>

                <button type="submit" class="btn btn-primary">Submit</button>
                <a href="UserMgtController" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </body>
</html>
