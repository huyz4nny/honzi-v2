package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Cấu hình URL kết nối SQL Server theo yêu cầu đề bài
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=HanziGoDB;encrypt=true;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASS = "sa"; // Thay đổi mật khẩu sa tương ứng với máy của bạn

    static {
        try {
            // Nạp Driver SQL Server
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            System.err.println("Lỗi: Không tìm thấy JDBC Driver cho SQL Server!");
            e.printStackTrace();
        }
    }

    /**
     * Tạo kết nối đến cơ sở dữ liệu SQL Server
     * @return Connection đối tượng kết nối
     * @throws SQLException nếu kết nối thất bại
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /**
     * Đóng kết nối an toàn
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
