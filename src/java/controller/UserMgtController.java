/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import OFS.Users.UsersDAO;
import OFS.Users.UsersDTO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Acer
 */
@WebServlet(name = "UserMgtController", urlPatterns = {"/UserMgtController"})
public class UserMgtController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UsersDAO userDAO = new UsersDAO();
        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            try {
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                String userType = request.getParameter("userType");
                String dob = request.getParameter("dob");

                UsersDTO newUser = new UsersDTO(0, firstName, lastName, email, password, phone, address, userType, LocalDateTime.now(), dob);

                boolean success = userDAO.insertUser(newUser);
                if (success) {
                    response.sendRedirect("UserMgtController?success=UserAdded");
                    return;
                } else {
                    response.sendRedirect("addUser.jsp?error=InsertFailed");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("addUser.jsp?error=ServerError");
                return;
            }
        } else if ("edit".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                UsersDTO user = userDAO.getUsersById(userId);
                if (user != null) {
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("updateUser.jsp").forward(request, response);
                    return;
                } else {
                    response.sendRedirect("usermanagement.jsp?error=UserNotFound");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("usermanagement.jsp?error=InvalidUser");
                return;
            }
        } else if ("updateUser".equals(action)) {
            try {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                String userType = request.getParameter("userType");
                String dob = request.getParameter("dob");

                UsersDTO updatedUser = new UsersDTO(userId, firstName, lastName, email, password, phone, address, userType, LocalDateTime.now(), dob);

                boolean success = userDAO.updateUser(updatedUser);
                if (success) {
                    response.sendRedirect("UserMgtController?update=success");
                    return;
                } else {
                    response.sendRedirect("updateUser.jsp?error=UpdateFailed");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("updateUser.jsp?error=ServerError");
                return;
            }
        } else if ("deleteUser".equals(action)) {
            boolean success = false;
            try {
                String userIdStr = request.getParameter("userId");
                if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                    int userId = Integer.parseInt(userIdStr);
                    success = userDAO.deleteUser(userId);
                } else {
                    System.out.println("Invalid userId: " + userIdStr);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"success\": " + success + "}");
            return;
        }

        try {
            int page = 1;
            int recordsPerPage = 5;

            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            int offset = (page - 1) * recordsPerPage;

            String roleFilter = request.getParameter("role");
            if (roleFilter == null || roleFilter.trim().isEmpty() || "all".equalsIgnoreCase(roleFilter)) {
                roleFilter = "all";
            }

            String sort = request.getParameter("sort");
            if (sort == null || sort.trim().isEmpty()) {
                sort = "none";
            }

            String keyword = request.getParameter("keyword");
            List<UsersDTO> users;
            int totalRecords;

            if (keyword != null && !keyword.trim().isEmpty()) {
                users = userDAO.searchUsersWithPagination(keyword, offset, recordsPerPage);
                totalRecords = userDAO.getTotalSearchUsers(keyword);
            } else {
                users = userDAO.getUsersWithFilters(offset, recordsPerPage, roleFilter, sort);
                totalRecords = userDAO.getTotalUsers(roleFilter);
            }

            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

            request.setAttribute("users", users);
            request.setAttribute("selectedRole", roleFilter);
            request.setAttribute("selectedSort", sort);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);

            if (!response.isCommitted()) {
                request.getRequestDispatcher("usermanagement.jsp").forward(request, response);
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (!response.isCommitted()) {
                response.sendRedirect("usermanagement.jsp?error=ServerError");
            }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
