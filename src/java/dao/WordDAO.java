package dao;

import model.Word;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WordDAO {

    /**
     * Thêm từ vựng mới vào CSDL
     */
    public boolean insertWord(Word word) {
        String sql = "INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, word.getHanzi());
            ps.setNString(2, word.getPinyin());
            ps.setNString(3, word.getMeaningVi());
            ps.setInt(4, word.getHskLevel());
            ps.setNString(5, word.getTopic() != null ? word.getTopic() : "Từ vựng chung");
            ps.setNString(6, word.getExampleSentence());
            ps.setNString(7, word.getExampleMeaningVi());
            ps.setNString(8, word.getAudioUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách từ vựng có hỗ trợ Lọc HSK, Tìm kiếm từ khóa và Phân trang (Pagination)
     */
    public List<Word> getAllWords(int page, int pageSize, Integer hskLevel, String searchKeyword) {
        List<Word> words = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Words WHERE 1=1 ");
        
        if (hskLevel != null && hskLevel > 0) {
            sql.append(" AND HskLevel = ? ");
        }
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (Hanzi LIKE ? OR Pinyin LIKE ? OR MeaningVi LIKE ? OR Topic LIKE ?) ");
        }
        
        // Sắp xếp và phân trang SQL Server OFFSET FETCH
        sql.append(" ORDER BY HskLevel ASC, WordID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            
            if (hskLevel != null && hskLevel > 0) {
                ps.setInt(paramIndex++, hskLevel);
            }
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String kw = "%" + searchKeyword.trim() + "%";
                ps.setNString(paramIndex++, kw);
                ps.setNString(paramIndex++, kw);
                ps.setNString(paramIndex++, kw);
                ps.setNString(paramIndex++, kw);
            }
            
            int offset = (page - 1) * pageSize;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Word word = mapResultSetToWord(rs);
                    words.add(word);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return words;
    }

    /**
     * Đếm tổng số từ phục vụ tính số trang trong phân trang
     */
    public int getTotalWordsCount(Integer hskLevel, String searchKeyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Words WHERE 1=1 ");
        if (hskLevel != null && hskLevel > 0) {
            sql.append(" AND HskLevel = ? ");
        }
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND (Hanzi LIKE ? OR Pinyin LIKE ? OR MeaningVi LIKE ? OR Topic LIKE ?) ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (hskLevel != null && hskLevel > 0) {
                ps.setInt(paramIndex++, hskLevel);
            }
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String kw = "%" + searchKeyword.trim() + "%";
                ps.setNString(paramIndex++, kw);
                ps.setNString(paramIndex++, kw);
                ps.setNString(paramIndex++, kw);
                ps.setNString(paramIndex++, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy từ vựng theo ID
     */
    public Word getWordById(int id) {
        String sql = "SELECT * FROM Words WHERE WordID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToWord(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy tất cả từ vựng theo HSK Level
     */
    public List<Word> getWordsByHskLevel(int hskLevel) {
        List<Word> words = new ArrayList<>();
        String sql = "SELECT * FROM Words WHERE HskLevel = ? ORDER BY WordID ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, hskLevel);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    words.add(mapResultSetToWord(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return words;
    }

    /**
     * Cập nhật thông tin từ vựng
     */
    public boolean updateWord(Word word) {
        String sql = "UPDATE Words SET Hanzi = ?, Pinyin = ?, MeaningVi = ?, HskLevel = ?, Topic = ?, ExampleSentence = ?, ExampleMeaningVi = ?, AudioUrl = ? WHERE WordID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, word.getHanzi());
            ps.setNString(2, word.getPinyin());
            ps.setNString(3, word.getMeaningVi());
            ps.setInt(4, word.getHskLevel());
            ps.setNString(5, word.getTopic());
            ps.setNString(6, word.getExampleSentence());
            ps.setNString(7, word.getExampleMeaningVi());
            ps.setNString(8, word.getAudioUrl());
            ps.setInt(9, word.getWordId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa từ vựng khỏi CSDL theo ID
     */
    public boolean deleteWord(int id) {
        String sql = "DELETE FROM Words WHERE WordID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Word mapResultSetToWord(ResultSet rs) throws SQLException {
        return new Word(
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
    }

    /**
     * Nhập hàng loạt từ vựng từ Excel:
     * - Nếu từ chưa có -> INSERT mới.
     * - Nếu từ đã có -> Tùy chọn UPDATE (ghi đè dữ liệu mới) hoặc BỎ QUA (Skip).
     */
    public model.ImportResultDTO insertOrUpdateBatchWords(List<Word> words, boolean updateIfExists) {
        model.ImportResultDTO result = new model.ImportResultDTO();
        if (words == null || words.isEmpty()) {
            return result;
        }

        result.setTotalRows(words.size());

        String checkSql = "SELECT WordID FROM Words WHERE Hanzi = ?";
        String insertSql = "INSERT INTO Words (Hanzi, Pinyin, MeaningVi, HskLevel, Topic, ExampleSentence, ExampleMeaningVi, AudioUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String updateSql = "UPDATE Words SET Pinyin = ?, MeaningVi = ?, HskLevel = ?, Topic = ?, ExampleSentence = ?, ExampleMeaningVi = ? WHERE WordID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql);
             PreparedStatement insertPs = conn.prepareStatement(insertSql);
             PreparedStatement updatePs = conn.prepareStatement(updateSql)) {

            conn.setAutoCommit(false); // Bật Transaction

            int inserted = 0;
            int updated = 0;
            int skipped = 0;

            for (Word w : words) {
                if (w.getHanzi() == null || w.getHanzi().trim().isEmpty()) {
                    continue;
                }

                checkPs.setNString(1, w.getHanzi().trim());
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        int wordId = rs.getInt("WordID");
                        if (updateIfExists) {
                            // Cập nhật thông tin mới nhất
                            updatePs.setNString(1, w.getPinyin());
                            updatePs.setNString(2, w.getMeaningVi());
                            updatePs.setInt(3, w.getHskLevel());
                            updatePs.setNString(4, w.getTopic() != null ? w.getTopic() : "Từ vựng chung");
                            updatePs.setNString(5, w.getExampleSentence() != null ? w.getExampleSentence() : "");
                            updatePs.setNString(6, w.getExampleMeaningVi() != null ? w.getExampleMeaningVi() : "");
                            updatePs.setInt(7, wordId);
                            updatePs.executeUpdate();
                            updated++;
                            result.getUpdatedWords().add(w.getHanzi());
                        } else {
                            skipped++;
                            result.getSkippedWords().add(w.getHanzi());
                        }
                    } else {
                        // Thêm mới
                        insertPs.setNString(1, w.getHanzi().trim());
                        insertPs.setNString(2, w.getPinyin());
                        insertPs.setNString(3, w.getMeaningVi());
                        insertPs.setInt(4, w.getHskLevel());
                        insertPs.setNString(5, w.getTopic() != null ? w.getTopic() : "Từ vựng chung");
                        insertPs.setNString(6, w.getExampleSentence() != null ? w.getExampleSentence() : "");
                        insertPs.setNString(7, w.getExampleMeaningVi() != null ? w.getExampleMeaningVi() : "");
                        insertPs.setNString(8, "");
                        insertPs.executeUpdate();
                        inserted++;
                    }
                }
            }

            conn.commit(); // Hoàn tất Transaction
            result.setInsertedCount(inserted);
            result.setUpdatedCount(updated);
            result.setSkippedCount(skipped);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }
}
