<%-- 
    Document   : inventoryLog.jsp
    Created on : Mar 20, 2025, 10:59:40 PM
    Author     : nguye
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Inventory Logs - OFS Fashion</title>
        <link rel="stylesheet" href="CSS/inventory.css">
        
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        
    </head>
    <body>
        <div class="dashboard">
            <%@include file="dashBoardHeader.jsp" %>

            <div class="main-content">
       
                <div class="header">
                    <div class="search-bar">
                        <form action="inventoryLog" method="get">
                            <input type="text" name="keyword" placeholder="Search logs..." value="${param.keyword}">
                            <button type="submit">Search</button>
                        </form>
                    </div>
                    <div class="user-profile">
                        <strong><span>Admin</span></strong>
                        <a href="logout" class="a-logout">Logout</a>
                    </div>
                </div>

        
                <div class="content">
                    <h1>Inventory Logs</h1>
        
                    <div class="quick-actions">
                        <form method="get" action="inventoryLog">
                            <select name="sort" class="sort-option">
                                <option value="none" ${"none".equals(param.sort) ? "selected" : ""}>Default</option>
                                <option value="date_asc" ${"date_asc".equals(param.sort) ? "selected" : ""}>Date: Old to New</option>
                                <option value="date_desc" ${"date_desc".equals(param.sort) ? "selected" : ""}>Date: New to Old</option>
                                <option value="change_asc" ${"change_asc".equals(param.sort) ? "selected" : ""}>Stock Change: Low to High</option>
                                <option value="change_desc" ${"change_desc".equals(param.sort) ? "selected" : ""}>Stock Change: High to Low</option>
                            </select>
                            <button type="submit">Apply</button>
                        </form>
                    </div>

          
                    <div class="table-section">
                        <c:choose>
                            <c:when test="${empty inventoryLogs}">
                                <p>No inventory logs found.</p>
                            </c:when>
                            <c:otherwise>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Log ID</th>
                                            <th>Variant ID</th>
                                            <th>Stock Change</th>
                                            <th>Change Type</th>
                                            <th>Admin ID</th>
                                            <th>Change Reason</th>
                                            <th>Changed At</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="log" items="${inventoryLogs}">
                                            <tr>
                                                <td>${log.logId}</td>
                                                <td>${log.variantId}</td>
                                                <td>${log.stockChange}</td>
                                                <td>${log.changeType}</td>
                                                <td>${log.adminId}</td>
                                                <td>${log.changeReason}</td>
                                                <td>${log.changedAt}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>


                        <c:if test="${not empty currentPage and not empty totalPages}">
                            <div class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <a href="?sort=${param.sort}&page=${currentPage - 1}">Previous</a>
                                </c:if>
                                <span>Page ${currentPage} of ${totalPages}</span>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?sort=${param.sort}&page=${currentPage + 1}">Next</a>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>