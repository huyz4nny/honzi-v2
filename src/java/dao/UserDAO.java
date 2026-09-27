package dao;

import model.SystemOverviewDTO;
import model.User;
import model.UserStatsDTO;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /**
     * Đăng ký người dùng mới
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO Users (Username, PasswordHash, Email, Role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, user.getUsername());
            ps.setNString(2, PasswordUtil.hashPassword(user.getPasswordHash()));
            ps.setNString(3, user.getEmail());
            ps.setNString(4, user.getRole() != null ? user.getRole() : "USER");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đăng nhập người dùng bằng tên đăng nhập và mật khẩu
     */
    public User loginUser(String username, String password) throws SQLException {
        String sql = "SELECT * FROM Users WHERE Username = ? AND PasswordHash = ?";
        String hashedPass = PasswordUtil.hashPassword(password);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, username);
            ps.setNString(2, hashedPass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("UserID"),
                            rs.getNString("Username"),
                            rs.getNString("PasswordHash"),
                            rs.getNString("Email"),
                            rs.getNString("Role"),
                            rs.getTimestamp("CreatedAt")
                    );
                }
            }
        }
        return null;
    }

    /**
     * Kiểm tra tên đăng nhập đã tồn tại chưa
     */
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiểm tra Email đã tồn tại chưa
     */
    public boolean checkEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy thông tin người dùng theo UserID
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("UserID"),
                            rs.getNString("Username"),
                            rs.getNString("PasswordHash"),
                            rs.getNString("Email"),
                            rs.getNString("Role"),
                            rs.getTimestamp("CreatedAt")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy thông tin người dùng theo Email
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("UserID"),
                            rs.getNString("Username"),
                            rs.getNString("PasswordHash"),
                            rs.getNString("Email"),
                            rs.getNString("Role"),
                            rs.getTimestamp("CreatedAt")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Cập nhật mật khẩu mới cho người dùng theo Email (Mật khẩu được băm SHA-256 an toàn)
     */
    public boolean updatePasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE Users SET PasswordHash = ? WHERE Email = ?";
        String hashedPass = PasswordUtil.hashPassword(newPassword);
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, hashedPass);
            ps.setNString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy thống kê tổng quan toàn hệ thống cho Dashboard Admin
     */
    public SystemOverviewDTO getSystemOverviewStats() {
        String sql = "SELECT " +
                "(SELECT COUNT(*) FROM Users) AS TotalUsers, " +
                "(SELECT COUNT(*) FROM Words) AS TotalWords, " +
                "(SELECT COUNT(*) FROM UserProgress WHERE Status = 'Mastered') AS TotalMasteredWords, " +
                "(SELECT COUNT(*) FROM QuizResults) AS TotalQuizzesTaken";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new SystemOverviewDTO(
                        rs.getInt("TotalUsers"),
                        rs.getInt("TotalWords"),
                        rs.getInt("TotalMasteredWords"),
                        rs.getInt("TotalQuizzesTaken")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new SystemOverviewDTO(0, 0, 0, 0);
    }

    /**
     * Lấy danh sách tất cả người dùng kèm thống kê tiến độ học tập và kết quả Quiz
     */
    public List<UserStatsDTO> getAllUsersWithStats(String searchKeyword, String roleFilter) {
        List<UserStatsDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append("    u.UserID, u.Username, u.Email, u.Role, u.CreatedAt, ");
        sql.append("    ISNULL(SUM(CASE WHEN up.Status = 'Mastered' THEN 1 ELSE 0 END), 0) AS MasteredCount, ");
        sql.append("    ISNULL(SUM(CASE WHEN up.Status = 'Learning' THEN 1 ELSE 0 END), 0) AS LearningCount, ");
        sql.append("    ISNULL(q.QuizCount, 0) AS TotalQuizCount, ");
        sql.append("    ISNULL(q.AvgScore, 0.0) AS AvgQuizScore, ");
        sql.append("    CASE ");
        sql.append("        WHEN MAX(up.LastReviewedAt) IS NOT NULL AND (q.LastQuizAt IS NULL OR MAX(up.LastReviewedAt) >= q.LastQuizAt) THEN MAX(up.LastReviewedAt) ");
        sql.append("        WHEN q.LastQuizAt IS NOT NULL THEN q.LastQuizAt ");
        sql.append("        ELSE NULL ");
        sql.append("    END AS LastActive ");
        sql.append("FROM Users u ");
        sql.append("LEFT JOIN UserProgress up ON u.UserID = up.UserID ");
        sql.append("LEFT JOIN ( ");
        sql.append("    SELECT ");
        sql.append("        UserID, ");
        sql.append("        COUNT(*) AS QuizCount, ");
        sql.append("        AVG(CAST(Score AS FLOAT) / CASE WHEN TotalQuestions = 0 THEN 1 ELSE CAST(TotalQuestions AS FLOAT) END * 100.0) AS AvgScore, ");
        sql.append("        MAX(TakenAt) AS LastQuizAt ");
        sql.append("    FROM QuizResults ");
        sql.append("    GROUP BY UserID ");
        sql.append(") q ON u.UserID = q.UserID ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (u.Username LIKE ? OR u.Email LIKE ?) ");
            String kw = "%" + searchKeyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (roleFilter != null && !roleFilter.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleFilter)) {
            sql.append(" AND u.Role = ? ");
            params.add(roleFilter.trim());
        }

        sql.append("GROUP BY u.UserID, u.Username, u.Email, u.Role, u.CreatedAt, q.QuizCount, q.AvgScore, q.LastQuizAt ");
        sql.append("ORDER BY u.UserID DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserStatsDTO dto = new UserStatsDTO(
                            rs.getInt("UserID"),
                            rs.getNString("Username"),
                            rs.getNString("Email"),
                            rs.getNString("Role"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getInt("MasteredCount"),
                            rs.getInt("LearningCount"),
                            rs.getInt("TotalQuizCount"),
                            rs.getDouble("AvgQuizScore"),
                            rs.getTimestamp("LastActive")
                    );
                    list.add(dto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

