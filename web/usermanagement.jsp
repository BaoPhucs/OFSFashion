<%@page import="java.util.List"%>
<%@page import="OFS.Users.UsersDTO"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management</title>
    <link rel="stylesheet" href="CSS/user.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
</head>
<body>
    <div class="dashboard">
    
        <%@include file="dashBoardHeader.jsp"%>

     
        <div class="main-content">
        
            <div class="header">
                <div class="search-bar">
                    <form action="UserMgtController" method="GET">
                        <input type="text" name="keyword" placeholder="Search users..." value="${param.keyword}">
                        <button type="submit">Search</button>
               
                        <a href="UserMgtController" class="clear-search-btn">Clear Search</a>
                    </form>
                </div>
                <div class="user-profile">
                    <strong><span>Admin</span></strong>
                    <a href="logout" class="a-logout">Logout</a>
                </div>
            </div>

      
            <div class="content">
                <h1>User Management</h1>
              
                <% if (request.getParameter("keyword") != null && !request.getParameter("keyword").trim().isEmpty()) { %>
                    <p>Search results for: "<%= request.getParameter("keyword") %>"</p>
                <% } %>

           
                <div class="quick-actions">
                    <a href="addUser.jsp" class="add-user-btn">Add User</a>
                    <form method="get" action="UserMgtController">
               
                        <label for="role">Role:</label>
                        <select name="role" id="role" class="filter-role">
                            <option value="all" <%= "all".equals(request.getParameter("role")) ? "selected" : ""%>>All Roles</option>
                            <option value="admin" <%= "admin".equals(request.getParameter("role")) ? "selected" : ""%>>Admin</option>
                            <option value="customer" <%= "customer".equals(request.getParameter("role")) ? "selected" : ""%>>Customer</option>
                        </select>

                
                        <label for="sort">Sort by:</label>
                        <select name="sort" id="sort" class="sort-name">
                            <option value="none" <%= (request.getParameter("sort") == null || "none".equals(request.getParameter("sort"))) ? "selected" : ""%>>Default (User ID)</option>
                            <option value="name_asc" <%= "name_asc".equals(request.getParameter("sort")) ? "selected" : ""%>>Name: A to Z</option>
                            <option value="name_desc" <%= "name_desc".equals(request.getParameter("sort")) ? "selected" : ""%>>Name: Z to A</option>
                            <option value="date_asc" <%= "date_asc".equals(request.getParameter("sort")) ? "selected" : ""%>>Date Created: Oldest First</option>
                            <option value="date_desc" <%= "date_desc".equals(request.getParameter("sort")) ? "selected" : ""%>>Date Created: Newest First</option>
                        </select>

             
                        <input type="hidden" name="keyword" value="${param.keyword}">
                        <button type="submit">Apply</button>
                    </form>
                </div>

       
                <div class="table-section">
                    <table class="table table-bordered">
                        <thead class="thead-dark">
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Address</th>
                                <th>Role</th>
                                <th>Date of Birth</th>
                                <th>Created At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<UsersDTO> users = (List<UsersDTO>) request.getAttribute("users");
                                if (users != null && !users.isEmpty()) {
                                    for (UsersDTO user : users) {
                            %>
                            <tr>
                                <td><%= user.getUserId()%></td>
                                <td><%= user.getFirstName() + " " + user.getLastName()%></td>
                                <td><%= user.getEmail()%></td>
                                <td><%= user.getPhone()%></td>
                                <td><%= user.getAddress()%></td>
                                <td><%= user.getUserType()%></td>
                                <td><%= user.getDob() != null ? user.getDob() : "N/A"%></td>
                                <td>
                                    <%= user.getCreatedAt() != null ? DateTimeFormatter.ofPattern("dd/MM/yyyy").format(user.getCreatedAt()) : "N/A"%>
                                </td>
                                <td>
                                    <a href="UserMgtController?action=edit&userId=<%= user.getUserId()%>" class="btn btn-warning">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <a href="UserMgtController?action=deleteUser&userId=<%= user.getUserId()%>" 
                                       class="btn btn-danger delete-link">
                                        <i class="fas fa-trash-alt"></i> Delete
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="9" class="text-center">No users found.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>

                   
                    <div class="pagination">
                        <%
                            if (request.getAttribute("currentPage") != null && request.getAttribute("totalPages") != null) {
                                int currentPage = (int) request.getAttribute("currentPage");
                                int totalPages = (int) request.getAttribute("totalPages");
                                String role = request.getParameter("role") != null ? request.getParameter("role") : "all";
                                String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "none";
                                String keyword = request.getParameter("keyword") != null ? request.getParameter("keyword") : "";
                        %>
                        <div class="pagination">
                            <% if (currentPage > 1) {%>
                            <a href="?role=<%= role%>&sort=<%= sort%>&page=<%= currentPage - 1%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8") %>">Previous</a>
                            <% }%>

                            <span>Page <%= currentPage%> of <%= totalPages%></span>

                            <% if (currentPage < totalPages) {%>
                            <a href="?role=<%= role%>&sort=<%= sort%>&page=<%= currentPage + 1%>&keyword=<%= URLEncoder.encode(keyword, "UTF-8") %>">Next</a>
                            <% } %>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="modal" id="userDetailsModal">
        <div class="modal-content">
            <span class="close">×</span>
            <h2>User Details</h2>
            <div class="user-info">
                <p><strong>ID:</strong> <span id="userId"></span></p>
                <p><strong>Name:</strong> <span id="userName"></span></p>
                <p><strong>Email:</strong> <span id="userEmail"></span></p>
                <p><strong>Phone:</strong> <span id="userPhone"></span></p>
                <p><strong>Address:</strong> <span id="userAddress"></span></p>
                <p><strong>Role:</strong> <span id="userRole"></span></p>
            </div>
        </div>
    </div>


    <div class="notification">
        <span>User has been updated successfully!</span>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".delete-link").forEach(link => {
                link.addEventListener("click", function (event) {
                    event.preventDefault();
                    const userId = new URL(this.href).searchParams.get("userId");
                    if (!userId) {
                        alert("Invalid User ID.");
                        return;
                    }
                    if (confirm("Are you sure you want to delete this user?")) {
                        fetch(this.href, {method: "GET"})
                            .then(response => response.json())
                            .then(data => {
                                if (data.success) {
                                    alert("User deleted successfully!");
                                    this.closest("tr").remove();
                                } else {
                                    alert("Failed to delete user.");
                                }
                            })
                            .catch(error => console.error("Error:", error));
                    }
                });
            });
        });

   
        const users = {
            1: {
                name: "John Doe",
                email: "john@example.com",
                phone: "123-456-7890",
                address: "123 Main St, City",
                role: "Admin"
            },
            2: {
                name: "Jane Smith",
                email: "jane@example.com",
                phone: "987-654-3210",
                address: "456 Elm St, Town",
                role: "Customer"
            },
            3: {
                name: "Alice Johnson",
                email: "alice@example.com",
                phone: "555-123-4567",
                address: "789 Oak St, Village",
                role: "Customer"
            }
        };

 
        const modal = document.getElementById('userDetailsModal');
        const closeModal = document.querySelector('.close');
        const viewButtons = document.querySelectorAll('.view-btn');

        viewButtons.forEach(button => {
            button.addEventListener('click', () => {
                const userId = button.closest('tr').querySelector('td').textContent;
                const user = users[userId];
                if (user) {
                    document.getElementById('userId').textContent = userId;
                    document.getElementById('userName').textContent = user.name;
                    document.getElementById('userEmail').textContent = user.email;
                    document.getElementById('userPhone').textContent = user.phone;
                    document.getElementById('userAddress').textContent = user.address;
                    document.getElementById('userRole').textContent = user.role;

                    modal.style.display = 'block';
                }
            });
        });

        closeModal.addEventListener('click', () => {
            modal.style.display = 'none';
        });

        window.addEventListener('click', (event) => {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });


        function showNotification(message) {
            const notification = document.querySelector('.notification');
            notification.querySelector('span').textContent = message;
            notification.classList.add('show');
            setTimeout(() => notification.classList.remove('show'), 3000);
        }

        document.querySelector('.add-user-btn').addEventListener('click', () => {
            showNotification("User has been added successfully!");
        });
    </script>
</body>
</html>