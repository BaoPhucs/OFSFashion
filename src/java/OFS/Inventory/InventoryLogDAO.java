/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package OFS.Inventory;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author nguye
 */
public class InventoryLogDAO extends DBContext{
    public boolean addInventoryLog(InventoryLogDTO log) {
        String sql = "INSERT INTO inventory_logs (variant_id, stock_change, change_type, admin_id, change_reason, changed_at) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, log.getVariantId());
            ps.setInt(2, log.getStockChange());
            ps.setString(3, log.getChangeType());
            ps.setInt(4, log.getAdminId());
            ps.setString(5, log.getChangeReason());
            ps.setTimestamp(6, Timestamp.valueOf(log.getChangedAt()));
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding inventory log: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách log với tìm kiếm, sắp xếp và phân trang
    public List<InventoryLogDTO> getInventoryLogsWithFilters(String keyword, String sort, int offset, int limit) {
        List<InventoryLogDTO> logs = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT log_id, variant_id, stock_change, change_type, admin_id, change_reason, changed_at "
                + "FROM inventory_logs "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("WHERE CAST(log_id AS VARCHAR) LIKE ? "
                    + "OR CAST(variant_id AS VARCHAR) LIKE ? "
                    + "OR CAST(stock_change AS VARCHAR) LIKE ? "
                    + "OR change_type LIKE ? "
                    + "OR CAST(admin_id AS VARCHAR) LIKE ? "
                    + "OR change_reason LIKE ? ");
            String searchKeyword = "%" + keyword.trim() + "%";
            for (int i = 0; i < 6; i++) {
                params.add(searchKeyword);
            }
        }

        switch (sort) {
            case "date_asc":
                sql.append("ORDER BY changed_at ASC ");
                break;
            case "date_desc":
                sql.append("ORDER BY changed_at DESC ");
                break;
            case "change_asc":
                sql.append("ORDER BY stock_change ASC ");
                break;
            case "change_desc":
                sql.append("ORDER BY stock_change DESC ");
                break;
            default:
                sql.append("ORDER BY log_id DESC ");
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
                    InventoryLogDTO log = new InventoryLogDTO();
                    log.setLogId(rs.getInt("log_id"));
                    log.setVariantId(rs.getInt("variant_id"));
                    log.setStockChange(rs.getInt("stock_change"));
                    log.setChangeType(rs.getString("change_type"));
                    log.setAdminId(rs.getInt("admin_id"));
                    log.setChangeReason(rs.getString("change_reason"));
                    log.setChangedAt(rs.getTimestamp("changed_at").toLocalDateTime());
                    logs.add(log);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching inventory logs: " + e.getMessage());
            e.printStackTrace();
        }
        return logs;
    }

    public int getTotalLogs(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM inventory_logs ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("WHERE CAST(log_id AS VARCHAR) LIKE ? "
                    + "OR CAST(variant_id AS VARCHAR) LIKE ? "
                    + "OR CAST(stock_change AS VARCHAR) LIKE ? "
                    + "OR change_type LIKE ? "
                    + "OR CAST(admin_id AS VARCHAR) LIKE ? "
                    + "OR change_reason LIKE ? ");
            String searchKeyword = "%" + keyword.trim() + "%";
            for (int i = 0; i < 6; i++) {
                params.add(searchKeyword);
            }
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error counting inventory logs: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
