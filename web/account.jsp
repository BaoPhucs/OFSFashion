<%-- 
    Document   : myaccount
    Created on : Feb 26, 2025, 4:51:28 PM
    Author     : nguye
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Account - OFS Fashion</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="CSS/styles.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #F8F8F8;
            }
            .header {
                text-align: center;
                font-size: 24px;
                font-weight: bold;
                padding: 15px 0;
            }
            .container {
                margin: auto;
                padding: 20px;
                display: flex;
                justify-content: space-between; 
                align-items: flex-start; 
                gap: 20px; 
            }

            .container > div {
                flex: 1; 
                min-width: 45%; 
            }

            .perinfo {
                background-color: #FFFFFF;
                padding: 20px;
            }

            .perlogin {
                position: relative;
                background-color: #FFFFFF;
                padding: 20px;
                min-height: 330px;
            }

            .mb-3{
                margin-top: 30px;
            }

            .login {
                background-color: #FFFFFF;
                padding: 20px;
            }

            .btn-black {
                background-color: black;
                color: white;
                border: none;
                padding: 10px 20px;
                cursor: pointer;
                border-radius: 10px; 
            }
            .form-control, .form-select {
                margin-bottom: 10px;
            }
            .section-title {
                font-weight: bold;
                margin-top: 20px;
            }
            .checkbox-group {
                margin-bottom: 10px;
            }
            .btn-black:hover {
                background-color: #333;
            }

            .change-password-form {
                display: none;
                width: 400px; 
                padding: 20px;
            }

            .form-group {
                margin-bottom: 15px; 
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
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
                margin-bottom: 60px;
                font-weight: bold;
                transition: background-color 0.3s;
            }

            .form-group input[type="submit"]:hover {
                background-color: #333;
            }
            #toggleChangePassword {
                margin-left: 50px;
                margin-top: 40px;
            }

            .logout, .dashboard-link {
                position: absolute;
                bottom: 20px;
                border: black solid 1px;
                border-radius: 10px;
                padding: 10px;
                text-decoration: none;
                color: black;
            }

            .dashboard-link {
                right: 120px; 
            }

            .logout {
                right: 20px;
                margin-top: 800px;
            }

            .logout:hover, .dashboard-link:hover {
                background-color: #f0f0f0;
            }
        </style>
    </head>
    <body>
        <%@include file="headerhome.jsp" %>
        <%@include file="usermenu.jsp" %>
        <div class="container">
            <div class="perinfo">
                <h4>Personal Information</h4>
                <form action="updateprofile" method="POST">
                    <div class="mb-3">
                        <label class="form-label">First Name</label>
                        <input type="text" class="form-control" name="firstName" value="${sessionScope.account.firstName}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Last Name</label>
                        <input type="text" class="form-control" name="lastName" value="${sessionScope.account.lastName}" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <input type="text" class="form-control" name="address" value="${sessionScope.account.address}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" class="form-control" name="phone" value="${sessionScope.account.phone}">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Date of Birth</label><br>
                        <select class="form-select d-inline" style="width: 100px;" name="day" id="day" onchange="updateDays()">
                            <c:set var="selectedDay" value="${fn:substring(sessionScope.account.dob, 8, 10)}"/>
                            <c:forEach var="d" begin="1" end="31">
                                <option value="${d}" ${d == selectedDay ? 'selected' : ''}>${d}</option>
                            </c:forEach>
                        </select>
                        <select class="form-select d-inline" style="width: 140px;" name="month" id="month" onchange="updateDays()">
                            <c:set var="selectedMonth" value="${fn:substring(sessionScope.account.dob, 5, 7)}"/>
                            <c:forEach var="m" begin="1" end="12">
                                <option value="${m}" ${m == selectedMonth ? 'selected' : ''}>
                                    <c:choose>
                                        <c:when test="${m == 1}">January</c:when>
                                        <c:when test="${m == 2}">February</c:when>
                                        <c:when test="${m == 3}">March</c:when>
                                        <c:when test="${m == 4}">April</c:when>
                                        <c:when test="${m == 5}">May</c:when>
                                        <c:when test="${m == 6}">June</c:when>
                                        <c:when test="${m == 7}">July</c:when>
                                        <c:when test="${m == 8}">August</c:when>
                                        <c:when test="${m == 9}">September</c:when>
                                        <c:when test="${m == 10}">October</c:when>
                                        <c:when test="${m == 11}">November</c:when>
                                        <c:when test="${m == 12}">December</c:when>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                        <select class="form-select d-inline" style="width: 100px;" name="year" id="year" onchange="updateDays()">
                            <c:set var="selectedYear" value="${fn:substring(sessionScope.account.dob, 0, 4)}"/>
                            <c:forEach var="y" begin="1900" end="2025">
                                <option value="${y}" ${y == selectedYear ? 'selected' : ''}>${y}</option>
                            </c:forEach>
                        </select>
                        <input type="hidden" name="dob" id="dob">
                    </div>

                    <script>
                        function updateDays() {
                            let daySelect = document.getElementById("day");
                            let monthSelect = document.getElementById("month");
                            let yearSelect = document.getElementById("year");
                            let dobInput = document.getElementById("dob");

                            let month = parseInt(monthSelect.value);
                            let year = parseInt(yearSelect.value);
                            let day = parseInt(daySelect.value);

                            let daysInMonth;
                            if (month === 2) {
                                daysInMonth = (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)) ? 29 : 28;
                            } else if ([4, 6, 9, 11].includes(month)) {
                                daysInMonth = 30;
                            } else {
                                daysInMonth = 31;
                            }

                            // Cập nhật số ngày tối đa
                            daySelect.innerHTML = "";
                            for (let i = 1; i <= daysInMonth; i++) {
                                let option = document.createElement("option");
                                option.value = i;
                                option.text = i;
                                if (i === day) {
                                    option.selected = true;
                                }
                                daySelect.appendChild(option);
                            }

                            // Cập nhật giá trị dob
                            dobInput.value = year + "-" + (month < 10 ? "0" + month : month) + "-" + (day < 10 ? "0" + day : day);
                        }

                        // Gọi updateDays khi trang tải và khi bất kỳ select nào thay đổi
                        window.onload = updateDays;
                        document.getElementById("day").addEventListener("change", updateDays);
                        document.getElementById("month").addEventListener("change", updateDays);
                        document.getElementById("year").addEventListener("change", updateDays);
                    </script>

                    <button type="submit" class="btn-black" style="border-radius: 10px">Save your information</button>
                </form>

                <c:if test="${not empty requestScope.successMessageUpdate}">
                    <p class="success-message" style="color: green; margin-top: 15px">${requestScope.successMessageUpdate}</p>
                </c:if>
                <c:if test="${not empty requestScope.errorUpdate}">
                    <p class="error-message" style="color: red; margin-top: 15px">${requestScope.errorUpdate}</p>
                </c:if>
            </div>
            <hr>
            <div class="perlogin">
                <h4>Login Information</h4>
                <p style="margin-top: 20px"><strong>Email</strong><br> 
                    <span style="margin-left: 50px;">${sessionScope.account.email}</span>
                </p>
                <p><strong>Password</strong><br>
                    <button id="toggleChangePassword" class="btn-black" style="border-radius: 10px; margin-left: 50px; margin-top: 20px;">Change Password</button>
                </p>
                <div class="change-password-form">
                    <form action="changepassword" method="POST">
                        <div class="form-group">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword" required>
                        </div>
                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" id="newPassword" name="newPassword" required>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <div class="form-group">
                            <input type="submit" value="Save Changes">
                        </div>
                    </form>
                </div>

                <c:if test="${not empty requestScope.successMessage}">
                    <p class="success-message" style="color: green">${requestScope.successMessage}</p>
                </c:if>
                <c:if test="${not empty requestScope.error}">
                    <p class="error-message" style="color: red">${requestScope.error}</p>
                </c:if>

                <!-- Hiển thị nút "Go to Dashboard" nếu userType là admin -->
                <c:if test="${sessionScope.account.userType == 'admin'}">
                    <a class="dashboard-link" href="DashBoardController">Go to Dashboard</a>
                </c:if>
                <a class="logout" href="logout">Logout</a>
            </div>
        </div>

        <script>
            document.getElementById('toggleChangePassword').addEventListener('click', function () {
                const form = document.querySelector('.change-password-form');
                if (form.style.display === 'none' || form.style.display === '') {
                    form.style.display = 'block';
                } else {
                    form.style.display = 'none';
                }
            });
        </script>
        <%@include file="footer.jsp" %>
    </body>
</html>