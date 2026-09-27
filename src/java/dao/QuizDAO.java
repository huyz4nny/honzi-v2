package dao;

import model.QuizResult;
import model.Word;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {

    /**
     * Lấy danh sách từ vựng ngẫu nhiên theo cấp độ HSK để tạo câu hỏi Quiz
     */
    public List<Word> getRandomWordsForQuiz(int hskLevel, int limit) {
        List<Word> words = new ArrayList<>();
        // Dùng NEWID() trong SQL Server để lấy ngẫu nhiên hàng
        String sql = "SELECT TOP (?) * FROM Words WHERE HskLevel = ? ORDER BY NEWID()";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, hskLevel);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Word word = new Word(
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
                    words.add(word);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return words;
    }

    /**
     * Lấy các lựa chọn ngẫu nhiên để làm đáp án sai (Distractors)
     */
    public List<String> getRandomMeaningsExcept(int correctWordId, int limit) {
        List<String> distractors = new ArrayList<>();
        String sql = "SELECT TOP (?) MeaningVi FROM Words WHERE WordID <> ? ORDER BY NEWID()";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, correctWordId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    distractors.add(rs.getNString("MeaningVi"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return distractors;
    }

    /**
     * Lưu kết quả bài kiểm tra Quiz vào CSDL
     */
    public boolean saveQuizResult(QuizResult result) {
        String sql = "INSERT INTO QuizResults (UserID, HskLevel, Score, TotalQuestions, TakenAt) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, result.getUserId());
            ps.setInt(2, result.getHskLevel());
            ps.setInt(3, result.getScore());
            ps.setInt(4, result.getTotalQuestions());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách lịch sử kiểm tra trắc nghiệm của học viên
     */
    public List<QuizResult> getQuizResultsByUser(int userId) {
        List<QuizResult> list = new ArrayList<>();
        String sql = "SELECT * FROM QuizResults WHERE UserID = ? ORDER BY TakenAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizResult qr = new QuizResult(
                            rs.getInt("QuizID"),
                            rs.getInt("UserID"),
                            rs.getInt("HskLevel"),
                            rs.getInt("Score"),
                            rs.getInt("TotalQuestions"),
                            rs.getTimestamp("TakenAt")
                    );
                    list.add(qr);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
