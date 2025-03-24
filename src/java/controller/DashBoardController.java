package controller;

import OFS.Order.Order;
import OFS.Order.OrderDAO;
import OFS.Product.Product;
import OFS.Product.ProductDAO;
import OFS.Users.UsersDAO;
import OFS.Users.UsersDTO;
import OFS.data.DashBoard;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DashBoardController", urlPatterns = {"/DashBoardController"})
public class DashBoardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        DashBoard dao = new DashBoard();
        UsersDAO userDAO = new UsersDAO();
        OrderDAO orderDAO = new OrderDAO();
        ProductDAO productDAO = new ProductDAO();

        try {
            // Lấy dữ liệu thống kê từ DAO
            Integer totalProducts = dao.getTotalProducts();
            Integer totalOrders = dao.getTotalOrders();
            Integer totalUsers = dao.getTotalUsers();
            Double totalRevenue = dao.getTotalRevenue();
            Integer deliveredOrders = dao.getDeliveredOrders();

            // Kiểm tra null trước khi đặt vào request
            request.setAttribute("totalProducts", (totalProducts != null) ? totalProducts : 0);
            request.setAttribute("totalOrders", (totalOrders != null) ? totalOrders : 0);
            request.setAttribute("totalUsers", (totalUsers != null) ? totalUsers : 0);
            request.setAttribute("totalRevenue", (totalRevenue != null) ? totalRevenue : 0.0);
            request.setAttribute("deliveredOrders", (deliveredOrders != null) ? deliveredOrders : 0);

            // Phân trang cho Recent Orders
            int recordsPerPage = 10; 
            int recentOrderPage = 1;
            if (request.getParameter("recentOrderPage") != null) {
                recentOrderPage = Integer.parseInt(request.getParameter("recentOrderPage"));
            }
            int offset = (recentOrderPage - 1) * recordsPerPage;

            // Lấy trạng thái lọc từ tham số
            String statusFilter = request.getParameter("statusFilter");
            if (statusFilter == null || statusFilter.trim().isEmpty()) {
                statusFilter = "all"; 
            }

            // Lấy danh sách Recent Orders với bộ lọc trạng thái và phân trang
            List<Order> recentOrders = orderDAO.getOrdersWithFilters(offset, recordsPerPage, statusFilter, null);
            int totalRecentOrders = orderDAO.getTotalOrders(statusFilter);
            int totalRecentOrderPages = (int) Math.ceil((double) totalRecentOrders / recordsPerPage);

            request.setAttribute("recentOrders", (recentOrders != null) ? recentOrders : new ArrayList<>());
            request.setAttribute("currentRecentOrderPage", recentOrderPage);
            request.setAttribute("totalRecentOrderPages", totalRecentOrderPages);

            // Xử lý tìm kiếm
            String keyword = request.getParameter("keyword");
            String filter = request.getParameter("filter");

            if (keyword != null && !keyword.trim().isEmpty()) {
                int searchRecordsPerPage = 5; 

                // Phân trang cho users
                int userPage = 1;
                if (request.getParameter("userPage") != null) {
                    userPage = Integer.parseInt(request.getParameter("userPage"));
                }
                int userOffset = (userPage - 1) * searchRecordsPerPage;

                // Phân trang cho orders
                int orderPage = 1;
                if (request.getParameter("orderPage") != null) {
                    orderPage = Integer.parseInt(request.getParameter("orderPage"));
                }
                int orderOffset = (orderPage - 1) * searchRecordsPerPage;

                // Phân trang cho products
                int productPage = 1;
                if (request.getParameter("productPage") != null) {
                    productPage = Integer.parseInt(request.getParameter("productPage"));
                }
                int productOffset = (productPage - 1) * searchRecordsPerPage;

                List<UsersDTO> users = new ArrayList<>();
                List<Order> orders = new ArrayList<>();
                List<Product> products = new ArrayList<>();

                // Tìm kiếm theo filter
                if ("users".equals(filter)) {
                    users = userDAO.searchUsersWithPagination(keyword, userOffset, searchRecordsPerPage);
                    int totalUsersFound = userDAO.getTotalSearchUsers(keyword);
                    int totalUserPages = (int) Math.ceil((double) totalUsersFound / searchRecordsPerPage);
                    request.setAttribute("totalUserPages", totalUserPages);
                    request.setAttribute("currentUserPage", userPage);
                } else if ("orders".equals(filter)) {
                    orders = orderDAO.searchOrdersWithPagination(keyword, orderOffset, searchRecordsPerPage);
                    int totalOrdersFound = orderDAO.getTotalSearchOrders(keyword);
                    int totalOrderPages = (int) Math.ceil((double) totalOrdersFound / searchRecordsPerPage);
                    request.setAttribute("totalOrderPages", totalOrderPages);
                    request.setAttribute("currentOrderPage", orderPage);
                } else if ("products".equals(filter)) {
                    products = productDAO.searchProductsWithPagination(keyword, productOffset, searchRecordsPerPage);
                    int totalProductsFound = productDAO.getTotalSearchProducts(keyword);
                    int totalProductPages = (int) Math.ceil((double) totalProductsFound / searchRecordsPerPage);
                    request.setAttribute("totalProductPages", totalProductPages);
                    request.setAttribute("currentProductPage", productPage);
                } else {
                    // Tìm kiếm tất cả
                    users = userDAO.searchUsersWithPagination(keyword, userOffset, searchRecordsPerPage);
                    int totalUsersFound = userDAO.getTotalSearchUsers(keyword);
                    int totalUserPages = (int) Math.ceil((double) totalUsersFound / searchRecordsPerPage);
                    request.setAttribute("totalUserPages", totalUserPages);
                    request.setAttribute("currentUserPage", userPage);

                    orders = orderDAO.searchOrdersWithPagination(keyword, orderOffset, searchRecordsPerPage);
                    int totalOrdersFound = orderDAO.getTotalSearchOrders(keyword);
                    int totalOrderPages = (int) Math.ceil((double) totalOrdersFound / searchRecordsPerPage);
                    request.setAttribute("totalOrderPages", totalOrderPages);
                    request.setAttribute("currentOrderPage", orderPage);

                    products = productDAO.searchProductsWithPagination(keyword, productOffset, searchRecordsPerPage);
                    int totalProductsFound = productDAO.getTotalSearchProducts(keyword);
                    int totalProductPages = (int) Math.ceil((double) totalProductsFound / searchRecordsPerPage);
                    request.setAttribute("totalProductPages", totalProductPages);
                    request.setAttribute("currentProductPage", productPage);
                }

                request.setAttribute("users", users);
                request.setAttribute("orders", orders);
                request.setAttribute("products", products);
                request.setAttribute("keyword", keyword);
                request.setAttribute("selectedFilter", filter);
            }

            // Chuyển hướng đến dashboard.jsp
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=ServerError");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
