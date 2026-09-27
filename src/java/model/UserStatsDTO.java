package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class UserStatsDTO implements Serializable {
    private int userId;
    private String username;
    private String email;
    private String role;
    private Timestamp createdAt;
    private int masteredCount;
    private int learningCount;
    private int totalQuizCount;
    private double avgQuizScore;
    private Timestamp lastActive;

    public UserStatsDTO() {
    }

    public UserStatsDTO(int userId, String username, String email, String role, Timestamp createdAt,
                        int masteredCount, int learningCount, int totalQuizCount, double avgQuizScore, Timestamp lastActive) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.role = role;
        this.createdAt = createdAt;
        this.masteredCount = masteredCount;
        this.learningCount = learningCount;
        this.totalQuizCount = totalQuizCount;
        this.avgQuizScore = avgQuizScore;
        this.lastActive = lastActive;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getMasteredCount() {
        return masteredCount;
    }

    public void setMasteredCount(int masteredCount) {
        this.masteredCount = masteredCount;
    }

    public int getLearningCount() {
        return learningCount;
    }

    public void setLearningCount(int learningCount) {
        this.learningCount = learningCount;
    }

    public int getTotalQuizCount() {
        return totalQuizCount;
    }

    public void setTotalQuizCount(int totalQuizCount) {
        this.totalQuizCount = totalQuizCount;
    }

    public double getAvgQuizScore() {
        return avgQuizScore;
    }

    public void setAvgQuizScore(double avgQuizScore) {
        this.avgQuizScore = avgQuizScore;
    }

    public Timestamp getLastActive() {
        return lastActive;
    }

    public void setLastActive(Timestamp lastActive) {
        this.lastActive = lastActive;
    }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.role);
    }
}
