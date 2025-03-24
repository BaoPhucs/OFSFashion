package OFS.Users;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import dal.DBContext;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class UsersDAO extends DBContext {

    public UsersDTO check(String email, String password) {
        String sql = "SELECT [user_id]\n"
                + "      ,[first_name]\n"
                + "      ,[last_name]\n"
                + "      ,[email]\n"
                + "      ,[password]\n"
                + "      ,[phone]\n"
                + "      ,[address]\n"
                + "      ,[user_type]\n"
                + "      ,[created_at]\n"
                + "      ,[dob]\n"
                + "  FROM [dbo].[users]\n"
                + "  WHERE email = ? AND Password = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Timestamp timestamp = rs.getTimestamp("created_at");
                LocalDateTime createdAt = (timestamp != null) ? timestamp.toLocalDateTime() : null;
                UsersDTO a = new UsersDTO(
                        rs.getInt("user_id"),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("user_type"),
                        createdAt,
                        rs.getString("dob")
                );
                return a;
            }
        } catch (SQLException e) {
        }
        return null;
    }

    public UsersDTO getUsersById(int id) {
        String sql = "select * from users where user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Timestamp timestamp = rs.getTimestamp("created_at");
                LocalDateTime createdAt = (timestamp != null) ? timestamp.toLocalDateTime() : null;
                UsersDTO c = new UsersDTO(
                        rs.getInt("user_id"),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("user_type"),
                        createdAt,
                        rs.getString("dob")
                );
                return c;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public boolean addUser(UsersDTO user) {
        String sql = "INSERT INTO users (first_name, last_name, email, password, phone, address, user_type, created_at, dob) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, user.getFirstName());
            st.setString(2, user.getLastName());
            st.setString(3, user.getEmail());
            st.setString(4, user.getPassword());
            st.setString(5, user.getPhone());
            st.setString(6, user.getAddress());
            st.setString(7, user.getUserType());
            st.setTimestamp(8, user.getCreatedAt() != null ? Timestamp.valueOf(user.getCreatedAt()) : null);
            st.setString(9, user.getDob());
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public UsersDTO verifyUserForReset(String email, String dob, String phone) {
        String sql = "SELECT * FROM users WHERE email = ? AND dob = ? AND phone = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            st.setString(2, dob);
            st.setString(3, phone);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Timestamp timestamp = rs.getTimestamp("created_at");
                LocalDateTime createdAt = (timestamp != null) ? timestamp.toLocalDateTime() : null;
                return new UsersDTO(
                        rs.getInt("user_id"),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("user_type"),
                        createdAt,
                        rs.getString("dob")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error verifying user for reset: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE email = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, newPassword);
            st.setString(2, email);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating password: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserProfile(UsersDTO user) {
        String sql = "UPDATE users SET first_name = ?, last_name = ?, address = ?, phone = ?, dob = ? WHERE email = ?";
        PreparedStatement st = null;
        try {
            st = connection.prepareStatement(sql);
            st.setString(1, user.getFirstName());
            st.setString(2, user.getLastName());
            st.setString(3, user.getAddress());
            st.setString(4, user.getPhone());
            st.setString(5, user.getDob());
            st.setString(6, user.getEmail());
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating profile for email " + user.getEmail() + ": " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (st != null) {
                    st.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return false;
    }

    public List<UsersDTO> searchUsersWithPagination(String keyword, int offset, int limit) {
        List<UsersDTO> users = new ArrayList<>();

        String sql = "SELECT user_id, first_name, last_name, email, password, phone, address, user_type, created_at, dob "
                + "FROM users "
                + "WHERE CAST(user_id AS VARCHAR) LIKE ? "
                + "OR LOWER(first_name) LIKE LOWER(?) "
                + "OR LOWER(last_name) LIKE LOWER(?) "
                + "OR LOWER(email) LIKE LOWER(?) "
                + "OR phone LIKE ? "
                + "OR LOWER(user_type) LIKE LOWER(?) "
                + "OR CAST(dob AS VARCHAR) LIKE ? "
                + "ORDER BY user_id ASC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchKeyword = "%" + keyword.trim() + "%";
            for (int i = 1; i <= 7; i++) {
                st.setString(i, searchKeyword);
            }
            st.setInt(8, offset);
            st.setInt(9, limit);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Timestamp timestamp = rs.getTimestamp("created_at");
                    LocalDateTime createdAt = (timestamp != null) ? timestamp.toLocalDateTime() : null;

                    users.add(new UsersDTO(
                            rs.getInt("user_id"),
                            rs.getString("first_name"),
                            rs.getString("last_name"),
                            rs.getString("email"),
                            rs.getString("password"),
                            rs.getString("phone"),
                            rs.getString("address"),
                            rs.getString("user_type"),
                            createdAt,
                            rs.getString("dob")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public int getTotalSearchUsers(String keyword) {
        String sql = "SELECT COUNT(*) "
                + "FROM users "
                + "WHERE CAST(user_id AS VARCHAR) LIKE ? "
                + "OR LOWER(first_name) LIKE LOWER(?) "
                + "OR LOWER(last_name) LIKE LOWER(?) "
                + "OR LOWER(email) LIKE LOWER(?) "
                + "OR phone LIKE ? "
                + "OR LOWER(user_type) LIKE LOWER(?) "
                + "OR CAST(dob AS VARCHAR) LIKE ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            String searchKeyword = "%" + keyword.trim() + "%";
            for (int i = 1; i <= 7; i++) {
                st.setString(i, searchKeyword);
            }

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<UsersDTO> searchUsers(String keyword) {
        return searchUsersWithPagination(keyword, 0, Integer.MAX_VALUE); // Lấy tất cả kết quả
    }

    public List<UsersDTO> getAllUsers() {
        List<UsersDTO> users = new ArrayList<>();
        String sql = "SELECT user_id, first_name, last_name, email, password, phone, address, user_type, created_at, dob FROM users";

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                Timestamp timestamp = rs.getTimestamp("created_at");
                LocalDateTime createdAt = (timestamp != null) ? timestamp.toLocalDateTime() : null;

                users.add(new UsersDTO(
                        rs.getInt("user_id"),
                        rs.getString("first_name"),
                        rs.getString("last_name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("user_type"),
                        createdAt,
                        rs.getString("dob")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public List<UsersDTO> getUsersWithFilters(int offset, int limit, String role, String sort) throws Exception {
        List<UsersDTO> userList = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT u.user_id, u.first_name, u.last_name, u.email, u.password, u.phone, u.address, "
                + "u.user_type, u.created_at, u.dob FROM users u "
        );

        List<Object> params = new ArrayList<>();

        if ("admin".equalsIgnoreCase(role) || "customer".equalsIgnoreCase(role)) {
            sql.append("WHERE u.user_type = ? ");
            params.add(role);
        }

        switch (sort) {
            case "name_asc":
                sql.append("ORDER BY u.first_name ASC, u.last_name ASC ");
                break;
            case "name_desc":
                sql.append("ORDER BY u.first_name DESC, u.last_name DESC ");
                break;
            case "date_asc":
                sql.append("ORDER BY u.created_at ASC ");
                break;
            case "date_desc":
                sql.append("ORDER BY u.created_at DESC ");
                break;
            default:
                sql.append("ORDER BY u.user_id ASC ");
                break;
        }

        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    String email = rs.getString("email");
                    String password = rs.getString("password");
                    String phone = rs.getString("phone");
                    String address = rs.getString("address");
                    String userType = rs.getString("user_type");
                    LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                    String dob = rs.getString("dob");

                    UsersDTO user = new UsersDTO(userId, firstName, lastName, email, password, phone, address, userType, createdAt, dob);
                    userList.add(user);
                }
            }
        }
        return userList;
    }

    public List<UsersDTO> getUsersWithPagination(int offset, int limit, String sort) throws Exception {
        List<UsersDTO> userList = new ArrayList<>();

        String orderBy = "u.user_id ASC";
        switch (sort.toLowerCase()) {
            case "name_desc":
                orderBy = "u.first_name DESC";
                break;
            case "name_asc":
                orderBy = "u.first_name ASC";
                break;
            case "date_asc":
                orderBy = "u.created_at ASC";
                break;
            case "date_desc":
                orderBy = "u.created_at DESC";
                break;
            case "none":
            default:
                orderBy = "u.user_id ASC";
                break;
        }

        String sql = "SELECT u.user_id, u.first_name, u.last_name, u.email, u.password, u.phone, "
                + "u.address, u.user_type, u.created_at, u.dob "
                + "FROM users u "
                + "ORDER BY " + orderBy + " "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int userId = rs.getInt("user_id");
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    String email = rs.getString("email");
                    String password = rs.getString("password");
                    String phone = rs.getString("phone");
                    String address = rs.getString("address");
                    String userType = rs.getString("user_type");
                    LocalDateTime createdAt = rs.getTimestamp("created_at").toLocalDateTime();
                    String dob = rs.getString("dob");

                    UsersDTO user = new UsersDTO(userId, firstName, lastName, email, password, phone, address, userType, createdAt, dob);
                    userList.add(user);
                }
            }
        }
        return userList;
    }

    public int getTotalUsers(String role) throws Exception {
        String sql = "SELECT COUNT(*) FROM users";

        if (role != null && !"all".equalsIgnoreCase(role)) {
            sql += " WHERE user_type = ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (role != null && !"all".equalsIgnoreCase(role)) {
                ps.setString(1, role);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public boolean insertUser(UsersDTO user) throws Exception {
        String sql = "INSERT INTO users (first_name, last_name, dob, email, password, phone, address, user_type, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setDate(3, user.getDob() != null ? Date.valueOf(user.getDob()) : null);
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getPhone());
            ps.setString(7, user.getAddress());
            ps.setString(8, user.getUserType());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateUser(UsersDTO user) throws Exception {
        String sql = "UPDATE users SET first_name = ?, last_name = ?, dob = ?, email = ?, password = ?, phone = ?, "
                + "address = ?, user_type = ? WHERE user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setDate(3, user.getDob() != null ? Date.valueOf(user.getDob()) : null);
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getPhone());
            ps.setString(7, user.getAddress());
            ps.setString(8, user.getUserType());
            ps.setInt(9, user.getUserId());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteUser(int userId) throws Exception {
        String sql = "DELETE FROM users WHERE user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
}