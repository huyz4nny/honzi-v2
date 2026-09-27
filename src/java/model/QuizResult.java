package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class QuizResult implements Serializable {
    private int quizId;
    private int userId;
    private int hskLevel;
    private int score;
    private int totalQuestions;
    private Timestamp takenAt;

    public QuizResult() {
    }

    public QuizResult(int quizId, int userId, int hskLevel, int score, int totalQuestions, Timestamp takenAt) {
        this.quizId = quizId;
        this.userId = userId;
        this.hskLevel = hskLevel;
        this.score = score;
        this.totalQuestions = totalQuestions;
        this.takenAt = takenAt;
    }

    public QuizResult(int userId, int hskLevel, int score, int totalQuestions) {
        this.userId = userId;
        this.hskLevel = hskLevel;
        this.score = score;
        this.totalQuestions = totalQuestions;
    }

    public int getQuizId() {
        return quizId;
    }

    public void setQuizId(int quizId) {
        this.quizId = quizId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getHskLevel() {
        return hskLevel;
    }

    public void setHskLevel(int hskLevel) {
        this.hskLevel = hskLevel;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public Timestamp getTakenAt() {
        return takenAt;
    }

    public void setTakenAt(Timestamp takenAt) {
        this.takenAt = takenAt;
    }
    
    public double getPercentage() {
        if (totalQuestions == 0) return 0;
        return (double) score / totalQuestions * 100;
    }
}
