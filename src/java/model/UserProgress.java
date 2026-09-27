package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class UserProgress implements Serializable {
    private int progressId;
    private int userId;
    private int wordId;
    private String status; // New, Learning, Mastered
    private int correctCount;
    private int wrongCount;
    private Timestamp lastReviewedAt;
    private Timestamp nextReviewAt;
    
    // Optional joined properties for display
    private Word word;

    public UserProgress() {
    }

    public UserProgress(int progressId, int userId, int wordId, String status, int correctCount, int wrongCount, Timestamp lastReviewedAt, Timestamp nextReviewAt) {
        this.progressId = progressId;
        this.userId = userId;
        this.wordId = wordId;
        this.status = status;
        this.correctCount = correctCount;
        this.wrongCount = wrongCount;
        this.lastReviewedAt = lastReviewedAt;
        this.nextReviewAt = nextReviewAt;
    }

    public int getProgressId() {
        return progressId;
    }

    public void setProgressId(int progressId) {
        this.progressId = progressId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getWordId() {
        return wordId;
    }

    public void setWordId(int wordId) {
        this.wordId = wordId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCorrectCount() {
        return correctCount;
    }

    public void setCorrectCount(int correctCount) {
        this.correctCount = correctCount;
    }

    public int getWrongCount() {
        return wrongCount;
    }

    public void setWrongCount(int wrongCount) {
        this.wrongCount = wrongCount;
    }

    public Timestamp getLastReviewedAt() {
        return lastReviewedAt;
    }

    public void setLastReviewedAt(Timestamp lastReviewedAt) {
        this.lastReviewedAt = lastReviewedAt;
    }

    public Timestamp getNextReviewAt() {
        return nextReviewAt;
    }

    public void setNextReviewAt(Timestamp nextReviewAt) {
        this.nextReviewAt = nextReviewAt;
    }

    public Word getWord() {
        return word;
    }

    public void setWord(Word word) {
        this.word = word;
    }
}
