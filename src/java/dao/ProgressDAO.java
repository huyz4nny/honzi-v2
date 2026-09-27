package dao;

import model.UserProgress;
import model.Word;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProgressDAO {

    /**
     * Cập nhật tiến độ học của người dùng khi làm Flashcard hoặc bài tập
     * @param isCorrect true nếu trả lời/đánh dấu "Đã thuộc", false nếu "Chưa thuộc"
     */
    public boolean updateProgress(int userId, int wordId, boolean isCorrect) {
        String checkSql = "SELECT ProgressID, CorrectCount, WrongCount FROM UserProgress WHERE UserID = ? AND WordID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, userId);
            checkPs.setInt(2, wordId);

            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    int progressId = rs.getInt("ProgressID");
                    int correctCount = rs.getInt("CorrectCount") + (isCorrect ? 1 : 0);
                    int wrongCount = rs.getInt("WrongCount") + (isCorrect ? 0 : 1);
                    
                    // Nếu trả lời đúng/đã thuộc thì đánh dấu là "Mastered", ngược lại "Learning"
                    String status = isCorrect ? "Mastered" : "Learning";

                    String updateSql = "UPDATE UserProgress SET CorrectCount = ?, WrongCount = ?, Status = ?, LastReviewedAt = GETDATE() WHERE ProgressID = ?";
                    try (PreparedStatement updatePs = conn.prepareStatement(updateSql)) {
                        updatePs.setInt(1, correctCount);
                        updatePs.setInt(2, wrongCount);
                        updatePs.setNString(3, status);
                        updatePs.setInt(4, progressId);
                        return updatePs.executeUpdate() > 0;
                    }
                } else {
                    // Chưa có bản ghi -> Thêm mới tiến độ
                    int correctCount = isCorrect ? 1 : 0;
                    int wrongCount = isCorrect ? 0 : 1;
                    String status = isCorrect ? "Mastered" : "Learning";

                    String insertSql = "INSERT INTO UserProgress (UserID, WordID, Status, CorrectCount, WrongCount, LastReviewedAt) VALUES (?, ?, ?, ?, ?, GETDATE())";
                    try (PreparedStatement insertPs = conn.prepareStatement(insertSql)) {
                        insertPs.setInt(1, userId);
                        insertPs.setInt(2, wordId);
                        insertPs.setNString(3, status);
                        insertPs.setInt(4, correctCount);
                        insertPs.setInt(5, wrongCount);
                        return insertPs.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa/Đặt lại tiến độ học của người dùng ở một cấp độ HSK cụ thể khi người dùng chọn "Học lại từ đầu"
     * @param userId ID người dùng
     * @param hskLevel Cấp độ HSK (1-6)
     * @return true nếu xóa thành công
     */
    public boolean resetProgressByHskLevel(int userId, int hskLevel) {
        String sql = "DELETE up FROM UserProgress up " +
                     "JOIN Words w ON up.WordID = w.WordID " +
                     "WHERE up.UserID = ? AND w.HskLevel = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, hskLevel);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy tiến độ học chi tiết của một người dùng theo HSK level
     */
    public List<UserProgress> getUserProgressList(int userId, Integer hskLevel) {
        List<UserProgress> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT up.*, w.Hanzi, w.Pinyin, w.MeaningVi, w.HskLevel, w.Topic, w.ExampleSentence, w.ExampleMeaningVi, w.AudioUrl " +
                "FROM UserProgress up " +
                "JOIN Words w ON up.WordID = w.WordID " +
                "WHERE up.UserID = ?"
        );
        if (hskLevel != null && hskLevel > 0) {
            sql.append(" AND w.HskLevel = ?");
        }
        sql.append(" ORDER BY up.LastReviewedAt DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, userId);
            if (hskLevel != null && hskLevel > 0) {
                ps.setInt(2, hskLevel);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserProgress up = new UserProgress(
                            rs.getInt("ProgressID"),
                            rs.getInt("UserID"),
                            rs.getInt("WordID"),
                            rs.getNString("Status"),
                            rs.getInt("CorrectCount"),
                            rs.getInt("WrongCount"),
                            rs.getTimestamp("LastReviewedAt"),
                            rs.getTimestamp("NextReviewAt")
                    );
                    Word w = new Word(
                            rs.getInt("WordID"),
                            rs.getNString("Hanzi"),
                            rs.getNString("Pinyin"),
                            rs.getNString("MeaningVi"),
                            rs.getInt("HskLevel"),
                            rs.getNString("Topic"),
                            rs.getNString("ExampleSentence"),
                            rs.getNString("ExampleMeaningVi"),
                            rs.getNString("AudioUrl")
                    );
                    up.setWord(w);
                    list.add(up);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thống kê số lượng từ Mastered, Learning, New của người dùng cho từng cấp độ HSK (1-6)
     */
    public Map<Integer, Map<String, Integer>> getProgressSummaryByLevel(int userId) {
        Map<Integer, Map<String, Integer>> summary = new HashMap<>();
        for (int level = 1; level <= 6; level++) {
            Map<String, Integer> map = new HashMap<>();
            map.put("Mastered", 0);
            map.put("Learning", 0);
            map.put("TotalWords", 0);
            summary.put(level, map);
        }

        String sql = "SELECT w.HskLevel, up.Status, COUNT(*) as Count " +
                     "FROM UserProgress up " +
                     "JOIN Words w ON up.WordID = w.WordID " +
                     "WHERE up.UserID = ? " +
                     "GROUP BY w.HskLevel, up.Status";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int level = rs.getInt("HskLevel");
                    String status = rs.getNString("Status");
                    int count = rs.getInt("Count");
                    if (summary.containsKey(level)) {
                        summary.get(level).put(status, count);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Lấy tổng số từ từng level trong hệ thống để tính tỷ lệ %
        String totalSql = "SELECT HskLevel, COUNT(*) as Total FROM Words GROUP BY HskLevel";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(totalSql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int level = rs.getInt("HskLevel");
                int total = rs.getInt("Total");
                if (summary.containsKey(level)) {
                    summary.get(level).put("TotalWords", total);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return summary;
    }
}
